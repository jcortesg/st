# encoding: utf-8
class  Advertiser::PicturesController < ApplicationController

  # GET /pictures/1
  # GET /pictures/1.json
  def show
    @picture = Picture.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @picture }
    end
  end

  # POST /pictures
  # POST /pictures.json
  def create
    # Generate the picture code
    o =  [('A'..'Z'),('a'..'z'),(0..9)].map{|i| i.to_a}.flatten
    begin
      code = (0..3).map{ o[rand(o.length)] }.join
    end while Tweet.where(link_code: code).exists?
    params[:picture][:picture_code] = code.to_s
    @picture = Picture.new(params[:picture])

    respond_to do |format|
      if @picture.save
        format.html { redirect_to '/advertiser/pictures/'+@picture.id, notice: 'Picture was successfully created.' }
        format.json { render json: @picture, status: :created, location: '/advertiser/pictures' }
      else
        format.html { render action: "new" }
        format.json { render json: nil, status: :unprocessable_entity }
      end
    end
  end

end
