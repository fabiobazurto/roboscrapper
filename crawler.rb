# coding: utf-8
require 'nokogiri'
require 'httparty'
require 'byebug'
require_relative './entry.rb'

class Crawler
  DEFAULT_OPTIONS={
    parent_css:'.itemlist',
    score_css: '.score',
    title_css: '.storylink',
    rank_css: '.rank',
    comments_css: '.subtext'
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
    raw_entries = raw_page.css(DEFAULT_OPTIONS[:parent_css]).css('tr')

    parse_results(raw_entries, requested_rows_number-1)
  end


  def parse_results(raw_entries, number_of_rows)
    #Preparing loop to iterate table rows
    @entries=Array.new
    current_index = 0
    saved_entries_counter = 0
    total_rows = raw_entries.count

    while saved_entries_counter<=number_of_rows and current_index<=total_rows-1

      data_entry = raw_entries[current_index]
      additional_data = raw_entries[current_index+1]

      #Parsing text digits to integer
      comments=additional_data.css(DEFAULT_OPTIONS[:comments_css]).css('a')[3].text.gsub(/[^0-9]/, '') if additional_data.css(DEFAULT_OPTIONS[:comments_css]).css('a').count>3 
                 #.chars.map {|x| x[/\d+/]}.join 
      points  =additional_data.css(DEFAULT_OPTIONS[:score_css]).text.gsub(/[^0-9]/, '') if additional_data.css(DEFAULT_OPTIONS[:score_css]).count>0
      
      
      @entries<<Entry.new({
                          title:data_entry.css(DEFAULT_OPTIONS[:title_css]).text,
                          order:data_entry.css(DEFAULT_OPTIONS[:rank_css]).text,
                          comments:comments,
                          points:points})

      saved_entries_counter = saved_entries_counter+1
      current_index = current_index+3

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
