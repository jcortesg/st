class AdvertisersController < ApplicationController
  before_filter :authenticate_user!, :except => [:new, :create]
  load_and_authorize_resource

  # GET /advertisers
  # GET /advertisers.json
  def index
    @advertisers = Advertiser.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @advertisers }
    end
  end

  # GET /advertisers/1
  # GET /advertisers/1.json
  def show
    @advertiser = Advertiser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @advertiser }
    end
  end

  # GET /advertisers/new
  # GET /advertisers/new.json
  def new
    if session[:signed_up_user_id] == nil
      redirect_to "/users/sign_up"
      return
    end
    
    @advertiser = Advertiser.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @advertiser }
    end
  end

  # GET /advertisers/1/edit
  def edit
    @advertiser = Advertiser.find(params[:id])
  end

  # PUT /advertisers/1
  # PUT /advertisers/1.json
  def update
    @advertiser = Advertiser.find(params[:id])

    respond_to do |format|
      if @advertiser.update_attributes(params[:advertiser])
        format.html { redirect_to root_path, notice: 'Los datos se actualizaron con exito' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @advertiser.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /advertisers/1
  # DELETE /advertisers/1.json
  def destroy
    @advertiser = Advertiser.find(params[:id])
    @advertiser.destroy

    respond_to do |format|
      format.html { redirect_to advertisers_url }
      format.json { head :ok }
    end
  end
end
