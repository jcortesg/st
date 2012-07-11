class CreateHashtags < ActiveRecord::Migration
  def change
    create_table :hashtags do |t|
      t.references :campaign

      t.string :hashtag

      t.timestamps
    end
  end
end
