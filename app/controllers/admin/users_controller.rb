class Admin::UsersController < ApplicationController
  def index
    @users = User.all_except_admin
  end
end
