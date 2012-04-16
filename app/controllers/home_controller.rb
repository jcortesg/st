class HomeController < ApplicationController
  load_and_authorize_resource
  
  def index
    if current_user.user_type == "administrator"
      redirect_to all_users_path
    elsif current_user.user_type == "affiliate"
      redirect_to referrals_path
    else
      redirect_to tweets_path
    end
  end
end