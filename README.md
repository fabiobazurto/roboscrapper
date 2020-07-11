# roboscrapper

Using the language that you feel most proficient in, you’ll have to create a web crawler using scraping techniques to extract the first 30 entries from https://news.ycombinator.com/ . You’ll only care about the title, a number of the order, the amount of comments and points for each entry.​

From there, we want it to be able to perform a couple of filtering operations:

    Filter all previous entries with more than five words in the title ordered by the amount of comments first.
    Filter all previous entries with less than or equal to five words in the title ordered by points.

# Requirements

1. ruby 2.3.X
1. rubygem 3.0.X
1. git 2.X


# Install

Follow the next steps:

    git clone https://github.com/fabiobazurto/roboscrapper.git
    
    cd roboscrapper
    
    bundle install

# Running Tests

ruby crawler_test.rb

# Running demo

ruby run.rb

# Benchmark

ruby benchmar.rb
