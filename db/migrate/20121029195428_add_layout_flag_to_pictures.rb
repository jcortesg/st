class AddLayoutFlagToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :blank_layout, :boolean, :default => true
  end
end
