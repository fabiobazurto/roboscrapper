require "test/unit"
require_relative './crawler'

class CrawlerTest < Test::Unit::TestCase
  def test_fetching
    ycrawler = Crawler.new('https://news.ycombinator.com/')
    entries = ycrawler.fetch(30)
    byebug
    assert_equal 30, entries.count, "Entries should return 30 entries"
  end

  def test_fetching_incomplete_page
    ycrawler = Crawler.new('https://news.ycombinator.com/news?p=18')
    entries = ycrawler.fetch(30)
    byebug
    assert_not_equal 30, entries.count, "Entries should return less than 30 entries"
  end  

end

