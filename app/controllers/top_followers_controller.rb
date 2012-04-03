class TopFollowersController < ApplicationController
  load_and_authorize_resource
  
  # GET /top_followers
  # GET /top_followers.json
  def index
    @top_followers = TopFollower.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @top_followers }
    end
  end

  # GET /top_followers/1
  # GET /top_followers/1.json
  def show
    @top_follower = TopFollower.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @top_follower }
    end
  end

  # GET /top_followers/new
  # GET /top_followers/new.json
  def new
    @top_follower = TopFollower.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @top_follower }
    end
  end

  # GET /top_followers/1/edit
  def edit
    @top_follower = TopFollower.find(params[:id])
  end

  # POST /top_followers
  # POST /top_followers.json
  def create
    @top_follower = TopFollower.new(params[:top_follower])

    respond_to do |format|
      if @top_follower.save
        format.html { redirect_to @top_follower, notice: 'Top follower was successfully created.' }
        format.json { render json: @top_follower, status: :created, location: @top_follower }
      else
        format.html { render action: "new" }
        format.json { render json: @top_follower.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /top_followers/1
  # PUT /top_followers/1.json
  def update
    @top_follower = TopFollower.find(params[:id])

    respond_to do |format|
      if @top_follower.update_attributes(params[:top_follower])
        format.html { redirect_to @top_follower, notice: 'Top follower was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @top_follower.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /top_followers/1
  # DELETE /top_followers/1.json
  def destroy
    @top_follower = TopFollower.find(params[:id])
    @top_follower.destroy

    respond_to do |format|
      format.html { redirect_to top_followers_url }
      format.json { head :ok }
    end
  end
end
