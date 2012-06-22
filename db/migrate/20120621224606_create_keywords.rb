class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.string :name
      t.text :keywords

      t.timestamps
    end
  end
end
