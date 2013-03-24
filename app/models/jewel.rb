class Jewel < ActiveRecord::Base
  attr_accessible :link_id, :user_id
  belongs_to :user
  belongs_to :link

  ##
  # Returns the number of jewels associated with a link [ args={:link=>@link} ]
  # or with a user [ args={:user=>@user} ] or with both [ args={:link=>@link,:user=>@user} ]
  ##
  def self.jewel_count args={}
    if args[:user]&&args[:link]
      Jewel.where(:user_id=>args[:user].id,:link_id=>args[:link].id).count
    elsif args[:link]
      Jewel.where(:link_id=>args[:link].id).count
    elsif args[:user]
      Jewel.where(:user_id=>args[:user].id).count
    else
      return 0
    end

  end
end
