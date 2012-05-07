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

  end

  private

  def find_influencer_and_audience
    @influencer = Influencer.where(:id => params[:influencer_id]).first
    @audience = @influencer.audience
  end

end
