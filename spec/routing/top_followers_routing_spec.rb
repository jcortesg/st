require "spec_helper"

describe TopFollowersController do
  describe "routing" do

    it "routes to #index" do
      get("/top_followers").should route_to("top_followers#index")
    end

    it "routes to #new" do
      get("/top_followers/new").should route_to("top_followers#new")
    end

    it "routes to #show" do
      get("/top_followers/1").should route_to("top_followers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/top_followers/1/edit").should route_to("top_followers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/top_followers").should route_to("top_followers#create")
    end

    it "routes to #update" do
      put("/top_followers/1").should route_to("top_followers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/top_followers/1").should route_to("top_followers#destroy", :id => "1")
    end

  end
end
