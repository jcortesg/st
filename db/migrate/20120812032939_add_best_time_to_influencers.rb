class AddBestTimeToInfluencers < ActiveRecord::Migration
  def change
    add_column :influencers, :best_time, :string
  end
end
