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
    more_css: 'tr:last-child'
  }
  

  attr_accessor :url, :entries


  def initialize(url)
    @url=url
    @entries = []
  end

  # Scrap data from a url
  # Parameters
  # @requested_rows_number - Number of records to extract from html
  # 
  def fetch(requested_rows_number)
    #Setup config to variables
    raw_page    = scrape_page
    raw_entries = raw_page.css(DEFAULT_OPTIONS[:parent_css])

    parse_results(raw_entries, requested_rows_number-1)
  end


  def parse_results(raw_entries, number_of_rows)
    #Preparing loop to iterate table rows
    @entries=Array.new
 
    raw_entries.css(DEFAULT_OPTIONS[:more_css]).remove if raw_entries.css(DEFAULT_OPTIONS[:more_css]).text=="More"

    while raw_entries.css(DEFAULT_OPTIONS[:rows]).count>1

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
 

    end

    @entries    
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
    Nokogiri::HTML(HTTParty.get(@url))
  end

end
