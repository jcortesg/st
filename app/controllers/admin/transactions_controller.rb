# encoding: utf-8
class Admin::TransactionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin

  # Show the list of transactions
  def index
    search_params = params[:search] || {}
    search_params.reverse_merge!({"meta_sort" => "transaction_at.desc"})

    if params[:search].nil?
      search_params['transaction_at_greater_than_or_equal_to'] = Date.today.beginning_of_month
      search_params['transaction_at_less_than_or_equal_to'] = Date.today
    end

    @search = Transaction.search(search_params)
    @transactions = @search.page(params[:page])
  end

  # Shows a transaction
  def show
    @transaction = Transaction.find(params[:id])
  end

  # Shows the form to create a new payment
  def new_payment
    @transaction = Transaction.new
  end

  # Creates a new payment
  def create_new_payment
    @transaction = Transaction.new(params[:transaction])

    @transaction.amount = @transaction.amount * -1 if @transaction.amount >= 0
    @transaction.transaction_at = Time.now

    if @transaction.save
      flash[:notice] = "La transacción ha sido creada"
      redirect_to [:admin, @transaction]
    else
      flash.now[:error] = "Hubo un error al intentar crear el pago"
      render action: :new_payment
    end
  end

  # Shows the form to create a new transaction
  def new
    @transaction = Transaction.new
  end

  # Creates a transaction
  def create
    @transaction = Transaction.new(params[:transaction])
    @transaction.transaction_at = Time.now

    if @transaction.save
      flash[:notice] = "La transacción ha sido creada"
      redirect_to [:admin, @transaction]
    else
      flash.now[:error] = "Hubo un error al intentar crear la transacción"
      render action: :new
    end
  end

  # Shows the form to update a transaction
  def edit
    @transaction = Transaction.find(params[:id])
  end

  # Updates a transaction
  def update
    @transaction = Transaction.find(params[:id])

    if @transaction.update_attributes(params[:transaction])
      flash[:notice] = "La Transacción ha sido modificada"
      redirect_to [:admin, @transaction]
    else
      flash.now[:error] = "Hubo un error al intentar actualizar la transacción"
      render action: :edit
    end
  end

  # Destroys a transaction
  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy

    flash[:notice] = "La transacción ha sido eliminada"

    redirect_to [:admin, :transactions]
  end
end
