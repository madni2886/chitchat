class CommentsController < ApplicationController
  load_and_authorize_resource
  before_action :get_this
  protect_from_forgery with: :null_session

  def new
    @comments = Comment.new
  end

  def index
    @comments = Comment
  end

  def create
    @comments      = @post.comments.build(comment_params)
    @comments.user = current_user
    @comments.save
  end

  private
  def get_this
    @group = Group.find(params[:group_id])
    @post  = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content, :user_id, :post_id)
  end
end

