require 'benchmark'
require_relative './crawler'

include Benchmark

 DEFAULT_OPTIONS={
    base_url: 'https://news.ycombinator.com/',
    requested_rows: 30
  }
 Benchmark.benchmark(" "*10 + CAPTION, 10, "%10.6u %10.6y %10.6t %10.6r\n") do |x|

   x.report("Crawler.new") do
     ycrawler = Crawler.new(DEFAULT_OPTIONS[:base_url])
   end

   ycrawler = Crawler.new(DEFAULT_OPTIONS[:base_url])
   
   x.report("Crawler.fetch") do
     10.times do
       ycrawler.fetch(DEFAULT_OPTIONS[:requested_rows])
     end
   end

   ycrawler.fetch(DEFAULT_OPTIONS[:requested_rows])   
   
   x.report("Crawler.filter1") do
     10.times do
       ycrawler.words_less_than(5, :points)       
     end
   end

 end
