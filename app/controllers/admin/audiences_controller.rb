# encoding: utf-8
class Admin::AudiencesController < ApplicationController
  before_filter :find_influencer_and_audience

  # Shows the audience for a celebrity
  def show
  end

  # Shows the form to edit a influencer's audience
  def edit
  end

  # Updates a influencer's audience
  def update
    if @audience.update_attributes(params[:audience])
      flash[:notice] = "La audiencia para la celebridad #{@influencer.full_name} fue actualizada con éxito"
      redirect_to [:admin, @influencer, :audience]
    else
      flash[:error] = "Hubo un error al intentar actualizar la audiencia"
      render action: :edit
    end
  end

  private

  def find_influencer_and_audience
    @influencer = Influencer.where(:id => params[:influencer_id]).first
    @audience = @influencer.audience
  end

end
