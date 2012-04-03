require 'spec_helper'

describe "TopFollowers" do
  describe "GET /top_followers" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get top_followers_path
      response.status.should be(200)
    end
  end
end
