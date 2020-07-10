require 'nokogiri'
require 'httparty'
require 'byebug'
require_relative './entry.rb'

class Crawler
  DEFAULT_OPTIONS={
    parent_css:'.itemlist'
  }
  

  attr_accessor :url, :entries


  def initialize(url)
    @url=url
    @entries = []
  end

  def fetch(requested_rows_number)
    #Setup config to variables
    raw_page    = scrape_page
    raw_entries = raw_page.css(DEFAULT_OPTIONS[:parent_css]).css('tr')

    #Preparing loop to iterate table rows

    current_index = 0
    saved_entries_counter = 0
    max_loop = requested_rows_number-1
    
    while saved_entries_counter<requested_rows_number and current_index<raw_entries.count

      #byebug
      data_entry = raw_entries[current_index]
      additional_data = raw_entries[current_index+1]

      comments=additional_data.css('.subtext').css('a')[3].text if additional_data.css('.subtext').css('a').count>3 
      points  =additional_data.css('.score').text if additional_data.css('.score').count>0
      
      
      @entries<<Entry.new(
                          data_entry.css('.storylink').text,
                          data_entry.css('.rank').text,
                          comments,
                          points)

      saved_entries_counter=saved_entries_counter+1
      current_index=current_index+3
    end
    @entries
  end

  private
  def scrape_page
    Nokogiri::HTML(HTTParty.get(@url))
  end

end
