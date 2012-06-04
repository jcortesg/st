# encoding: utf-8
class Advertiser::CampaignsController < ApplicationController
  before_filter :authenticate_user!, :require_advertiser
  before_filter :verify_can_create_campaign, only: [:new, :create]

  # Shows the campaigns
  def index
    @campaign_count = Campaign.active.where(advertiser_id: current_role.id).count
    if @campaign_count > 0
      @search = Campaign.active.where(advertiser_id: current_role.id).search(params[:search])
      @campaigns = @search.page(params[:page])
    else
      render action: 'no_active_campaigns'
    end
  end

  # Shows the archived campaigns
  def archived
    @search = Campaign.archived.where(advertiser_id: current_role).search(params[:search])
    @campaigns = @search.page(params[:page])
  end

  # Shows a campaign
  def show
    @campaign = current_role.campaigns.find(params[:id])
    if @campaign.tweets.count == 0
      render action: 'no_tweets'
    end
  end

  # Shows the form to create a new campaign
  def new
    @campaign = Campaign.new
  end

  # Creates a new campaign
  def create
    @campaign = Campaign.new(params[:campaign])
    @campaign.advertiser_id = current_role.id

    if @campaign.save
      flash[:notice] = "La campaña #{@campaign.name} fue creada con éxito"
      redirect_to [:audience, :advertiser, @campaign]
    else
      flash[:error] = "Hubo un error al intentar crear la campaña"
      render action: :new
    end

  end

  # Shows the form to update a campaign
  def edit
    @campaign = current_role.campaigns.find(params[:id])
  end

  # Updates a campaign
  def update
    @campaign = current_role.campaigns.find(params[:id])

    if @campaign.update_attributes(params[:campaign])
      flash[:notice] = "La campaña #{@campaign.name} fue actualizada"
      redirect_to [:advertiser, @campaign]
    else
      flash[:error] = "Hubo un error al intentar actualizar la campaña"
      render action: :edit
    end
  end

  # Shows the form to set the audience for the campaign
  def audience
    @campaign = current_role.campaigns.find(params[:id])
  end

  # Sets the audience for the campaign
  def set_audience
    @campaign = current_role.campaigns.find(params[:id])

    if @campaign.update_attributes(params[:campaign])
      flash[:notice] = "Has configurado la audiencia para tu campaña"
      redirect_to [:advertiser, @campaign]
    else
      flash[:error] = "Hubo un error al configurar la audiencia de la campaña"
      render action :audience
    end
  end

  # Archives a campaign
  def archive
    @campaign = current_role.campaigns.find(params[:id])

    if @campaign.update_attribute(:archived, true)
      flash[:notice] = "La campanaña #{@campaign.name} ha sido archivada"
      redirect_to [:advertiser, @campaign]
    else
      flash[:error] = "Hubo un error al archivar la campaña"
      redirect_to :back
    end
  end

  # Activates a campaign
  def activate
    @campaign = current_role.campaigns.find(params[:id])

    if @campaign.update_attribute(:archived, false)
      flash[:notice] = "La campaña #{@campaign.name} ha sido activada"
      redirect_to [:advertiser, @campaign]
    else
      flash[:error] = "Hubo un error al reactivar la campaña"
      redirect_to :back
    end
  end

  private

  # Verifies that the current user can create a campaign
  def verify_can_create_campaign
    unless current_user.advertiser.can_create_campaigns?
      flash[:error] = "No tiene permitido create campañas"
      redirect_to action: :index
    end
  end
end