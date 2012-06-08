class RenameCpcToCpcFeeOnTweet < ActiveRecord::Migration
  def change
    rename_column :tweets, :cpc, :cpc_fee
  end
end
