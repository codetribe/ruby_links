class UserController < ApplicationController

  def profile
    @title = current_user.email
    @links = Kaminari.paginate_array(current_user.links | current_user.jeweled_links).page(params[:page]).per(20)
  end
  
  def search
    @title = "Search for #{params[:s]}"
    @links = current_user.search_links(params[:s]).page(params[:page]).per(20)
    render :profile
  end

end
