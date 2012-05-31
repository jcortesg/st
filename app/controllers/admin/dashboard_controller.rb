# encoding: utf-8
class Admin::DashboardController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin

  def index
  end

  # Shows the form to change the password
  def change_password
    @user = current_user
    render template: '/shared/profiles/change_password'
  end

  # Updates the password
  def update_password
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:success] = "Tu contraseña fue modificada."
      @user.reload
      sign_in(@user)
      redirect_to home_path_for(@user)
    else
      flash[:error] = "Hubo un error al actualizar tu contraseña."
      render template: '/shared/profiles/change_password'
    end
  end
end
