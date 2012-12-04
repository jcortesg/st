# encoding: utf-8
require 'mercadopago.rb'
require "net/http"
require "uri"

class Admin::PaymentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin

  # Show the list of transactions
  def index
    search_params = params[:search] || {}
    search_params.reverse_merge!({"meta_sort" => "id.desc"})

    if params[:search].nil?
      search_params['updated_at_greater_than_or_equal_to'] = Date.today.beginning_of_month
      search_params['updated_at_less_than_or_equal_to'] = Date.today  + 1.day
    end

    @search = Payment.search(search_params)
    @payments = @search.page(params[:page])
  end

  # Shows a transaction
  def show
    @payment = Payment.find(params[:id])
  end
end
