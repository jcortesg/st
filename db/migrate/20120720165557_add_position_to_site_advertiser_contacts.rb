class AddPositionToSiteAdvertiserContacts < ActiveRecord::Migration
  def change
    add_column :site_advertiser_contacts, :position, :string
  end
end
