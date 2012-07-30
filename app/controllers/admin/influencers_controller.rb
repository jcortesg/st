# encoding: utf-8
class Admin::InfluencersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin

  # Show the list of influencers
  def index
    search_params = params[:search] || {}
    search_params.reverse_merge!({"meta_sort" => "audience_followers.desc"})
    @search = Influencer.includes(:user).search(search_params)
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
    if @user.update_attributes(params[:user])
      flash[:notice] = "La celebridad #{@influencer.full_name} fue actualizada con éxito"
      redirect_to [:admin, @influencer]
    else
      flash.now[:error] = "Hubo un error al intentar actualizar la celebridad"
      render action: :edit
    end
  end

  # Deletes a influencer
  def destroy
    @influencer = Influencer.find(params[:id])
    @user = @influencer.user
    if @user.destroy
      flash[:notice] = "La celebridad #{@influencer.full_name} fue eliminada del sistema"
    else
      flash[:notice] = "Hubo un error al intentar eliminar la celebridad"
    end

    redirect_to action: :index
  end

  # Shows the form to recategorize a celebrity
  def recategorize
    @influencer = Influencer.find(params[:id])
    @user = @influencer.user
  end

  # Recategorizes a celebrity
  def do_recategorize
    @influencer = Influencer.find(params[:id])
    @user = @influencer.user

    if params[:user][:role] == 'influencer'
      flash.now[:error] = "El usuario ya es una celebridad"
      render action: :recategorize
    elsif params[:user][:role] == 'advertiser'
      User.transaction do
        advertiser = Advertiser.new
        advertiser.user = @user
        advertiser.company = "#{@influencer.first_name} - #{@influencer.last_name}"
        advertiser.first_name = @influencer.first_name
        advertiser.last_name = @influencer.last_name
        advertiser.address = @influencer.address
        advertiser.city = @influencer.city
        advertiser.state = @influencer.state
        advertiser.country = @influencer.country
        advertiser.zip_code = @influencer.zip_code
        advertiser.phone = @influencer.phone
        advertiser.phone = rand(10) if advertiser.phone.blank?
        advertiser.user = @user
        advertiser.save!
        @user.role = 'advertiser'
        @user.save!
        @influencer.photo.destroy
        @influencer.destroy

        flash[:success] = "El usuario ha sido recategorizado"
        redirect_to [:admin, advertiser]
      end
    elsif params[:user][:role] == 'affiliate'
      User.transaction do
        affiliate = Affiliate.new
        affiliate.user = @user
        affiliate.company = "#{@influencer.first_name} - #{@influencer.last_name}"
        affiliate.first_name = @influencer.first_name
        affiliate.last_name = @influencer.last_name
        affiliate.address = @influencer.address
        affiliate.city = @influencer.city
        affiliate.state = @influencer.state
        affiliate.country = @influencer.country
        affiliate.zip_code = @influencer.zip_code
        affiliate.phone = @influencer.phone
        affiliate.phone = rand(10) if affiliate.phone.blank?
        affiliate.user = @user
        affiliate.save!
        @user.role = 'affiliate'
        @user.save!
        @influencer.photo.destroy
        @influencer.destroy

        Notifier.influencer_converted_to_affiliate(@user).deliver

        flash[:success] = "El usuario ha sido recategorizado"
        redirect_to [:admin, affiliate]
      end
    else
      flash.now[:error] = "Rol no reconocido"
      render action: :recategorize
    end
  end

  # Shows the form to edit an influencer
  def set_influence
    @influencer = Influencer.find(params[:id])
  end

  def do_set_influence
    @influencer = Influencer.find(params[:id])

    if @influencer.update_attributes(params[:influencer])
      flash[:notice] = "La celebridad #{@influencer.full_name} fue actualizada con éxito"
      redirect_to [:admin, @influencer]
    else
      flash.now[:error] = "Hubo un error al intentar actualizar la celebridad"
      render action: :edit
    end
  end
end
