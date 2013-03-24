class Tag < ActiveRecord::Base
  attr_accessible :name


  def self.all_tags
    tags=Hash.new
    tags["tags"]=Array.new
    Tag.all.each do |tag|
      a=Hash.new
      a["tag"]=tag.name
      tags["tags"] << a
    end
    tags
  end

  def self.search_tags query
    Tag.where("name LIKE ?","%#{query}%")
  end

end
