class GroupsController < ApplicationController
  load_and_authorize_resource
  rescue_from CanCan::AccessDenied do | exception |
    flash[:notice] = "User is not admin nor premium"
    redirect_back(fallback_location: root_path)
  end
  before_action :get_group, only: [:show, :edit, :update, :join, :show_request, :accept_request, :generate_url]

  def index
    @groups = Group.page(params[:page]).per(10).order(id: :asc)
  end

  def new
    @group = current_user.groups.new
  end

  def create
    @group = current_user.groups.create(group_params)
    @join  = @group.memberships.build(:user_id => current_user.id, :req => 1)
    respond_to do | format |
      if !(@group.save || @join.save)
        format.html { render :new, status: :unprocessable_entity }

      else UserMailer.with(user: current_user, group: @group).send_email.deliver_now
        format.html { redirect_to root_path, notice: "Group was successfully created." }
      end
    end
  end

  def edit
    @group.image.attach(params[:image])

  end

  def update
    redirect_to root_path, :notice => "Group was successfully updated" if @group.update(group_params)

  end

  def show_request
    @membership = @group.memberships

  end

  def accept_request

    @membership = @group.memberships.find_by_user_id(@user.id)
    @membership.update(req: true)
    redirect_back(fallback_location: root_path) if @membership.save

  end

  def show
    redirect_to root_path, notice: "You are not member of this group" if !@group.check_request_status(current_user)
    @post = @group.posts.all
  end

  def join

    if @group.group_type != "Public"
      @join = @group.memberships.build(:user_id => current_user.id, :req => 0)
      respond_to do | format |
        @join.save ? format.html { redirect_to(root_path, :notice => "request successfuly send") } :
          format.html { redirect_to(user_group_path(current_user, @group), :notice => "You have already joined this group") }
      end
    else @join = @group.memberships.build(:user_id => current_user.id, :req => 1)
    respond_to do | format |
      @join.save ? format.html { redirect_to(user_group_path(current_user, @group), :notice => "You have joined this group.") } :
        format.html { redirect_to(user_group_path(current_user, @group), :notice => "You have already joined this group") }
    end
    end

  end

  private

  def group_params
    params.require(:group).permit(:title, :group_type, :image, pictures: [])

  end

  def get_group
    @group = Group.find(params[:id])
    @user  = User.find(params[:user_id])
  end

end
