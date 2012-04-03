class CampaignsController < ApplicationController
  load_and_authorize_resource
  
  # GET /campaigns
  # GET /campaigns.json
  def index
    @campaigns = Campaign.find_all_by_advertiser_id(current_entity_id)
        
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @campaigns }
    end
  end

  # GET /campaigns/new
  # GET /campaigns/new.json
  def new
    @campaign = Campaign.new

    respond_to do |format|
      format.html # new.html.haml
      format.json { render json: @campaign }
    end
  end

  # GET /campaigns/1/edit
  def edit
    @campaign = Campaign.find(params[:id])
  end

  # POST /campaigns
  # POST /campaigns.json
  def create
    @campaign = Campaign.new(params[:campaign])
    @campaign.advertiser_id = current_entity_id

    respond_to do |format|
      if @campaign.save
        format.html { redirect_to campaigns_url, notice: 'La campania se creo satisfactoriamente.' }
        format.json { render json: @campaign, status: :created, location: @campaign }
      else
        format.html { render action: "new" }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /campaigns/1
  # PUT /campaigns/1.json
  def update
    @campaign = Campaign.find(params[:id])

    respond_to do |format|
      if @campaign.update_attributes(params[:campaign])
        format.html { redirect_to campaigns_url, notice: 'La campania se actualizo satisfactoriamente.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /campaigns/1
  # DELETE /campaigns/1.json
  def destroy
    @campaign = Campaign.find(params[:id])
    @campaign.status = "F"
    @notice = 'La campania se finalizo satisfactoriamente.'
    
    @campaign.save

    respond_to do |format|
      format.html { redirect_to campaigns_url }
      format.json { head :ok }
    end
  end
end