class Entry
  attr_accessor :id, :order, :title, :comments, :points

  def initialize(id, title, order, comments, points)
    @id= id
    @order = order
    @comments = comments
    @points = points
    
  end
  
end
