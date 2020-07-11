require "test/unit"
require_relative './crawler'

class CrawlerTest < Test::Unit::TestCase
  def test_create_entry

    # Creating a valid Entry object
    title_name = "Robert"
    rank = "1"
    entry = Entry.new({title:title_name, order:rank, comments:'', points:''})
    assert_equal entry.to_s,title_name, 'Entry should have valid properties'

    # Creating an empty Entry object
    assert_raise {
          entry = Entry.new({title:'', order:'', comments:'', points:''})
    }
  end
  
  def test_fetching
    ycrawler = Crawler.new('https://news.ycombinator.com/')
    entries = ycrawler.fetch(30)
    
    assert_equal 30, entries.count, "Entries should return 30 entries"

  end

#  def test_fetching_incomplete_page
#    ycrawler = Crawler.new('https://news.ycombinator.com/news?p=18')
#    entries = ycrawler.fetch(30)
#    assert_not_equal 30, entries.count, "Entries should return less than 30 entries"
#  end  

  def test_filter_more_than_words
    ycrawler = Crawler.new('https://news.ycombinator.com/')
    ycrawler.fetch(30)
    
    ordered_entries = ycrawler.words_more_than(5, :comments)
    
    minor_one = ordered_entries.first.comments
    major_one = ordered_entries.last.comments
    
    assert_operator major_one,:>=,minor_one, "Entries should be sort by comments attr"
  end

  def test_filter_less_than_words
    ycrawler = Crawler.new('https://news.ycombinator.com/')
    ycrawler.fetch(30)
    
    ordered_entries = ycrawler.words_less_than(5, :points)
    
    minor_one = ordered_entries.first.points
    major_one = ordered_entries.last.points
    
    assert_operator major_one,:>=,minor_one, "Entries should be ordered asc by comments attr"

  end
  
  
end

