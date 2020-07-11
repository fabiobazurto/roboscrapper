# coding: utf-8
require_relative './crawler'
require 'csv'

 DEFAULT_OPTIONS={
    base_url: 'https://news.ycombinator.com/',
    requested_rows: 30
  }

 puts 'Scraping'
 ycrawler = Crawler.new(DEFAULT_OPTIONS[:base_url])
 ycrawler.fetch(DEFAULT_OPTIONS[:requested_rows])
 puts ycrawler.entries
 puts '--------------------------------------'
 puts 'Filtering words less than 5'
 puts ycrawler.words_less_than(5,:points).count
 puts ycrawler.words_less_than(5,:points)
 puts '--------------------------------------'
 puts 'Filtering words more than 5'
 puts ycrawler.words_more_than(5,:comments).count
 puts ycrawler.words_more_than(5,:comments)



 CSV.open('reserved.csv', 'w') { |csv| csv << ycrawler.entries }
