class TweetsController < ApplicationController
  load_and_authorize_resource
  
  # GET /tweets/1/campaign
  # GET /tweets/1/campaign.json  
  def campaign
    @tweets = Tweet.find_all_by_campaign_id(params[:id])
    @campaign_name = Campaign.find(params[:id]).name

    respond_to do |format|
      format.html # campaign.html.haml
      format.json { render json: @tweets }
    end  
  end
  
  # GET /tweets
  # GET /tweets.json
  def index
    @tweets = Tweet.tweets_for_user_with_filters(current_user, params)
    
    respond_to do |format|
      format.html # index.html.haml
      format.json { render json: @tweets }
      format.js
    end
  end

  # GET /tweets/1
  # GET /tweets/1.json
  def show
    @tweet = Tweet.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      format.json { render json: @tweet }
    end
  end
  
  # POST /tweets/new
  # POST /tweets/new.json
  def new
    @tweet = Tweet.new
    
    @ids = params[:influencers]
    
    @influencers = Influencer.find_all_by_id(@ids)
    @campaigns = Campaign.find_all_by_advertiser_id(current_entity_id)
    
    respond_to do |format|
      format.html # new.html.haml
      format.json { render json: @tweet }
    end
  end

  # GET /tweets/edit/1
  def edit
    @tweet = Tweet.find(params[:id])
    @influencer = Influencer.find(current_entity_id)
  end

  # POST /tweets
  # POST /tweets.json
  def create
    params[:tweet][:advertiser_id] = current_entity_id
    
    @tweets = Array.new
    
    params[:ids].split(" ").each do |id|
      params[:tweet][:influencer_id] = id
            
      @tweets << params[:tweet].deep_dup()
    end
    
    respond_to do |format|
      if Tweet.create(@tweets)
        format.html { redirect_to tweets_url }
        format.json { render json: @tweet, status: :created, location: @tweet }
      else
        format.html { render action: "new" }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tweets/1
  # PUT /tweets/1.json
  def update
    @tweet = Tweet.find(params[:id])
    @tweet.status = 'X'

    respond_to do |format|
      if @tweet.update_attributes(params[:tweet])
        format.html { redirect_to tweets_url }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /tweets/finalize/1
  # GET /tweets/finalize/1.json
  def finalize
    @tweet = Tweet.find(params[:id])
    @tweet.status = 'F'
        
    @tweet.save

    respond_to do |format|
      format.html { redirect_to tweets_url }
      format.json { head :ok }
    end
  end

  # GET /tweets/approve/1
  # GET /tweets/approve/1.json
  def approve
    @tweet = Tweet.find(params[:id])
    @tweet.status = 'A'
    @tweet.save

    respond_to do |format|
      format.html { redirect_to tweets_url }
      format.json { head :ok }
    end
  end

  # DELETE /tweets/1
  # DELETE /tweets/1.json
  def destroy    
    @tweet = Tweet.find(params[:id])
    
    current_user.role == "advertiser" ? @tweet.status = 'I' : @tweet.status = 'R'

    @tweet.save
    
    respond_to do |format|
      format.html { redirect_to tweets_url }
      format.json { head :ok }
    end
  end
end