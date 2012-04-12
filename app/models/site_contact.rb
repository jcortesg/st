class SiteContact < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :subject
  validates_presence_of :message

  attr_accessible :name, :email, :subject, :message
end
