class AdminController < ApplicationController
  load_and_authorize_resource
  rescue_from CanCan::AccessDenied do | exception |
    flash[:notice] = "Admin can access this page"
    redirect_back(fallback_location: root_path)
  end

  def show_users
    @admin = current_user
    @users = User.all
  end

end
