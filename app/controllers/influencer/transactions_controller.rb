# encoding: utf-8
class Influencer::TransactionsController < ApplicationController
  before_filter :authenticate_user!, :check_twitter_linked, :require_influencer

  # Show the list of transactions
  def index
    @search = Transaction.where(user_id: current_user.id).search(params[:search])
    @transactions = @search.page(params[:page])
  end

  # Shows a transaction
  def show
    @transaction = Transaction.find(params[:id])
  end
end
