require "spec_helper"

describe AdvertisersController do
  describe "routing" do

    it "routes to #index" do
      get("/advertisers").should route_to("advertisers#index")
    end

    it "routes to #new" do
      get("/advertisers/new").should route_to("advertisers#new")
    end

    it "routes to #show" do
      get("/advertisers/1").should route_to("advertisers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/advertisers/1/edit").should route_to("advertisers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/advertisers").should route_to("advertisers#create")
    end

    it "routes to #update" do
      put("/advertisers/1").should route_to("advertisers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/advertisers/1").should route_to("advertisers#destroy", :id => "1")
    end

  end
end
