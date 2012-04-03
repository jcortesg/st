require "spec_helper"

describe AffiliatesController do
  describe "routing" do

    it "routes to #index" do
      get("/affiliates").should route_to("affiliates#index")
    end

    it "routes to #new" do
      get("/affiliates/new").should route_to("affiliates#new")
    end

    it "routes to #show" do
      get("/affiliates/1").should route_to("affiliates#show", :id => "1")
    end

    it "routes to #edit" do
      get("/affiliates/1/edit").should route_to("affiliates#edit", :id => "1")
    end

    it "routes to #create" do
      post("/affiliates").should route_to("affiliates#create")
    end

    it "routes to #update" do
      put("/affiliates/1").should route_to("affiliates#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/affiliates/1").should route_to("affiliates#destroy", :id => "1")
    end

  end
end
