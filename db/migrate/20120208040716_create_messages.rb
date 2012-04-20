class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :source_id
      t.integer :destination_id
      t.string :title
      t.string :message
      t.boolean :read, :default => false
      
      t.timestamps
    end

    add_index :messages, :source_id, unique: false
    add_index :messages, :destination_id, unique: false
    add_index :messages, [:source_id, :destination_id], unique: false
  end
end
