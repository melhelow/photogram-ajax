class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ edit update destroy ]
  before_action :ensure_current_user_is_owner, only: %i[ edit update destroy ]

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments or /comments.json
 def create
  @comment = Comment.new(comment_params)
  @comment.author = current_user

  respond_to do |format|
    if @comment.save
      format.html { redirect_back fallback_location: root_path, notice: "Comment was successfully created." }
      format.json { render :show, status: :created, location: @comment }
      format.js
    else
      format.js { render template: "comments/create_error" }
    end
  end
end


  # PATCH/PUT /comments/1 or /comments/1.json
def update
  @comment = Comment.find(params[:id])

  if @comment.update(comment_params)
    respond_to do |format|
      format.html { redirect_to request.referer || root_path, notice: "Comment updated." }
      format.js   # Looks for update.js.erb
    end
  else
    respond_to do |format|
      format.html { render :edit }
      format.js   # Optionally render a JS error partial or just leave it blank
    end
  end
end


  # DELETE /comments/1 or /comments/1.json
def destroy
    @comment.destroy

    respond_to do |format|
      format.html { redirect_back fallback_location: root_url, notice: "Comment was successfully destroyed." }
      format.json { head :no_content }
      format.js   # renders destroy.js.erb
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def ensure_current_user_is_owner
    if current_user != @comment.author
      redirect_back fallback_location: root_url, alert: "You're not authorized for that."
    end
  end

  def comment_params
    params.require(:comment).permit(:author_id, :photo_id, :body)
  end
end
