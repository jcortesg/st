class HomeController < ApplicationController
  include ApplicationHelper

  def index
    redirect_to home_path_for(current_user)
  end
end