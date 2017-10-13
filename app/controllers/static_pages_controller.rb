class StaticPagesController < ApplicationController
skip_before_action :authenticate_user!, only: [:privacy_notice, :conditions_of_use, :home]
#skip_before_action :authenticate_user_from_token!


  def privacy_notice
  end

  def conditions_of_use
  end

  def home
  end
end
