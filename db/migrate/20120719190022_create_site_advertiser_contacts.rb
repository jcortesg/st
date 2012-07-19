class CreateSiteAdvertiserContacts < ActiveRecord::Migration
  def change
    create_table :site_advertiser_contacts do |t|
      t.string :name
      t.string :company
      t.string :email
      t.string :campaign
      t.text :objectives
      t.string :budget
      t.string :date
      t.text :demographic
      t.text :hobbies

      t.timestamps
    end
  end
end
