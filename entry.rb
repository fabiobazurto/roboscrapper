class Entry
  attr_accessor  :order, :title, :comments, :points

  def initialize( attributes={})
    
    validate_blank [:title,:order], attributes, ""
    
    @title = attributes[:title]
    @order = attributes[:order]
    @comments = attributes[:comments].to_i||0
    @points = attributes[:points].to_i||0
    
  end

  def title=(title)
    title if validate_blank(:title,title)
  end
  
  def comments=(comments)
    validate_blank(:title,comments)
  end

  #Public Methods
  def to_s
    "#{@order}. #{@title}"
  end
  

  private

  def validate_blank(key,value)
    if value=="" or value.nil?
      raise "#{key} can't be blank"
    end
    true
  end
  def validate_blank(validating_keys,attrs,comparision_value)
    validating_keys.each{|key|
      if attrs[key]==comparision_value or attrs[key].nil?
        raise "#{key} can't be blank"
      end
    }
    
    true
  end
  
end
