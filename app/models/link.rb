class Link < ActiveRecord::Base
  attr_accessible :description, :img, :title, :url,:user_id
  acts_as_taggable
  validates :url, :title, presence: true
  validates :url, uniqueness: true
  has_many :jewels, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :user


  def jewel_it current_user
    if Jewel.jewel_count({:link=>self, :user=>current_user})==0
      Jewel.create(:link_id=>self.id,:user_id=>current_user.id)
      self.jewel = self.jewel+1
      self.save
    end
  end

  ##
  # Used when the user wants to remove his jewel from the link
  def un_jewel current_user
    if Jewel.jewel_count({:link=>self, :user=>current_user})==1
      Jewel.where("link_id = #{self.id} and user_id = #{current_user.id}").first.destroy
      self.jewel = self.jewel-1
      self.save
    end
  end

  ##
  # Returns Jewel if user has jeweled the link
  def jeweled_by? current_user
    self.jewels.where(user_id: current_user.id).first
  end

  def belongs_to_user? user = nil
    if user.nil?
      false
    else
      self.user == user
    end
  end


  def self.imgs_from_url url
    url.chomp! '/'
    agent = Mechanize.new
    page = agent.get(url)
    images = page.search("img")
    srcs=Array.new
    count=0
    images.each do |img|
      #puts img.attributes["src"]
      src=img.attributes["src"].value
      src=URI.join(url,src).to_s
      srcs << src
      count+=1
      if count==6
        break
      end
    end
    srcs
  end

  # searches records in locations table with the given criteria
  def self.search search_string = nil
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
    condition = []
    condition << "(#{search_conditions.join(' and ')})" if search_string
    # condition << "customer_id = #{customer.id}" if customer
    # condition << "user_id = #{user.id}" if user
    # condition << "records.created_at >= '#{start_time.beginning_of_day.to_formatted_s(:db)}'" if start_time and end_time
    # condition << "records.created_at <= '#{end_time.end_of_day.to_formatted_s(:db)}'" if start_time and end_time
    query = condition.join(' and ')
    # p query
    self.where(query) # sql injection attack must be checked
  end

  ##
  # returns youtube embed html if its a youtube video
  def youtube
    youtube_embed = '<iframe title="YouTube video player" width="640" height="390" src="http://www.youtube.com/embed/VIDEO_ID" frameborder="0" allowfullscreen></iframe>'    
    if self.url =~ /.*http:\/\/(\w+\.)?youtube.com\/watch.*/
      self.url.match(/v=(\w+)/)
      return youtube_embed.gsub(/VIDEO_ID/, $1)  
    end
    return nil
  end
  
  ##
  # returns vimeo embed html if its a youtube video
  def vimeo
    vimeo_embed = "<iframe src=\"http:\/\/player.vimeo.com\/video\/VIDEO_ID\" width=\"640\" height=\"390\" frameborder=\"0\" webkitAllowFullScreen mozallowfullscreen allowFullScreen><\/iframe>"    
    if self.url =~ /.*http:\/\/(\w+\.)?vimeo.com\/(\d+).*/
      return vimeo_embed.gsub(/VIDEO_ID/, $2)  
    end
    return nil
  end
end
