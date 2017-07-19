class UsersController < ApplicationController
  before_action :correct_user, only: [:show]
  before_action :admin_user, only: [:index]
  def index
    @users = User.all.sort
  end

  def show
    @user = User.find(params[:id])
    flash[:success] = "Hello!"
  end


  #Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    if (current_user != @user) && (!current_user.is_lunches_admin?)  
      flash[:alert] = "You not allowed to see other user profiles."
      redirect_to(root_url)
    end
  end
  
  #Confirms an admin user
  def admin_user
    if (!current_user.is_lunches_admin?)  
      flash[:alert] = "You not allowed to see list of users."
      redirect_to(root_url)
    end
  end

end
