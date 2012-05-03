# encoding: utf-8
class Admin::InfluencersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin
  before_filter :find_influencer, only: [:new, :edit, :update, :destroy]

  # Show the list of influencers
  def index
    @search = Influencer.includes(:user).search(params[:search])
    @influencers = @search.page(params[:page])
  end

  # Shows a influencer
  def show
  end

  # Show the form to create a new influencer
  def new
    @influencer = Influencer.new
  end

  # Process the creation of a new influencer
  def create
    @influencer = Influencer.new(params[:influencer])

    if @influencer.save
      flash[:notice] = "La celebridad #{@influencer.full_name} fue creada con éxito"
      redirect_to :action => :index
    else
      flash[:error] = "Hubo un error al intentar crear la celebridad"
      render :action => :new
    end
  end


  # Shows the form to edit a influencer
  def edit
  end

  # Process the update of a influencer
  def update
    if @influencer.update_attributes(params[:influencer])
      flash[:notice] = "La celebridad #{@influencer.full_name} fue actualizada con éxito"
      redirect_to :action => :index
    else
      flash[:error] = "Hubo un error al intentar actualizar la celebridad"
      render :action => :edit
    end
  end

  # Deletes a influencer
  def destroy
    if @influencer.destroy
      flash[:notice] = "La celebridad #{@influencer.full_name} fue eliminada del sistema"
    else
      flash[:notice] = "Hubo un error al intentar eliminar la celebridad"
    end

    redirect_to :action => :index
  end


  private

  def find_influencer
    @influencer = Influencer.find(params[:id])
  end
end
