class AddLocationsToAudiences < ActiveRecord::Migration
  def change
    add_column :audiences, :country_argentina, :int, default: 0, null: false
    add_column :audiences, :country_colombia, :int, default: 0, null: false
    add_column :audiences, :country_chile, :int, default: 0, null: false
    add_column :audiences, :country_ecuador, :int, default: 0, null: false
    add_column :audiences, :country_paraguay, :int, default: 0, null: false
    add_column :audiences, :country_uruguay, :int, default: 0, null: false

    add_column :audiences, :state_buenos_aires, :int, default: 0, null: false
    add_column :audiences, :state_catamarca, :int, default: 0, null: false
    add_column :audiences, :state_chaco, :int, default: 0, null: false
    add_column :audiences, :state_cordoba, :int, default: 0, null: false
    add_column :audiences, :state_corrientes, :int, default: 0, null: false
    add_column :audiences, :state_entre_rios, :int, default: 0, null: false
    add_column :audiences, :state_formosa, :int, default: 0, null: false
    add_column :audiences, :state_jujuy, :int, default: 0, null: false
    add_column :audiences, :state_la_pampa, :int, default: 0, null: false
    add_column :audiences, :state_la_rioja, :int, default: 0, null: false
    add_column :audiences, :state_mendoza, :int, default: 0, null: false
    add_column :audiences, :state_misiones, :int, default: 0, null: false
    add_column :audiences, :state_neuquen, :int, default: 0, null: false
    add_column :audiences, :state_rio_negro, :int, default: 0, null: false
    add_column :audiences, :state_salta, :int, default: 0, null: false
    add_column :audiences, :state_san_juan, :int, default: 0, null: false
    add_column :audiences, :state_san_luis, :int, default: 0, null: false
    add_column :audiences, :state_santa_cruz, :int, default: 0, null: false
    add_column :audiences, :state_santa_fe, :int, default: 0, null: false
    add_column :audiences, :state_sgo_del_estero, :int, default: 0, null: false
    add_column :audiences, :state_tierra_del_fuego, :int, default: 0, null: false
    add_column :audiences, :state_tucuman, :int, default: 0, null: false
  end
end
