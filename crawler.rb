# coding: utf-8
require 'nokogiri'
require 'httparty'
require 'byebug'
require_relative './entry.rb'

class Crawler
  DEFAULT_OPTIONS={
    parent_css:'.itemlist',
    score_css: 'tr:nth-child(2) .score',
    title_css: 'tr:first-child td.title:last-child .storylink',
    rank_css:  'tr:first-child td.title:first-child .rank',
    comments_css: 'tr:nth-child(2) .subtext a:last-child',
    rows: 'tr',
    more_css: 'tr:last-child',
    next_page_css: '.morelink'
  }
  
  attr_accessor:url
  attr_reader  :entries, :requested_rows, :no_more_rows

  protected :requested_rows, :no_more_rows

  def initialize(url)
    @url=url
    @host =  URI.parse(url).host.downcase
    @entries = []
  end

  # Scrap data from a url
  # Parameters
  # @requested_rows_number - Number of records to extract from html
  # 
  def fetch(requested_rows_number)
    #Preparing loop to iterate table rows
    @entries=Array.new
    @no_more_rows=false
    
    #mientras entradas.count=solicitados or final de page
    while @entries.count<requested_rows_number and @no_more_rows==false
      get_next_page(requested_rows_number-@entries.count)
    end

    @entries
  end

  def get_next_page(requested_rows)
    #Get Page
    raw_page    = scrape_page
    #Get entries in raw format
    raw_entries = raw_page.css(DEFAULT_OPTIONS[:parent_css])
    has_next_page = false
    
    #Get Next Url
    if raw_entries.css(DEFAULT_OPTIONS[:more_css]).text=="More"
      next_url = raw_entries.css(DEFAULT_OPTIONS[:next_page_css])[0]["href"]
      @url = ((next_url.include? "http") ? '':@host + '/') +   next_url

      2.times { raw_entries.css('tr:last-child').remove }

      has_next_page = true
    end

    parse_results(raw_entries, requested_rows, has_next_page)
  end

  def parse_results(raw_entries, requested_rows, has_next_page)
    i=0

    rendered_rows=(raw_entries.css(DEFAULT_OPTIONS[:rows]).count/3).to_i

    while (raw_entries.css(DEFAULT_OPTIONS[:rows]).count>0 and i<requested_rows)
      #Parsing text digits to integer
      comments= raw_entries.css(DEFAULT_OPTIONS[:comments_css])[1].text.gsub(/[^0-9]/, '') if raw_entries.css(DEFAULT_OPTIONS[:comments_css]).count>0

      points  = raw_entries.css(DEFAULT_OPTIONS[:score_css]).text.gsub(/[^0-9]/, '') if raw_entries.css(DEFAULT_OPTIONS[:score_css]).count>0
      
      @entries<<Entry.new({
                          title: raw_entries.css(DEFAULT_OPTIONS[:title_css]).text,
                          order:raw_entries.css(DEFAULT_OPTIONS[:rank_css]).text,
                          comments:comments,
                          points:points})
      
      #Cleaning raw_entries
      raw_entries.css('tr:first-child').remove
      raw_entries.css('tr:first-child').remove      
      raw_entries.css('tr:first-child').remove
      i+=1
    end
    @no_more_rows = true if rendered_rows<requested_rows and !has_next_page
  end
  
  # Filter all previous entries with more than five words in the title ordered by the amount of comments first.
  #
  # @max_words_in_title - Maximum number of words in the title
  # @order_key          - Class attribute to sort by
  # Returns
  # An array of objects Entry
  def words_more_than(max_words_in_title, order_key)
    entries.find_all{ |entry|  entry.title.split(' ').count>max_words_in_title}.sort_by(&order_key)
  end

  # Filter all previous entries with more than five words in the title ordered by the amount of comments first.
  #
  # @max_words_in_title - Maximum number of words in the title
  # @order_key          - Class attribute to sort by
  # Returns
  # An array of objects Entry
  def words_less_than(max_words_in_title, order_key)
    entries.find_all{ |entry|  entry.title.split(' ').count<=max_words_in_title}.sort_by(&order_key)
  end
  
  
  private

  # Scrape page into Nokogiri Objects
  def scrape_page
    @url = "https://#{@url}" if URI.parse(@url).scheme.nil?    
    Nokogiri::HTML(HTTParty.get(@url))
  end

end
