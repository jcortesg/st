# encoding: utf-8
class Affiliate::CashOutsController < ApplicationController
  before_filter :authenticate_user!, :require_affiliate

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

  # Shows the form to create a new cash out
  def new
    @cash_out = CashOut.new
    @cash_out.user = current_user
    @cash_out.amount = current_user.available_for_withdraw

    @transactions = Transaction.where(user_id: current_user.id).where("transaction_type in ('tweet_revenue', 'advertiser_referrer_fee', 'influencer_referrer_fee')").order('id desc').all
  end

  # Creates a cash out
  def create
    @cash_out = CashOut.new
    @cash_out.user = current_user
    @cash_out.amount = current_user.available_for_withdraw

    if @cash_out.save
      Transaction.where(user_id: current_user.id).where("transaction_type in ('tweet_revenue', 'advertiser_referrer_fee', 'influencer_referrer_fee')").order('id desc').update_all("cash_out_id = #{@cash_out.id}")

      Notifier.cash_out_notice_to_admin(@cash_out).deliver

      flash[:notice] = "Se ha solicitado el Cash Out, los Administradores del sitio revisaran su solicitud para proceder al pago"
      redirect_to [:affiliate, @cash_out]
    else
      flash[:error] = "No se pudo solicitar el Cash Out"
      redirect_to [:new, :affiliate, :cash_out]
    end
  end
end
