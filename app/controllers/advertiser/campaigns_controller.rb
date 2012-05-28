# encoding: utf-8
class Advertiser::CampaignsController < ApplicationController
  before_filter :authenticate_user!, :require_advertiser

  # Shows the campaigns
  def index
    @campaign_count = Campaign.active.where(advertiser_id: current_user.advertiser.id).count
    if @campaign_count > 0
      @search = Campaign.active.where(advertiser_id: current_user.advertiser.id).search(params[:search])
      @campaigns = @search.page(params[:page])
    else
      render action: 'no_active_campaigns'
    end
  end

  # Shows the archived campaigns
  def archived
    @search = Campaign.archived.where(advertiser_id: current_user.advertiser).search(params[:search])
    @campaigns = @search.page(params[:page])
  end
end
