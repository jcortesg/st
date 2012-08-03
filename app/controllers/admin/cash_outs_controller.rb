# encoding: utf-8
class Admin::CashOutsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin

  # Show the list of cash outs
  def index
    search_params = params[:search] || {}
    search_params.reverse_merge!({"meta_sort" => "created_at.asc"})

    if params[:search].nil?
      search_params['status_equals'] = 'created'
    end

    @search = CashOut.search(search_params)
    @cash_outs = @search.page(params[:page])
  end

  # Shows a cash out
  def show
    @cash_out = CashOut.find(params[:id])
  end

  # Destroys a cash out
  def destroy
    @cash_out = CashOut.find(params[:id])
    @cash_out.destroy

    flash[:notice] = "El Cash Out ha sido eliminado"

    redirect_to [:admin, :cash_outs]
  end
end
