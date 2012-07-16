# encoding: utf-8
class Advertiser::TransactionsController < ApplicationController
  before_filter :require_advertiser

  # Show the list of transactions
  def index
    search_params = params[:search] || {}
    search_params.reverse_merge!({"meta_sort" => "transaction_on.desc"})

    @search = Transaction.where(user_id: current_user.id).search(search_params)
    @transactions = @search.page(params[:page])
  end

  # Shows a transaction
  def show
    @transaction = Transaction.find(params[:id])
  end

end
