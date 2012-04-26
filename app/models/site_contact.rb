class SiteContact < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :subject
  validates_presence_of :message

  after_create :send_email_to_borwin

  attr_accessible :name, :email, :subject, :message

  private

  def send_email_to_borwin
    Notifier.contact(self).deliver
  end
end
