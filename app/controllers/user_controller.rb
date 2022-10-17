class UserController < ApplicationController
  load_and_authorize_resource
  rescue_from CanCan::AccessDenied do | exception |
    flash[:notice] = "You are not admin"
    redirect_back(fallback_location: root_path)
    before_action :get_user
  end

  def change_plan

    @admin = current_user


  end

  def update
    @admin = current_user

    @user.update(user_params)
    if @user.save
      redirect_to showUser_path

    else format.xml { render :xml => change_plan_admin_user_path(@admin, user), :status => :unprocessable_entity }
    end
  end

  def show
    @admin = current_user

  end

  protected
  def get_user
    @user  = User.find(params[:id])
  end
  def user_params
    params.require(:user).permit(:username, :plan)
  end
end
