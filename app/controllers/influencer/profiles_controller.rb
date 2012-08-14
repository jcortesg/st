# encoding: utf-8
class Influencer::ProfilesController < ApplicationController
  before_filter :authenticate_user!, :check_twitter_linked, :require_influencer

  # Shows the influencer profiles
  def show
    @influencer = current_user.influencer
    @twitter_user = Twitter.user(@influencer.user.twitter_screen_name) rescue nil
  end

  # Shows the form to edit the profiles
  def edit
    @influencer = current_user.influencer
  end

  # Process the user profiles
  def update
    @influencer = current_user.influencer
    if @influencer.update_attributes(params[:influencer])
      flash[:success] = "Tus perfil fue actualizado."
      redirect_to influencer_profile_path
    else
      flash.now[:error] = "No se pudo actualizar tu perfil."
      render action: :edit_contact_data
    end
  end

  # Shows the contact data
  def contact_data
    @influencer = current_user.influencer
  end

  # Shows the form to edit the contact data
  def edit_contact_data
    @influencer = current_user.influencer
  end

  # Process the contact data
  def process_contact_data
    @influencer = current_user.influencer
    if @influencer.update_attributes(params[:influencer])
      flash[:success] = "Tus datos de contacto fueron actualizados."
      redirect_to influencer_profile_path
    else
      flash.now[:error] = "No se pudo actualizar tus datos de contacto."
      render action: :edit_contact_data
    end
  end

  # Shows the payment data
  def payment_data
    @influencer = current_user.influencer
  end

  # Shows the form to edit the payment data
  def edit_payment_data
    @influencer = current_user.influencer
  end

  # Process the payment data
  def process_payment_data
    @influencer = current_user.influencer
    if @influencer.update_attributes(params[:influencer])
      flash[:success] = "Tus datos de cobros fueron actualizados."
      redirect_to influencer_profile_path
    else
      flash.now[:error] = "No se pudo actualizar tus datos de cobros."
      render action: :edit_payment_data
    end
  end

  # Updates the photo profile
  def update_photo
    @influencer = current_user.influencer
    if @influencer.update_attributes(params[:influencer])
      if params[:influencer] && params[:influencer][:photo]
        flash[:success] = "Tu foto de perfil fue actualizada"
      else
        flash[:notice] = "Debes de ingresar una foto para actualizar tu foto de perfil"
      end
      redirect_to influencer_profile_path
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

  #shows best time
  def best_time
    @influencer = current_user.influencer
  end
end
