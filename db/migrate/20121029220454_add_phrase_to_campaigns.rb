class AddPhraseToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :phrase, :text
  end
end
