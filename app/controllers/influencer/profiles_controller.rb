class Influencer::ProfilesController < ApplicationController
  # Shows the influencer profiles
  def show
    @influencer = current_user.influencer
    @twitter_user = Twitter.user(@influencer.user.twitter_screen_name)
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
      render action: :edit_payment_data
    end
  end

end
