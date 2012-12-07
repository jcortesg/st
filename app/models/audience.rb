# encoding: utf-8
class Audience < ActiveRecord::Base
  belongs_to :influencer

  attr_accessible :followers, :followers_followers, :friends, :tweets, :retweets, :peerindex, :klout, :kred,
                  :males, :females, :kids, :young_teens, :mature_teens, :young_adults, :mature_adults,
                  :adults, :elderly, :sports, :fashion, :music, :movies, :politics, :technology,
                  :travel, :luxury, :moms, :teens, :college_students, :young_women, :young_men,
                  :adult_women, :adult_men, :males_count, :females_count, :moms_count, :teens_count,
                  :college_students_count, :young_women_count,  :young_men_count,  :adult_women_count,
                  :adult_men_count, :sports_count, :fashion_count, :music_count, :movies_count, :politics_count,
                  :technology_count, :travel_count, :luxury_count

  validates :followers, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :friends, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :tweets, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :retweets, presence: true, numericality: { greater_than_or_equal_to: 0 }

  validates :males, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :females, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :moms, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :teens, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :college_students, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :young_women, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :young_men, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :adult_women, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :adult_men, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  validates :sports, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :fashion, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :music, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :movies, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :politics, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :technology, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :travel, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :luxury, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }


  def hobbies_others
    100 - sports - fashion - music - movies - politics - technology - travel - luxury
  end

  def country_others
    100 - country_argentina - country_colombia - country_chile - country_ecuador - country_paraguay - country_uruguay
  end

  def state_others
    100 - state_buenos_aires - state_catamarca - state_chaco - state_cordoba - state_corrientes - state_entre_rios -
      state_formosa - state_jujuy - state_la_pampa - state_la_rioja - state_mendoza - state_misiones - state_neuquen -
      state_rio_negro - state_salta - state_san_juan - state_san_luis - state_santa_cruz - state_santa_fe -
      state_sgo_del_estero - state_tierra_del_fuego - state_tucuman
  end

  def state_others_chi
    100 - state_chi_arica - state_chi_tarapaca - state_chi_antofogasta - state_chi_atacama -
      state_chi_coquimbo - state_chi_valparaiso - state_chi_santiago - state_chi_ohiggins -
      state_chi_maule - state_chi_biobio - state_chi_la_araucania - state_chi_los_rios -
      state_chi_los_lagos - state_chi_aysen - state_chi_magallanes
  end

  def state_others_col
    100 - state_col_amazonas - state_col_antioquia - state_col_arauca - state_col_atlantico - state_col_bolivar -
      state_col_boyaca - state_col_caldas - state_col_caqueta - state_col_casanare - state_col_cauca -
      state_col_cesar - state_col_choco - state_col_cordoba - state_col_cundinamarca - state_col_guainia -
      state_col_guaviare - state_col_huila - state_col_la_guajira - state_col_magdalena - state_col_meta -
      state_col_narino - state_col_norte_de_santander - state_col_putumayo - state_col_quindio -
      state_col_risaralda - state_col_san_andres - state_col_santander - state_col_sucre - state_col_tolima -
      state_col_valle_del_cauca - state_col_vaupes - state_col_vichada - state_col_colombia
  end

  def state_others_ecu
    100  - state_ecu_azuay- state_ecu_bolivar - state_ecu_canar - state_ecu_carchi - state_ecu_chimborazo -
      state_ecu_cotopaxi - state_ecu_el_oro - state_ecu_esmeraldas - state_ecu_galapagos - state_ecu_guayas -
      state_ecu_imbabura - state_ecu_loja - state_ecu_los_rios - state_ecu_manabi - state_ecu_morona_santiago -
      state_ecu_napo - state_ecu_orellana - state_ecu_pastaza - state_ecu_pichincha - state_ecu_santa_elena -
      state_ecu_santo_domingo - state_ecu_sucumbios - state_ecu_tungurahua - state_ecu_zamora
  end

  def state_others_mex
    100 - state_mex_aguascalientes - state_mex_baja_california - state_mex_baja_california_sur - state_mex_campeche -
      state_mex_chiapas - state_mex_chihuahua - state_mex_coahuila - state_mex_colima - state_mex_distrito_federal -
      state_mex_durango - state_mex_guanajuato - state_mex_guerrero - state_mex_hidalgo - state_mex_jalisco -
      state_mex_mexico - state_mex_michoacan - state_mex_morelos - state_mex_nayarit - state_mex_nuevo_leon -
      state_mex_oaxaca - state_mex_puebla - state_mex_queretaro - state_mex_quintana_roo - state_mex_san_luis -
      state_mex_sinaloa - state_mex_sonora - state_mex_tabasco - state_mex_tamaulipas - state_mex_tlaxcala -
      state_mex_veracruz - state_mex_yucatan - state_mex_zacatecas
  end

  def state_others_par
    100 - state_par_asuncion - state_par_concepcion - state_par_san_pedro - state_par_cordillera - state_par_guaira -
      state_par_caaguazu - state_par_caazapa - state_par_itapua - state_par_misiones -
      state_par_paraguari- state_par_alto_parana - state_par_central - state_par_neenbucu -
      state_par_amambay - state_par_canindeyu - state_par_presidente_hayes - state_par_alto_paraguay -
      state_par_boqueron
  end

  def state_others_uru
    100 - state_uru_artigas - state_uru_canelones - state_uru_cerro_largo - state_uru_colonia - state_uru_durazno -
      state_uru_flores - state_uru_florida - state_uru_lavalleja - state_uru_maldonado - state_uru_montevideo -
      state_uru_paysandu - state_uru_rio_negro - state_uru_rivera - state_uru_rocha - state_uru_salto -
      state_uru_san_jose - state_uru_soriano - state_uru_tacuarembo - state_uru_treinta_y_tres
  end

end
