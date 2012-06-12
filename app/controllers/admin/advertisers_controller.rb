# encoding: utf-8
class Admin::AdvertisersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin

  # Show the list of advertisers
  def index
    @search = Advertiser.includes(:user).search(params[:search])
    @advertisers = @search.page(params[:page])
  end

  # Shows a advertiser
  def show
    @advertiser = Advertiser.find(params[:id])
  end

  # Show the form to create a new advertiser
  def new
    @user = User.new
    @user.build_advertiser
  end

  # Process the creation of a new advertiser
  def create
    @user = User.new(params[:user])
    @user.role = 'advertiser'
    # Account approved
    @user.approved = true

    if @user.save
      @advertiser = @user.advertiser
      flash[:notice] = "El anunciante #{@advertiser.full_name} fue creado con éxito"
      redirect_to [:admin, @advertiser]
    else
      flash[:error] = "Hubo un error al intentar crear el anunciante"
      render action: :new
    end
  end


  # Shows the form to edit a advertiser
  def edit
    @advertiser = Advertiser.find(params[:id])
    @user = @advertiser.user
  end

  # Process the update of a advertiser
  def update
    @advertiser = Advertiser.find(params[:id])
    @user = @advertiser.user
    if @user.update_attributes(params[:user])
      flash[:notice] = "El anunciante #{@advertiser.full_name} fue actualizado con éxito"
      redirect_to [:admin, @advertiser]
    else
      flash.now[:error] = "Hubo un error al intentar actualizar el anuncianate"
      render action: :edit
    end
  end

  # Deletes a advertiser
  def destroy
    @advertiser = Advertiser.find(params[:id])
    @user = @advertiser.user
    if @user.destroy
      flash[:notice] = "El anunciante #{@advertiser.full_name} fue eliminado del sistema"
    else
      flash[:notice] = "Hubo un error al intentar eliminar el anunciante"
    end

    redirect_to action: :index
  end
end
