class CreateTwitterStates < ActiveRecord::Migration
  def change
    create_table :twitter_states do |t|
      t.references :twitter_country

      t.string :name

      t.timestamps
    end
    add_index :twitter_states, :name, unique: true
  end
end
