class UpdateAudiences < ActiveRecord::Migration
  def change
    add_column :audiences, :technology, :int, null: false, default: 0, after: :politics
    add_column :audiences, :travel, :int, null: false, default: 0, after: :technology
    add_column :audiences, :luxury, :int, null: false, default: 0, after: :travel
  end
end
