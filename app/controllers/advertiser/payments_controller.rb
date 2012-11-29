# encoding: utf-8
require 'mercadopago.rb'

class Advertiser::PaymentsController < ApplicationController
  before_filter :require_advertiser

  # Show the list of transactions
  def index
    search_params = params[:search] || {}
    search_params.reverse_merge!({"meta_sort" => "id.desc"})

    if params[:search].nil?
      search_params['updated_at_greater_than_or_equal_to'] = Date.today.beginning_of_month
      search_params['updated_at_less_than_or_equal_to'] = Date.today
    end

    @search = Payment.where(user_id: current_user.id).search(search_params)
    @payments = @search.page(params[:page])
  end

  # Shows a transaction
  def show
    @payment = Payment.find(params[:id])
  end

  def new
    @payment = Payment.new
  end

  def create
    @payment = Payment.new(params[:payment])
    @payment.user_id = current_user.id
    @payment.status = "created"

    advertiser = Advertiser.find_by_user_id(current_user.id)

    begin
      mp = MercadoPago.new(APP_CONFIG['mercadopago_client_id'], APP_CONFIG['mercadopago_client_secret'])
      accessToken = mp.get_access_token()
      preferenceData = Hash["items" => Array(Array["external_reference" => advertiser.company+ " "+ Time.now.to_s(:short), "payer_name" => advertiser.first_name, "payer_surname" => advertiser.last_name, "payer_email" => current_user.email, "title"=>@payment.description, "quantity"=>1, "unit_price"=>@payment.amount, "currency_id"=> APP_CONFIG['mercadopago_currency_id']])]

      preference = mp.create_preference(preferenceData)

      if preference['status'] == "201"
        @payment.gateway = "mercadopago"
        @payment.payment_url = preference['response']['init_point']

        if @payment.save
          flash[:notice] = "La orden de pago fue creada con éxito"
          render action: :pay
        else
          flash.now[:error] = "Hubo un error al intentar crear la orden de pago"
          render action: :new
        end
      else
        flash.now[:error] = "Hubo un error en el Gateway de pago al intentar crear la orden"
        render action: :new
      end

    rescue Exception => e
      puts "[ERROR] #{e.message}"
      flash.now[:error] = "Hubo un error en el Gateway de pago al intentar crear la orden"
      render action: :new
    end
  end

  def pay
    @payment = Payment.find(params[:id])
  end




end
