# encoding: utf-8
class Admin::AdvertisersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin

  # Show the list of advertisers
  def index

  end
end
