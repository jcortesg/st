class AddMexicoToAudience < ActiveRecord::Migration
  def change
    add_column :audiences, :country_mexico, :int, default: 0, null: false, :after => :country_ecuador
  end
end
