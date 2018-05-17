class UsersController < ApplicationController

  before_action :correct_user, only: [:show]
  before_action :admin_user, only: [:index]
  def index
    @users = User.all.sort
  end

  def show
    @user = User.find(params[:id])
    #flash[:success] = "Hello!"
  end


  #Confirms the correct user for see user profile - only owner and lunches admin allowed
  def correct_user
    @user = User.find_by_id(params[:id])
    if @user == nil || current_user == nil || ((current_user != @user) && (!current_user.lunches_admin?))  
      flash[:alert] = 'You not allowed to see other users profiles.'
      redirect_to(root_url)
    end
  end
  
  #Confirms an admin user for see list of users - only lunches admin allowed 
  def admin_user
    if (!current_user.lunches_admin?)  
      flash[:alert] = 'You not allowed to see list of users.'
      redirect_to(root_url)
    end
  end

end
