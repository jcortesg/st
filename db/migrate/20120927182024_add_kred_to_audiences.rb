class AddKredToAudiences < ActiveRecord::Migration
  def change
    add_column :audiences, :kred, :integer, default: 0, null: false
  end
end
