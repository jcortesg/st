class UpdateCampaignFields < ActiveRecord::Migration
  def up
    remove_column :campaigns, :followers_quantity
    add_column :campaigns, :technology, :boolean, after: :politics
    add_column :campaigns, :travel, :boolean, after: :technology
    add_column :campaigns, :luxury, :boolean, after: :travel
    add_column :campaigns, :followers_qty, :text, after: :locations
    add_column :campaigns, :tweet_price, :text, after: :followers_qty
  end

  def down
    remove_column :campaigns, :technology
    remove_column :campaigns, :travel
    remove_column :campaigns, :luxury
    remove_column :campaigns, :followers_qty
    remove_column :campaigns, :tweet_price
    add_column :campaigns, :followers_quantity, :string, after: :politics
  end
end
