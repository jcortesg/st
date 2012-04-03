require "spec_helper"

describe InfluencersController do
  describe "routing" do

    it "routes to #index" do
      get("/influencers").should route_to("influencers#index")
    end

    it "routes to #new" do
      get("/influencers/new").should route_to("influencers#new")
    end

    it "routes to #show" do
      get("/influencers/1").should route_to("influencers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/influencers/1/edit").should route_to("influencers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/influencers").should route_to("influencers#create")
    end

    it "routes to #update" do
      put("/influencers/1").should route_to("influencers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/influencers/1").should route_to("influencers#destroy", :id => "1")
    end

  end
end
