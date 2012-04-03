class PaymentTypesController < ApplicationController
  load_and_authorize_resource
  
  # GET /payment_types
  # GET /payment_types.json
  def index
    @payment_types = PaymentType.all

    respond_to do |format|
      format.html # index.html.haml
      format.json { render json: @payment_types }
    end
  end

  # GET /payment_types/new
  # GET /payment_types/new.json
  def new
    @payment_type = PaymentType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payment_type }
    end
  end

  # GET /payment_types/1/edit
  def edit
    @payment_type = PaymentType.find(params[:id])
  end

  # POST /payment_types
  # POST /payment_types.json
  def create
    @payment_type = PaymentType.new(params[:payment_type])

    respond_to do |format|
      if @payment_type.save
        format.html { redirect_to payment_types_url, notice: 'El tipo de pago se creo satisfactoriamente.' }
        format.json { render json: @payment_type, status: :created, location: @payment_type }
      else
        format.html { render action: "new" }
        format.json { render json: @payment_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /payment_types/1
  # PUT /payment_types/1.json
  def update
    @payment_type = PaymentType.find(params[:id])

    respond_to do |format|
      if @payment_type.update_attributes(params[:payment_type])
        format.html { redirect_to payment_types_url, notice: 'El tipo de pago se modifico satisfactoriamente.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @payment_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_types/1
  # DELETE /payment_types/1.json
  def destroy
    @payment_type = PaymentType.find(params[:id])
    if @payment_type.status == "A"
      @payment_type.status = "I"
      @notice = 'El tipo de pago se desactivo satisfactoriamente.'
    else
      @payment_type.status = "A"
      @notice = 'El tipo de pago se activo satisfactoriamente.'      
    end

    @payment_type.save

    respond_to do |format|
      format.html { redirect_to payment_types_url, notice: @notice }
      format.json { head :ok }
    end
  end
end