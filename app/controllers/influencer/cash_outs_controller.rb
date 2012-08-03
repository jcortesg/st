# encoding: utf-8
class Influencer::CashOutsController < ApplicationController
  before_filter :authenticate_user!, :check_twitter_linked, :require_influencer

  # Show the list of cash outs
  def index
    search_params = params[:search] || {}
    search_params.reverse_merge!({"meta_sort" => "id.desc"})

    @search = CashOut.where(user_id: current_user.id).search(search_params)
    @cash_outs = @search.page(params[:page])
  end

  # Shows a cash out
  def show
    @cash_out = CashOut.find(params[:id])
  end
end
