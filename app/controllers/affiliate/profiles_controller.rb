# encoding: utf-8
class Affiliate::ProfilesController < ApplicationController
  before_filter :authenticate_user!, :require_affiliate

  # Shows the affiliate profiles
  def show
    @user = current_user
    @affiliate = current_user.affiliate
  end

  # Shows the contact data
  def my_data
    @user = current_user
  end

  # Shows the form to edit the contact data
  def edit
    @user = current_user
  end

  # Process the update of the affiliate data
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:success] = "Tus datos fueron actualizados."
      redirect_to action: :show
    else
      flash.now[:error] = "No se pudo actualizar tus datos de contacto."
      render action: :edit
    end
  end

  # Shows the payment data
  def payment_data
    @affiliate = current_user.affiliate
  end

  # Shows the form to edit the payment data
  def edit_payment_data
    @affiliate = current_user.affiliate
  end

  # Process the payment data
  def process_payment_data
    @affiliate = current_user.affiliate
    if @affiliate.update_attributes(params[:affiliate])
      flash[:success] = "Tus datos de cobros fueron actualizados."
      redirect_to action: :payment_data
    else
      flash.now[:error] = "No se pudo actualizar tus datos de cobros."
      render action: :edit_payment_data
    end
  end

  # Updates the photo profile
  def update_photo
    @affiliate = current_user.affiliate
    if @affiliate.update_attributes(params[:affiliate])
      if params[:affiliate] && params[:affiliate][:photo]
        flash[:success] = "Tu foto de perfil fue actualizada"
      else
        flash[:notice] = "Debes de ingresar una foto para actualizar tu foto de perfil"
      end
      redirect_to affiliate_profile_path
    else
      render action: show
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
