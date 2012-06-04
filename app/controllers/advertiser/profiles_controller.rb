# encoding: utf-8
class Advertiser::ProfilesController < ApplicationController
  before_filter :authenticate_user!, :require_advertiser

  # Shows the user profile
  def show
    @user = current_user
  end

  # Shows the form to update the profile
  def edit
    @user = current_user
  end

  # Updates the user profile
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:success] = "Tus datos fueron actualizados."
      redirect_to action: :show
    else
      render action: :edit
    end
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