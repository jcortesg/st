class PaymentMethodsController < ApplicationController
  load_and_authorize_resource
  
  # GET /payment_methods
  # GET /payment_methods.json
  def index
    @payment_methods = PaymentMethod.all

    respond_to do |format|
      format.html # index.html.haml
      format.json { render json: @payment_methods }
    end
  end

  # GET /payment_methods/new
  # GET /payment_methods/new.json
  def new
    @payment_method = PaymentMethod.new

    respond_to do |format|
      format.html # new.html.haml
      format.json { render json: @payment_method }
    end
  end

  # GET /payment_methods/1/edit
  def edit
    @payment_method = PaymentMethod.find(params[:id])
  end

  # POST /payment_methods
  # POST /payment_methods.json
  def create
    @payment_method = PaymentMethod.new(params[:payment_method])

    respond_to do |format|
      if @payment_method.save
        format.html { redirect_to payment_methods_url, notice: 'El medio de pago se creo satisfactoriamente.' }
        format.json { render json: @payment_method, status: :created, location: @payment_method }
      else
        format.html { render action: "new" }
        format.json { render json: @payment_method.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /payment_methods/1
  # PUT /payment_methods/1.json
  def update
    @payment_method = PaymentMethod.find(params[:id])

    respond_to do |format|
      if @payment_method.update_attributes(params[:payment_method])
        format.html { redirect_to payment_method_url, notice: 'El medio de pago se actualizo satisfactoriamente.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @payment_method.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_methods/1
  # DELETE /payment_methods/1.json
  def destroy
    @payment_method = PaymentMethod.find(params[:id])
    if @payment_method.status == "A"
      @payment_method.status = "I"
      @notice = 'El medio de pago se desactivo satisfactoriamente.'
    else
      @payment_method.status = "A"
      @notice = 'El medio de pago se activo satisfactoriamente.'      
    end

    @payment_method.save

    respond_to do |format|
      format.html { redirect_to payment_methods_url, notice: @notice }
      format.json { head :ok }
    end
  end
end