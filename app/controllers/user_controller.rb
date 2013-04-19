class UserController < ApplicationController

  def profile
    @title = current_user.email
    @links = Kaminari.paginate_array(current_user.links | current_user.jeweled_links).page(params[:page]).per(20)
  end
  
  def links_search search_string
    # construct a search query
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
    
    search_query = seearch_conditions.join ' and '
    link_ids = self.jeweled_links.select("links.id") | 
  end

end
