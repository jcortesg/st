class AddFieldsToAffiliates < ActiveRecord::Migration
  def change
    add_column :affiliates, :position, :string, after: 'last_name'
    add_column :affiliates, :twitter_location, :string, after: 'position'
    add_column :affiliates, :twitter_image_url, :string, after: 'twitter_location'
    add_column :affiliates, :twitter_bio, :string, after: 'twitter_image_url'
    add_column :affiliates, :brand, :string, after: 'company'
    add_column :affiliates, :web, :string, after: 'brand'
    add_column :affiliates, :advertising_source, :string, after: 'web'


    add_column :affiliates, :photo_file_name, :string
    add_column :affiliates, :photo_content_type, :string
    add_column :affiliates, :photo_file_size, :integer
    add_column :affiliates, :photo_updated_at, :datetime
  end
end
