class Admin::AffiliatesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin

  # Show the list of affiliates
  def index

  end
end
