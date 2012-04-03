class HomeController < ApplicationController
  load_and_authorize_resource
  
  def index
    if current_user.user_type == "administrator"
      redirect_to "/users/all"
    elsif current_user.user_type == "affiliate"
      redirect_to "/referrals"
    else
      redirect_to "/tweets"
    end
  end
end