# encoding: utf-8
class Admin::AffiliatesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin

  # Show the list of affiliates
  def index
    @search = Affiliate.includes(:user).search(params[:search])
    @affiliates = @search.page(params[:page])
  end

  # Shows a affiliate
  def show
    @affiliate = Affiliate.find(params[:id])
  end

  # Show the form to create a new affiliate
  def new
    @user = User.new
    @user.build_affiliate
  end

  # Process the creation of a new affiliate
  def create
    @user = User.new(params[:user])
    @user.role = 'affiliate'
    # Account approved
    @user.approved = true

    if @user.save
      @affiliate = @user.affiliate
      flash[:notice] = "El anunciante #{@affiliate.full_name} fue creado con éxito"
      redirect_to [:admin, @affiliate]
    else
      flash[:error] = "Hubo un error al intentar crear el anunciante"
      render action: :new
    end
  end


  # Shows the form to edit a affiliate
  def edit
    @affiliate = Affiliate.find(params[:id])
    @user = @affiliate.user
  end

  # Process the update of a affiliate
  def update
    @affiliate = Affiliate.find(params[:id])
    @user = @affiliate.user
    if @user.update_attributes(params[:affiliate])
      flash[:notice] = "El anunciante #{@affiliate.full_name} fue actualizado con éxito"
      redirect_to [:admin, @affiliate]
    else
      flash.now[:error] = "Hubo un error al intentar actualizar el anuncianate"
      render action: :edit
    end
  end

  # Deletes a affiliate
  def destroy
    @affiliate = Affiliate.find(params[:id])
    @user = @affiliate.user
    if @user.destroy
      flash[:notice] = "El anunciante #{@affiliate.full_name} fue eliminado del sistema"
    else
      flash[:notice] = "Hubo un error al intentar eliminar el anunciante"
    end

    redirect_to action: :index
  end
end
