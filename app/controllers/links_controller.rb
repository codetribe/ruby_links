class LinksController < ApplicationController

  before_filter :authenticate_user!, :except=> ["index","show","tag","tags_source","search_tags", "search"]
  before_filter :link_must_belng_to_user, :only=> [:update, :destroy, :edit]


  # GET /links
  # GET /links.json
  def index
    @links = Link.order('created_at DESC').page(params[:page]).per(20)
    @title="All Links"
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @links }
    end
  end

  def tag
    tag=params[:tag]
    @title=tag
    @links=Link.tagged_with(tag).order('created_at DESC').page(params[:page]).per(20)

    render :index
  end


  # GET /links/1
  # GET /links/1.json
  def show
    @link = Link.find(params[:id])
    @comments=@link.comments.page(params[:page]).per(20)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @link }
    end
  end

  # GET /links/new
  # GET /links/new.json
  def new
    @link = Link.new
    @current_tags=""
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @link }
    end
  end

  # GET /links/1/edit
  def edit
    @current_tags=@link.tags.join(',')
  end

  def tags_source
      tags=Tag.all_tags
      respond_to do |format|
        #format.html
        format.json { render json: tags }
      end
  end

  def search_tags
    query=params[:q]
    results=Tag.search_tags(query).map(&:name)

    respond_to do |format|
      format.json { render json: {:query=>query,:results=>results,:count=>results.count} }
    end

  end

  def get_images
    url=params[:url]
    images=Link.imgs_from_url(url)
    respond_to do |format|
        #format.html
        format.json { render json: images }
      end
  end
  # POST /links
  # POST /links.json
  def create
    @link = Link.new(params[:link])
    @link.tag_list=params["hidden-tags"]

    respond_to do |format|
      if @link.save
        format.html { redirect_to @link, notice: 'Link was successfully created.' }
        format.json { render json: @link, status: :created, location: @link }
      else
        format.html { render action: "new" }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /links/1
  # PUT /links/1.json
  def update
    @link = Link.find(params[:id])

    respond_to do |format|
      if @link.update_attributes(params[:link])
        @link.tag_list=params["hidden-tags"]
        @link.save
        format.html { redirect_to @link, notice: 'Link was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  def jewel_it
    @link=Link.find(params[:id])
    @link.jewel_it(current_user)
    respond_to do |format|
      format.json { render json: Jewel.jewel_count({:link=>@link}) }
      format.js
    end
  end

  def un_jewel
    @link=Link.find(params[:id])
    @link.un_jewel(current_user)
    respond_to do |format|
      format.json { render json: Jewel.jewel_count({:link=>@link}) }
      format.js
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    @link = Link.find(params[:id])
    @link.destroy

    respond_to do |format|
      format.html { redirect_to links_path, notice: "Link has been removed" }
      format.json { head :no_content }
    end
  end

  def search
    redirect_to({action: :index}, notice: "Search is empty") if params[:s].strip.empty?
    @links = Link.search(params[:s]).page(params[:page]).per(20)
  end

  def link_must_elong_to_user
    @link = Link.find(params[:id])
    redirect_to(links_path, notice: "Oops! You can't do thothis if you did not create the link") unless @link.user == curent_user
  end
end
