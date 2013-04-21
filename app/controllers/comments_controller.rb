class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.json
  before_filter :authenticate_user!
  before_filter :comment_must_belong_to_user, :except =>[:new, :show, :index, :create]

  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(params[:comment])
    @comment.user=current_user
    respond_to do |format|
      if @comment.save
        format.html {render "show", :layout=>false }
        format.json { render json: {:id=>@comment.id,:comment=>@comment.content,:user_email=>@comment.user.email,:time=>@comment.created_at.to_s(:long),:user_id=>@comment.user_id}, status: :created }
      else
        format.html 
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update

    unless params[:commit] == "Cancel"
      respond_to do |format|
        if @comment.update_attributes(params[:comment])
          format.html { redirect_to :back, notice: 'Comment was successfully updated.' }
          format.json { head :no_content }
          format.js
        else
          format.html { render action: "edit" }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
          format.html { redirect_to :back, notice: 'Comment was not updated.' }
          format.json { head :no_content }
          format.js
       end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to comments_url }
      format.json { head :no_content }
    end
  end

  def edit_form
    @comment = Comment.find params[:id]
    render :layout => false
  end

  private
  def comment_must_belong_to_user
    @comment = Comment.find params[:id]
    redirect_to new_user_session_path, notice: "You do not have permission for this" unless @comment.user == current_user
  end
end
