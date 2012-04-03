class AudiencesLocationsController < ApplicationController
  load_and_authorize_resource
  
  # GET /audiences_locations
  # GET /audiences_locations.json
  def index
    @audiences_locations = AudiencesLocation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @audiences_locations }
    end
  end

  # GET /audiences_locations/1
  # GET /audiences_locations/1.json
  def show
    @audiences_location = AudiencesLocation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @audiences_location }
    end
  end

  # GET /audiences_locations/new
  # GET /audiences_locations/new.json
  def new
    @audiences_location = AudiencesLocation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @audiences_location }
    end
  end

  # GET /audiences_locations/1/edit
  def edit
    @audiences_location = AudiencesLocation.find(params[:id])
  end

  # POST /audiences_locations
  # POST /audiences_locations.json
  def create
    @audiences_location = AudiencesLocation.new(params[:audiences_location])

    respond_to do |format|
      if @audiences_location.save
        format.html { redirect_to @audiences_location, notice: 'Audiences location was successfully created.' }
        format.json { render json: @audiences_location, status: :created, location: @audiences_location }
      else
        format.html { render action: "new" }
        format.json { render json: @audiences_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /audiences_locations/1
  # PUT /audiences_locations/1.json
  def update
    @audiences_location = AudiencesLocation.find(params[:id])

    respond_to do |format|
      if @audiences_location.update_attributes(params[:audiences_location])
        format.html { redirect_to @audiences_location, notice: 'Audiences location was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @audiences_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /audiences_locations/1
  # DELETE /audiences_locations/1.json
  def destroy
    @audiences_location = AudiencesLocation.find(params[:id])
    @audiences_location.destroy

    respond_to do |format|
      format.html { redirect_to audiences_locations_url }
      format.json { head :ok }
    end
  end
end
