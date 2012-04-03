require "spec_helper"

describe AudiencesLocationsController do
  describe "routing" do

    it "routes to #index" do
      get("/audiences_locations").should route_to("audiences_locations#index")
    end

    it "routes to #new" do
      get("/audiences_locations/new").should route_to("audiences_locations#new")
    end

    it "routes to #show" do
      get("/audiences_locations/1").should route_to("audiences_locations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/audiences_locations/1/edit").should route_to("audiences_locations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/audiences_locations").should route_to("audiences_locations#create")
    end

    it "routes to #update" do
      put("/audiences_locations/1").should route_to("audiences_locations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/audiences_locations/1").should route_to("audiences_locations#destroy", :id => "1")
    end

  end
end
