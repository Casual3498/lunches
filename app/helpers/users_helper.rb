module UsersHelper


  #Returns true if the given user is the current user
  def is_current_user?(user)
    current_user == user
  end  
end
