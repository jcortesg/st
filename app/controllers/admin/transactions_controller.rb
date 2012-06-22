# encoding: utf-8
class Admin::TransactionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin

  # Show the list of keywords
  def index
    @search = Transaction.search(params[:search])
    @transactions = @search.page(params[:page])
  end

  # Shows a transaction
  def show
    @transaction = Transaction.find(params[:id])
  end

  # Shows the form to create a new transaction
  def new
    @transaction = Transaction.new
  end

  # Creates a transaction
  def create
    @transaction = Transaction.new(params[:transaction])

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
