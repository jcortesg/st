require "spec_helper"

describe CompetitorsController do
  describe "routing" do

    it "routes to #index" do
      get("/competitors").should route_to("competitors#index")
    end

    it "routes to #new" do
      get("/competitors/new").should route_to("competitors#new")
    end

    it "routes to #show" do
      get("/competitors/1").should route_to("competitors#show", :id => "1")
    end

    it "routes to #edit" do
      get("/competitors/1/edit").should route_to("competitors#edit", :id => "1")
    end

    it "routes to #create" do
      post("/competitors").should route_to("competitors#create")
    end

    it "routes to #update" do
      put("/competitors/1").should route_to("competitors#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/competitors/1").should route_to("competitors#destroy", :id => "1")
    end

  end
end
