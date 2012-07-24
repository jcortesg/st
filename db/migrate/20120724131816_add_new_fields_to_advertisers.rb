class AddNewFieldsToAdvertisers < ActiveRecord::Migration
  def change
    add_column :advertisers, :brand, :string, after: 'company'

    add_column :advertisers, :photo_file_name, :string
    add_column :advertisers, :photo_content_type, :string
    add_column :advertisers, :photo_file_size, :integer
    add_column :advertisers, :photo_updated_at, :datetime
  end
end
