require "test/unit"
require_relative './crawler'

class CrawlerTest < Test::Unit::TestCase

  DEFAULT_OPTIONS={
    base_url: 'https://news.ycombinator.com/',
    requested_rows: 30
  }
  
  def test_create_entry

    # Creating a valid Entry object
    title_name = "Robert"
    rank = "1."
    fake_entry = "#{rank} #{title_name}"
    entry = Entry.new({title:title_name, order:rank, comments:'', points:''})
    assert_equal entry.to_s,fake_entry, 'Entry should have valid properties'

    # Creating an empty Entry object
    assert_raise {
          entry = Entry.new({title:'', order:'', comments:'', points:''})
    }
  end

  def test_fetching

    entries = setup
    
    assert_equal 30, entries.count, "Entries should return 30 entries"

  end

  def test_filter_more_than_words

    setup
    
    ordered_entries = @ycrawler.words_more_than(5, :comments)
    
    minor_one = ordered_entries.first.comments
    major_one = ordered_entries.last.comments
    
    assert_operator major_one,:>=,minor_one, "Entries should be sort by comments attr"
  end

  def test_filter_less_than_words

    setup
    
    ordered_entries = @ycrawler.words_less_than(5, :points)
    
    minor_one = ordered_entries.first.points
    major_one = ordered_entries.last.points
    
    assert_operator major_one,:>=,minor_one, "Entries should be ordered asc by comments attr"

  end

#  def test_fetching_incomplete_page
#    ycrawler = Crawler.new('https://news.ycombinator.com/news?p=18')
#    entries = ycrawler.fetch(30)
#    assert_not_equal 30, entries.count, "Entries should return less than 30 entries"
#  end  

  
  def setup
    @ycrawler = Crawler.new(DEFAULT_OPTIONS[:base_url])
    @ycrawler.fetch(DEFAULT_OPTIONS[:requested_rows])    
  end

  
end

