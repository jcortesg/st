require "spec_helper"

describe AudiencesController do
  describe "routing" do

    it "routes to #index" do
      get("/audiences").should route_to("audiences#index")
    end

    it "routes to #new" do
      get("/audiences/new").should route_to("audiences#new")
    end

    it "routes to #show" do
      get("/audiences/1").should route_to("audiences#show", :id => "1")
    end

    it "routes to #edit" do
      get("/audiences/1/edit").should route_to("audiences#edit", :id => "1")
    end

    it "routes to #create" do
      post("/audiences").should route_to("audiences#create")
    end

    it "routes to #update" do
      put("/audiences/1").should route_to("audiences#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/audiences/1").should route_to("audiences#destroy", :id => "1")
    end

  end
end
