class CreateTwitterCountries < ActiveRecord::Migration
  def change
    create_table :twitter_countries do |t|
      t.string :name

      t.timestamps
    end
    add_index :twitter_countries, :name, unique: true
  end
end
