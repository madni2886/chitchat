class PostsController < ApplicationController
  load_and_authorize_resource
  rescue_from CanCan::AccessDenied do | exception |
    flash[:notice] = "User not found"
    redirect_back(fallback_location: root_path)
  end
  before_action :get_group, only: [:index,:new,:create,:show]
  before_action :get_post, only: [:show]
  def index
    @post  = Post.all
  end

  def new
    @post  = @group.posts.new
  end

  def create
    @post      = @group.posts.new(post_params)
    @post.user = current_user
    respond_to do | format |
      if @post.save
        format.html { redirect_to user_group_path(current_user, @group), notice: "Atricle was successfully created." }
      else format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def show_posts
    @post = Post.all
  end

  def show
  end

  private
  def get_group
    @group = Group.find(params[:group_id])
  end
  def get_post
    @post  = @group.posts.find(params[:id])
  end
  def post_params
    params.require(:post).permit(:title, :description, :post_type)
  end

end