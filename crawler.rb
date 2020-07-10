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

  def fetch(number_of_entries)
    #Setup config to variables
    raw_page    = scrape_page
    raw_count   = raw_page.css(DEFAULT_OPTIONS[:parent_css]).count
    raw_entries = raw_page.css(DEFAULT_OPTIONS[:parent_css]).css('tr')

    #Preparing loop to iterate table rows
    pending_entries = number_of_entries
    current_index = 0
    until pending_entries==0
      rank = raw_entries[current_index].css('.rank').text
      title = raw_entries[current_index].css('.storylink').text
      score = raw_entries[current_index+1].css('.score').text
      comments = raw_entries[current_index+1].css('.subtext').css('a')[3].text

      @entries<<Entry.new(1,title,rank,comments,score)

      pending_entries=pending_entries-1
      current_index=+3
    end
    @entries
  end

  private
  def scrape_page
    Nokogiri::HTML(HTTParty.get(@url))
  end

end
