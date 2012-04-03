require "spec_helper"

describe ReferralsController do
  describe "routing" do

    it "routes to #index" do
      get("/referrals").should route_to("referrals#index")
    end

    it "routes to #new" do
      get("/referrals/new").should route_to("referrals#new")
    end

    it "routes to #show" do
      get("/referrals/1").should route_to("referrals#show", :id => "1")
    end

    it "routes to #edit" do
      get("/referrals/1/edit").should route_to("referrals#edit", :id => "1")
    end

    it "routes to #create" do
      post("/referrals").should route_to("referrals#create")
    end

    it "routes to #update" do
      put("/referrals/1").should route_to("referrals#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/referrals/1").should route_to("referrals#destroy", :id => "1")
    end

  end
end
