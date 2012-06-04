class UpdateAudiences < ActiveRecord::Migration
  def change
    add_column :audiences, :technology, :int, after: :politics
    add_column :audiences, :travel, :int, after: :technology
    add_column :audiences, :luxury, :int, after: :travel
  end
end
