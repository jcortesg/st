class AddFieldsToAdvertiser < ActiveRecord::Migration
  def change
    add_column :advertisers, :position, :string, after: 'last_name'
    add_column :advertisers, :web, :string, after: 'company'
    add_column :advertisers, :advertising_source, :string, after: 'web'
  end
end
