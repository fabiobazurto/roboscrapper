class Entry
  attr_accessor :id, :order, :title, :comments, :points

  def initialize( title, order, comments, points)
    @title = title
    @order = order
    @comments = comments
    @points = points
    
  end
  
end
