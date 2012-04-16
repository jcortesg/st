class AffiliatesController < ApplicationController
  before_filter :authenticate_user!, :except => [:new, :create]
  load_and_authorize_resource

  # GET /affiliates
  # GET /affiliates.json
  def index
    @affiliates = Affiliate.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @affiliates }
    end
  end

  # GET /affiliates/1
  # GET /affiliates/1.json
  def show
    @affiliate = Affiliate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @affiliate }
    end
  end

  # GET /affiliates/new
  # GET /affiliates/new.json
  def new
    if session[:signed_up_user_id] == nil
      redirect_to "/users/sign_up"
      return
    end
    
    @affiliate = Affiliate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @affiliate }
    end
  end

  # GET /affiliates/1/edit
  def edit
    @affiliate = Affiliate.find(params[:id])
  end

  # POST /affiliates
  # POST /affiliates.json
  def create
    params[:affiliate][:user_id] = session[:signed_up_user_id]
    
    @affiliate = Affiliate.new(params[:affiliate])

    respond_to do |format|
      if @affiliate.save
        format.html { redirect_to root_path, notice: 'El usuario se creo con exito. En cuanto este activado podras logearte al sistema' }
        format.json { render json: @affiliate, status: :created, location: @affiliate }
      else
        format.html { render action: "new" }
        format.json { render json: @affiliate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /affiliates/1
  # PUT /affiliates/1.json
  def update
    @affiliate = Affiliate.find(params[:id])

    respond_to do |format|
      if @affiliate.update_attributes(params[:affiliate])
        format.html { redirect_to root_path, notice: 'Los datos se actualizaron con exito' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @affiliate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /affiliates/1
  # DELETE /affiliates/1.json
  def destroy
    @affiliate = Affiliate.find(params[:id])
    @affiliate.destroy

    respond_to do |format|
      format.html { redirect_to affiliates_url }
      format.json { head :ok }
    end
  end
end
