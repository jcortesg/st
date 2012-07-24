class AddTwitterToAdvertsersAndAffiliates < ActiveRecord::Migration
  def change
    add_column :advertisers, :twitter_screen_name, :string, after: 'twitter_bio'
    add_column :affiliates, :twitter_screen_name, :string, after: 'twitter_bio'
  end
end
