class AddWeekMapToInfluencers < ActiveRecord::Migration
  def change
    add_column :influencers, :week_map_id, :integer
  end
end
