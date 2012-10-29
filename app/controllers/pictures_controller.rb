# encoding: utf-8
class PicturesController < ApplicationController
  layout :picture_layout

  #  GET /pictures/1
  # GET /pictures/1.json
  def show
    @picture = Picture.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @picture }
    end
  end

  private

  def picture_layout
    @picture = Picture.find(params[:id])
    if @picture.blank_layout?
      "blank"
    else
      "application"
    end
  end
end
