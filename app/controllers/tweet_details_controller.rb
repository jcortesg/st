class TweetDetailsController < ApplicationController
  load_and_authorize_resource
  
  # GET /tweet_details
  # GET /tweet_details.json
  def index
    @tweet_details = TweetDetail.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tweet_details }
    end
  end

  # GET /tweet_details/1
  # GET /tweet_details/1.json
  def show
    @tweet_detail = TweetDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tweet_detail }
    end
  end

  # GET /tweet_details/new
  # GET /tweet_details/new.json
  def new
    @tweet_detail = TweetDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tweet_detail }
    end
  end

  # GET /tweet_details/1/edit
  def edit
    @tweet_detail = TweetDetail.find(params[:id])
  end

  # POST /tweet_details
  # POST /tweet_details.json
  def create
    @tweet_detail = TweetDetail.new(params[:tweet_detail])

    respond_to do |format|
      if @tweet_detail.save
        format.html { redirect_to @tweet_detail, notice: 'Tweet detail was successfully created.' }
        format.json { render json: @tweet_detail, status: :created, location: @tweet_detail }
      else
        format.html { render action: "new" }
        format.json { render json: @tweet_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tweet_details/1
  # PUT /tweet_details/1.json
  def update
    @tweet_detail = TweetDetail.find(params[:id])

    respond_to do |format|
      if @tweet_detail.update_attributes(params[:tweet_detail])
        format.html { redirect_to @tweet_detail, notice: 'Tweet detail was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @tweet_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tweet_details/1
  # DELETE /tweet_details/1.json
  def destroy
    @tweet_detail = TweetDetail.find(params[:id])
    @tweet_detail.destroy

    respond_to do |format|
      format.html { redirect_to tweet_details_url }
      format.json { head :ok }
    end
  end
end
