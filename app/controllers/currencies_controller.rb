class CurrenciesController < ApplicationController
  load_and_authorize_resource
  
  # GET /currencies
  # GET /currencies.json
  def index
    @currencies = Currency.all

    respond_to do |format|
      format.html # index.html.haml
      format.json { render json: @currencies }
    end
  end

  # GET /currencies/new
  # GET /currencies/new.json
  def new
    @currency = Currency.new

    respond_to do |format|
      format.html # new.html.haml
      format.json { render json: @currency }
    end
  end

  # GET /currencies/1/edit
  def edit
    @currency = Currency.find(params[:id])
  end

  # POST /currencies
  # POST /currencies.json
  def create
    @currency = Currency.new(params[:currency])

    respond_to do |format|
      if @currency.save
        format.html { redirect_to currencies_url, notice: 'La moneda se creo satisfactoriamente.' }
        format.json { render json: @currency, status: :created, location: @currency }
      else
        format.html { render action: "new" }
        format.json { render json: @currency.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /currencies/1
  # PUT /currencies/1.json
  def update
    @currency = Currency.find(params[:id])

    respond_to do |format|
      if @currency.update_attributes(params[:currency])
        format.html { redirect_to currencies_url, notice: 'La moneda se actualizo satisfactoriamente.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @currency.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /currencies/1
  # DELETE /currencies/1.json
  def destroy
    @currency = Currency.find(params[:id])
    if @currency.status == "A"
      @currency.status = "I"
      @notice = 'La moneda se desactivo satisfactoriamente.'
    else
      @currency.status = "A"
      @notice = 'La moneda se activo satisfactoriamente.'      
    end
    
    @currency.save

    respond_to do |format|
      format.html { redirect_to currencies_url, notice: @notice }
      format.json { head :ok }
    end
  end
end