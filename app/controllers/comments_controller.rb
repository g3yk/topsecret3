class CommentsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @comments = Post.find(params[:post_id]).comments.ordered

  end
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user



  if @comment.save
    Notification.create(user_trigger_id: current_user.id, user_target_id: @post.user.id, message: "#{current_user.username} commented on your post.")
    render json: { 
      username: @comment.user.username,
      content: @comment.content,
      created_at: @comment.created_at,
      comment_id: @comment.id,
      is_current_user: current_user == @comment.user
    }, status: :created
  else
    render json: { error: "Unable to save comment" }, status: :unprocessable_entity
    end
  end
  

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])

    if @comment.user == current_user
      @comment.destroy
      redirect_to root_path, notice: "Comment deleted."
    else
      redirect_to root_path, alert: "You can only delete your own comments."
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :user_id, :post_id)
  end
  
end
