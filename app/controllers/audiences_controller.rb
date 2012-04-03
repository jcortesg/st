class AudiencesController < ApplicationController
  load_and_authorize_resource

  # GET /audiences/influencer/1
  # GET /audiences/influencer/1.json  
  def influencer
    @audience = Audience.current_audience_for_influencer_id(params[:influencer_id])

    respond_to do |format|
      format.html # influencer.html.haml
      format.json { render json: @audience }
    end  
  end
  
  # GET /audiences
  # GET /audiences.json
  def index
    @audiences = Audience.current_audiences
    
    respond_to do |format|
      format.html # index.html.haml
      format.json { render json: @audiences }
    end
  end

  # GET /audiences/1
  # GET /audiences/1.json
  def show
    @audience = Audience.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      format.json { render json: @audience }
    end
  end

  # GET /audiences/new
  # GET /audiences/new.json
  def new
    @audience = Audience.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @audience }
    end
  end

  # GET /audiences/1/edit
  def edit
    @audience = Audience.find(params[:id])
  end

  # POST /audiences
  # POST /audiences.json
  def create
    @audience = Audience.new(params[:audience])

    respond_to do |format|
      if @audience.save
        format.html { redirect_to @audience, notice: 'Audience was successfully created.' }
        format.json { render json: @audience, status: :created, location: @audience }
      else
        format.html { render action: "new" }
        format.json { render json: @audience.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /audiences/1
  # PUT /audiences/1.json
  def update
    @audience = Audience.find(params[:id])

    respond_to do |format|
      if @audience.update_attributes(params[:audience])
        format.html { redirect_to @audience, notice: 'Audience was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @audience.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /audiences/1
  # DELETE /audiences/1.json
  def destroy
    @audience = Audience.find(params[:id])
    @audience.destroy

    respond_to do |format|
      format.html { redirect_to audiences_url }
      format.json { head :ok }
    end
  end
end
