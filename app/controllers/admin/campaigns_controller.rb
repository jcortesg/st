# encoding: utf-8
class Admin::CampaignsController < ApplicationController
  before_filter :authenticate_user!, :require_admin

  # Shows the campaigns
  def index
    @search = Campaign.created_and_active.search(params[:search])
    @campaigns = @search.page(params[:page])
  end

  # Shows the archived campaigns
  def archived
    @search = Campaign.archived.search(params[:search])
    @campaigns = @search.page(params[:page])
  end

  # Shows a campaign
  def show
    @campaign = Campaign.find(params[:id])
  end

  # Shows the form to update a campaign
  def edit
    @campaign = Campaign.find(params[:id])
  end

  # Updates a campaign
  def update
    @campaign = Campaign.find(params[:id])

    if @campaign.update_attributes(params[:campaign])
      flash[:notice] = "La campaña #{@campaign.name} fue actualizada"
      redirect_to [:admin, @campaign]
    else
      flash.now[:error] = "Hubo un error al intentar actualizar la campaña"
      render action: :edit
    end
  end

  # Destroys a campaign
  def destroy
    @campaign = Campaign.find(params[:id])
    @campaign.destroy
    flash[:notice] = "La campaña #{@campaign.name} ha sido eliminada"
    redirect_to action: :archived
  end

  # Shows the form to set the audience for the campaign
  def audience
    @campaign = Campaign.find(params[:id])
  end

  # Sets the audience for the campaign
  def set_audience
    @campaign = Campaign.find(params[:id])

    if @campaign.update_attributes(params[:campaign])
      flash[:notice] = "Has configurado la audiencia para la campaña"
      redirect_to [:admin, @campaign]
    else
      flash.now[:error] = "Hubo un error al configurar la audiencia de la campaña"
      render action: :audience
    end
  end

  # Archives a campaign
  def archive
    @campaign = Campaign.find(params[:id])

    if @campaign.update_attribute(:archived, true)
      flash[:notice] = "La campanaña #{@campaign.name} ha sido archivada"
      redirect_to [:admin, @campaign]
    else
      flash.now[:error] = "Hubo un error al archivar la campaña"
      redirect_to :back
    end
  end

  # Activates a campaign
  def activate
    @campaign = Campaign.find(params[:id])

    if @campaign.update_attribute(:archived, false)
      flash[:notice] = "La campaña #{@campaign.name} ha sido activada"
      redirect_to [:admin, @campaign]
    else
      flash[:error] = "Hubo un error al reactivar la campaña"
      redirect_to :back
    end
  end
end
