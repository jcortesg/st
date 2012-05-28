class RenameAudiencesMomsToFemales < ActiveRecord::Migration
  def up
    rename_column :audiences, :moms, :females
  end

  def down
    rename_column :audiences, :females, :moms
  end
end
