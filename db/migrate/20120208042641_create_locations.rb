class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :suburb
      t.string :city
      t.string :state
      t.string :country
      t.string :status, :lenght => 1, :default => "A"

      t.timestamps
    end
  end
end
