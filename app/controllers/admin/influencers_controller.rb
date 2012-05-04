# encoding: utf-8
class Admin::InfluencersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin

  # Show the list of influencers
  def index
    @search = Influencer.includes(:user).search(params[:search])
    @influencers = @search.page(params[:page])
  end

  # Shows a influencer
  def show
    @influencer = Influencer.find(params[:id])
  end

  # Show the form to create a new influencer
  def new
    @user = User.new
    @user.build_influencer
  end

  # Process the creation of a new influencer
  def create
    twitter_screen_name = params[:user][:twitter_screen_name]
    params[:user].delete(:twitter_screen_name)
    @user = User.new(params[:user])
    @user.twitter_screen_name = twitter_screen_name
    @user.role = 'influencer'
    # Account approved
    @user.approved = true

    if @user.valid? && @user.check_twitter_screen_name && @user.save
      @influencer = @user.influencer
      flash[:notice] = "La celebridad #{@influencer.full_name} fue creada con éxito"
      redirect_to [:admin, @influencer]
    else
      @user.check_twitter_screen_name
      flash[:error] = "Hubo un error al intentar crear la celebridad"
      render action: :new
    end
  end


  # Shows the form to edit a influencer
  def edit
    @influencer = Influencer.find(params[:id])
    @user = @influencer.user
  end

  # Process the update of a influencer
  def update
    @influencer = Influencer.find(params[:id])
    @user = @influencer.user
    if @user.update_attributes(params[:influencer])
      flash[:notice] = "La celebridad #{@influencer.full_name} fue actualizada con éxito"
      redirect_to action: :index
    else
      flash[:error] = "Hubo un error al intentar actualizar la celebridad"
      render action: :edit
    end
  end

  # Deletes a influencer
  def destroy
    @influencer = Influencer.find(params[:id])
    if @influencer.destroy
      flash[:notice] = "La celebridad #{@influencer.full_name} fue eliminada del sistema"
    else
      flash[:notice] = "Hubo un error al intentar eliminar la celebridad"
    end

    redirect_to action: :index
  end

end
