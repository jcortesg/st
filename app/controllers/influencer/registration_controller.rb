class Influencer::RegistrationController < ApplicationController
  before_filter :authenticate_user!, :except => [:new, :create]
  before_filter :check_twitter_credentials, :only => [:new, :create]

  # Shows the form to create a new influencer
  def new
    @user = User.new
    @user.role = 'influencer'
    @user.build_influencer
  end

  # Creates a new influencer
  def create
    @user = User.new(params[:user])
    @user.role = 'influencer'
    # Account approved
    @user.approved = true
    # Assign twitter credentials
    @user.twitter_linked = true
    @user.twitter_screen_name = session['twitter_screen_name']
    @user.twitter_uid = session['twitter_uid']
    @user.twitter_token = session['twitter_token']
    @user.twitter_secret = session['twitter_secret']

    if @user.save
      # Clear session values
      session['twitter_screen_name'] = session['twitter_uid'] = session['twitter_token'] = session['twitter_secret'] = nil
      # Login user
      sign_in(:user, @user)
      # Complete profiles
      redirect_to action: :step_2
    else
      render action: :new
    end
  end

  # Shows the second step for the registration
  def step_2
    @influencer = current_user.influencer
  end

  # Process the second step for the registration
  def process_step_2
    @influencer = current_user.influencer
    if @influencer.update_attributes(params[:influencer])
      redirect_to action: :step_3
    else
      render action: :step_2
    end
  end

  # Shows the third step for the registration
  def step_3
    @influencer = current_user.influencer
  end

  # Process the third step for the registration
  def process_step_3
    @influencer = current_user.influencer
    if @influencer.update_attributes(params[:influencer])
      redirect_to influencer_dashboard_path
    else
      render action: :step_3
    end
  end

  private

  # Check that the user is logged in with twitter
  def check_twitter_credentials
    if session['twitter_token'].blank? || session['twitter_secret'].blank?
      redirect_to influencer_registration_path, :error => "Debes linkear tu cuenta de twitter antes de continuar" and return
    end
  end

end
