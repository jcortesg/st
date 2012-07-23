class SiteAdvertiserContact < ActiveRecord::Base
  attr_accessible :name, :company, :email, :campaign, :objectives, :budget, :date, :demographic, :hobbies, :position

  validates :name, presence: true
  validates :company, presence: true
  validates :position, presence: true
  validates :email, presence: true
  validates :budget, presence: true

  serialize :demographic, Array
  serialize :hobbies, Array


  after_create :send_email_to_borwin

  private

  def send_email_to_borwin
    Notifier.advertiser_contact(self).deliver
  end

end
