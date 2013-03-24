class Comment < ActiveRecord::Base
  belongs_to :link
  belongs_to :user
  attr_accessible :content,:link_id

  def belongs_to_user? user
    if user.nil?
      false
    else
      user.id==self.user.id
    end
  end
end
