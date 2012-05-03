class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.integer :advertiser_id
      t.string :name
      t.string :description
      t.string :status, :lenght => 1, :default => "A"

      t.timestamps
    end
  end
end
