class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_many :links
  has_many :jewels
  has_many :comments
  has_many :jeweled_links, through: :jewels, source: :link
  
  def search_links search_string=nil
    #p search_string
    search_conditions = []
    if search_string
      columns = ["title", "description"] # what columns needs to be searched
      words = search_string.split(/\s+/)
      for word in words
        column_conditions = []
        for column in columns
          #search string sanitized
          column_conditions << ActiveRecord::Base.send(:sanitize_sql_array,[" lower(#{column}) like ?","%#{word.downcase}%"])
        end
        search_conditions << "(#{column_conditions.join(' or ')})"
      end
    end
    
    search_query = search_conditions.join ' and '
    link_ids = self.jeweled_links.select("links.id") | self.links.select(:id)
    Link.where(id: link_ids).where(search_query).order('jewel desc')
  end
end
