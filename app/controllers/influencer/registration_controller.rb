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
    @user.password = @user.password_confirmation = (0...8).map{65.+(rand(25)).chr}.join
    @user.approved = true

    if @user.save
      sign_in(:user, @user)
      redirect_to action: :step_2
    else
      render action: :new
    end
  end

  # Shows the second step to complete the influencer profile
  def step_2

  end

  # Process the step 2 of the registration
  def process_step_2

  end

  # Shows the third and last to complete the influencer profile
  def step_3

  end

  # Process the step 3 of the registration
  def process_step_3

  end

  private

  # Check that the user is logged in with twitter
  def check_twitter_credentials
    if session['twitter_token'].blank? || session['twitter_secret'].blank?
      redirect_to influencer_registration_path, :error => "Debes linkear tu cuenta de twitter antes de continuar" and return
    end
  end

end
