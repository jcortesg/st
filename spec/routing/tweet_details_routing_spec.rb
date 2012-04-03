require "spec_helper"

describe TweetDetailsController do
  describe "routing" do

    it "routes to #index" do
      get("/tweet_details").should route_to("tweet_details#index")
    end

    it "routes to #new" do
      get("/tweet_details/new").should route_to("tweet_details#new")
    end

    it "routes to #show" do
      get("/tweet_details/1").should route_to("tweet_details#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tweet_details/1/edit").should route_to("tweet_details#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tweet_details").should route_to("tweet_details#create")
    end

    it "routes to #update" do
      put("/tweet_details/1").should route_to("tweet_details#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tweet_details/1").should route_to("tweet_details#destroy", :id => "1")
    end

  end
end
