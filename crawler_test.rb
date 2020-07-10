require "test/unit"
require_relative './crawler'

class CrawlerTest < Test::Unit::TestCase
  def test_fetching
    ycrawler = Crawler.new('https://news.ycombinator.com/')
    entries = ycrawler.fetch(30)
    assert_equal 30, entries.count, "Entries should return 30 entries"
  end

end

