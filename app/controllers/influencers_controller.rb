class InfluencersController < ApplicationController
  before_filter :authenticate_user!, :except => [:new, :create]

  load_and_authorize_resource

  # POST /influencers/filter
  # POST /influencers/filter.json
  def filter
  end
  
  # GET /influencers/fees
  # GET /influencers/fees.json  
  def fees
    @influencers = Influencer.all
  end

  # POST /influencers/1/save_fees
  # POST /influencers/1/save_fees.json  
  def save_fees
    logger.info params.inspect
    @influencer = Influencer.find_by_id(params[:influencer_id])
    @influencer.borwin_fee = params[:influencer][:borwin_fee]
    @influencer.save
    
    redirect_to "/influencers/fees"
  end

  # GET /influencers/list
  # GET /influencers/list.json
  def list    
    @influencers = Influencer.influencers_list_with_current_profile_and_audience(params)
    
    respond_to do |format|
      format.html # list.html.haml
      format.json { render json: @influencers }
      format.js
    end
  end

  # GET /influencers
  # GET /influencers.json
  def index
    @influencers = Influencer.all.join(:audiences)

    respond_to do |format|
      format.html # index.html.haml
      format.json { render json: @influencers }
    end
  end

  # GET /influencers/1
  # GET /influencers/1.json
  def show
    @influencer = Influencer.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      format.json { render json: @influencer }
    end
  end

  # GET /influencers/new
  # GET /influencers/new.json
  def new
    if session[:signed_up_user_id] == nil
      redirect_to "/users/sign_up"
      return
    end

    @influencer = Influencer.new

    respond_to do |format|
      format.html # new.html.haml
      format.json { render json: @influencer }
    end
  end

  # GET /influencers/1/edit
  def edit
    @influencer = Influencer.find(params[:id])
  end

  # POST /influencers
  # POST /influencers.json
  def create
    @influencer = Influencer.new(params[:influencer])
    @influencer.user_id = session[:signed_up_user_id]

    respond_to do |format|
      if @influencer.save
        format.html { redirect_to "/twitter_credentials/login", notice: 'Influencer was successfully created.' }
        format.json { render json: @influencer, status: :created, location: @influencer }
      else
        format.html { render action: "new" }
        format.json { render json: @influencer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /influencers/1
  # PUT /influencers/1.json
  def update
    @influencer = Influencer.find(params[:id])

    respond_to do |format|
      if @influencer.update_attributes(params[:influencer])
        format.html { redirect_to home_path, notice: 'Los datos se actualizaron con exito' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @influencer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /influencers/1
  # DELETE /influencers/1.json
  def destroy
    @influencer = Influencer.find(params[:id])
    @influencer.destroy

    respond_to do |format|
      format.html { redirect_to influencers_url }
      format.json { head :ok }
    end
  end
end