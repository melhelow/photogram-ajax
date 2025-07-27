class LikesController < ApplicationController
  before_action :set_like, only: %i[ destroy ]

  # POST /likes or /likes.json
  def create
  @like = Like.new(like_params)
  @like.fan = current_user

  respond_to do |format|
    if @like.save
      format.html { redirect_back fallback_location: root_path, notice: "Like added." }
      format.js   # ← this tells Rails to render create.js.erb
    else
      format.html { redirect_back fallback_location: root_path, alert: "Like failed." }
      format.js { render 'create_error' } # optional, needs create_error.js.erb
    end
  end
end


  # DELETE /likes/1 or /likes/1.json
  def destroy
  @like = Like.find(params[:id])
  @like.destroy

  respond_to do |format|
    format.html { redirect_back fallback_location: root_path, notice: "Like removed." }
    format.js   # ✅ This handles JS requests
  end
end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_like
      @like = Like.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def like_params
      params.require(:like).permit(:fan_id, :photo_id)
    end
end
