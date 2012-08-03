class AddInstructionsToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :instructions, :text
    add_column :campaigns, :hashtag, :string
  end
end
