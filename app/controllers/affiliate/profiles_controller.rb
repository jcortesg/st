class Affiliate::ProfilesController < ApplicationController
  before_filter :authenticate_user!, :require_advertiser

  # Shows the affiliate profiles
  def show
    @affiliate = current_user.affiliate
  end

  # Shows the contact data
  def contact_data
    @affiliate = current_user.affiliate
  end

  # Shows the form to edit the contact data
  def edit_contact_data
    @affiliate = current_user.affiliate
  end

  # Process the contact data
  def process_contact_data
    @affiliate = current_user.affiliate
    if @affiliate.update_attributes(params[:affiliate])
      flash[:success] = "Tus datos de contacto fueron actualizados."
      redirect_to action: :contact_data
    else
      render action: :edit_contact_data
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
end
