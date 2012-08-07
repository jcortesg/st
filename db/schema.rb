# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120806042018) do

  create_table "advertisers", :force => true do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "position"
    t.string   "twitter_location"
    t.string   "twitter_image_url"
    t.string   "twitter_bio"
    t.string   "twitter_screen_name"
    t.string   "company"
    t.string   "brand"
    t.string   "web"
    t.string   "advertising_source"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.integer  "zip_code"
    t.string   "phone"
    t.boolean  "can_create_campaigns", :default => false, :null => false
    t.boolean  "can_create_click_fee", :default => false, :null => false
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "advertisers", ["user_id"], :name => "index_advertisers_on_user_id", :unique => true

  create_table "affiliates", :force => true do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "position"
    t.string   "twitter_location"
    t.string   "twitter_image_url"
    t.string   "twitter_bio"
    t.string   "twitter_screen_name"
    t.string   "company"
    t.string   "brand"
    t.string   "web"
    t.string   "advertising_source"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.integer  "zip_code"
    t.string   "phone"
    t.string   "preferred_payment"
    t.string   "account_number"
    t.string   "account_type"
    t.string   "bank_name"
    t.string   "cbu"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "affiliates", ["user_id"], :name => "index_affiliates_on_user_id", :unique => true

  create_table "audiences", :force => true do |t|
    t.integer  "influencer_id"
    t.integer  "followers",              :default => 0, :null => false
    t.integer  "friends",                :default => 0, :null => false
    t.integer  "tweets",                 :default => 0, :null => false
    t.integer  "retweets",               :default => 0, :null => false
    t.integer  "peerindex",              :default => 0, :null => false
    t.integer  "klout",                  :default => 0, :null => false
    t.integer  "males",                  :default => 0, :null => false
    t.integer  "females",                :default => 0, :null => false
    t.integer  "moms",                   :default => 0, :null => false
    t.integer  "teens",                  :default => 0, :null => false
    t.integer  "college_students",       :default => 0, :null => false
    t.integer  "young_women",            :default => 0, :null => false
    t.integer  "young_men",              :default => 0, :null => false
    t.integer  "adult_women",            :default => 0, :null => false
    t.integer  "adult_men",              :default => 0, :null => false
    t.integer  "sports",                 :default => 0, :null => false
    t.integer  "fashion",                :default => 0, :null => false
    t.integer  "music",                  :default => 0, :null => false
    t.integer  "movies",                 :default => 0, :null => false
    t.integer  "politics",               :default => 0, :null => false
    t.integer  "technology",             :default => 0, :null => false
    t.integer  "travel",                 :default => 0, :null => false
    t.integer  "luxury",                 :default => 0, :null => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.integer  "country_argentina",      :default => 0, :null => false
    t.integer  "country_colombia",       :default => 0, :null => false
    t.integer  "country_chile",          :default => 0, :null => false
    t.integer  "country_ecuador",        :default => 0, :null => false
    t.integer  "country_paraguay",       :default => 0, :null => false
    t.integer  "country_uruguay",        :default => 0, :null => false
    t.integer  "state_buenos_aires",     :default => 0, :null => false
    t.integer  "state_catamarca",        :default => 0, :null => false
    t.integer  "state_chaco",            :default => 0, :null => false
    t.integer  "state_cordoba",          :default => 0, :null => false
    t.integer  "state_corrientes",       :default => 0, :null => false
    t.integer  "state_entre_rios",       :default => 0, :null => false
    t.integer  "state_formosa",          :default => 0, :null => false
    t.integer  "state_jujuy",            :default => 0, :null => false
    t.integer  "state_la_pampa",         :default => 0, :null => false
    t.integer  "state_la_rioja",         :default => 0, :null => false
    t.integer  "state_mendoza",          :default => 0, :null => false
    t.integer  "state_misiones",         :default => 0, :null => false
    t.integer  "state_neuquen",          :default => 0, :null => false
    t.integer  "state_rio_negro",        :default => 0, :null => false
    t.integer  "state_salta",            :default => 0, :null => false
    t.integer  "state_san_juan",         :default => 0, :null => false
    t.integer  "state_san_luis",         :default => 0, :null => false
    t.integer  "state_santa_cruz",       :default => 0, :null => false
    t.integer  "state_santa_fe",         :default => 0, :null => false
    t.integer  "state_sgo_del_estero",   :default => 0, :null => false
    t.integer  "state_tierra_del_fuego", :default => 0, :null => false
    t.integer  "state_tucuman",          :default => 0, :null => false
    t.integer  "males_count",            :default => 0, :null => false
    t.integer  "females_count",          :default => 0, :null => false
    t.integer  "moms_count",             :default => 0, :null => false
    t.integer  "teens_count",            :default => 0, :null => false
    t.integer  "college_students_count", :default => 0, :null => false
    t.integer  "young_women_count",      :default => 0, :null => false
    t.integer  "young_men_count",        :default => 0, :null => false
    t.integer  "adult_women_count",      :default => 0, :null => false
    t.integer  "adult_men_count",        :default => 0, :null => false
    t.integer  "sports_count",           :default => 0, :null => false
    t.integer  "fashion_count",          :default => 0, :null => false
    t.integer  "music_count",            :default => 0, :null => false
    t.integer  "movies_count",           :default => 0, :null => false
    t.integer  "politics_count",         :default => 0, :null => false
    t.integer  "technology_count",       :default => 0, :null => false
    t.integer  "travel_count",           :default => 0, :null => false
    t.integer  "luxury_count",           :default => 0, :null => false
  end

  add_index "audiences", ["influencer_id"], :name => "index_audiences_on_influencer_id"

  create_table "campaign_metrics", :force => true do |t|
    t.integer  "campaign_id"
    t.date     "metric_on"
    t.integer  "clicks",      :default => 0, :null => false
    t.integer  "retweets",    :default => 0, :null => false
    t.integer  "mentions",    :default => 0, :null => false
    t.integer  "hashtags",    :default => 0, :null => false
    t.integer  "followers",   :default => 0, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "campaigns", :force => true do |t|
    t.integer  "advertiser_id"
    t.string   "name"
    t.text     "objective"
    t.string   "twitter_screen_name"
    t.string   "status"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean  "price_per_click",                                     :default => false, :null => false
    t.text     "locations"
    t.text     "followers_qty"
    t.text     "tweet_price"
    t.boolean  "males"
    t.boolean  "females"
    t.boolean  "moms"
    t.boolean  "teens"
    t.boolean  "college_students"
    t.boolean  "young_women"
    t.boolean  "young_men"
    t.boolean  "adult_women"
    t.boolean  "adult_men"
    t.boolean  "sports"
    t.boolean  "fashion"
    t.boolean  "music"
    t.boolean  "movies"
    t.boolean  "politics"
    t.boolean  "technology"
    t.boolean  "travel"
    t.boolean  "luxury"
    t.integer  "clicks_count",                                        :default => 0,     :null => false
    t.integer  "retweets_count",                                      :default => 0,     :null => false
    t.integer  "mentions_count",                                      :default => 0,     :null => false
    t.integer  "hashtag_count",                                       :default => 0,     :null => false
    t.integer  "followers_start_count"
    t.integer  "followers_end_count"
    t.integer  "reach",                                               :default => 0,     :null => false
    t.integer  "share",                                               :default => 0,     :null => false
    t.decimal  "cost",                  :precision => 8, :scale => 2, :default => 0.0,   :null => false
    t.datetime "created_at",                                                             :null => false
    t.datetime "updated_at",                                                             :null => false
    t.text     "instructions"
    t.string   "hashtag"
  end

  add_index "campaigns", ["advertiser_id"], :name => "index_campaigns_on_advertiser_id"

  create_table "cash_outs", :force => true do |t|
    t.integer  "user_id"
    t.decimal  "amount",     :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.string   "status"
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
  end

  create_table "clicks", :force => true do |t|
    t.integer  "tweet_id"
    t.string   "remote_ip"
    t.string   "remote_agent"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "clicks", ["tweet_id"], :name => "index_clicks_on_tweet_id"

  create_table "hashtags", :force => true do |t|
    t.integer  "campaign_id"
    t.string   "hashtag"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "influencers", :force => true do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "twitter_location"
    t.string   "twitter_image_url"
    t.string   "twitter_bio"
    t.datetime "twitter_joined"
    t.decimal  "borwin_fee",              :precision => 8, :scale => 2, :default => 0.3,   :null => false
    t.string   "influencer_type"
    t.string   "sex"
    t.date     "birthday"
    t.text     "description"
    t.string   "referrer_description"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.integer  "zip_code"
    t.string   "phone"
    t.string   "cell_phone"
    t.string   "contact_time"
    t.string   "contact_method"
    t.string   "preferred_payment"
    t.string   "account_number"
    t.string   "account_type"
    t.string   "cbu"
    t.string   "bank_name"
    t.decimal  "automatic_tweet_fee",     :precision => 8, :scale => 2
    t.decimal  "automatic_cpc_fee",       :precision => 5, :scale => 2
    t.decimal  "manual_tweet_fee",        :precision => 8, :scale => 2
    t.decimal  "manual_cpc_fee",          :precision => 8, :scale => 2
    t.datetime "created_at",                                                               :null => false
    t.datetime "updated_at",                                                               :null => false
    t.decimal  "campaign_fee",            :precision => 8, :scale => 2, :default => 0.0,   :null => false
    t.integer  "price_category",                                        :default => 2,     :null => false
    t.boolean  "technology_influential",                                :default => false, :null => false
    t.boolean  "travel_influential",                                    :default => false, :null => false
    t.boolean  "sports_influential",                                    :default => false, :null => false
    t.boolean  "music_influential",                                     :default => false, :null => false
    t.boolean  "politics_influential",                                  :default => false, :null => false
    t.boolean  "fashion_influential",                                   :default => false, :null => false
    t.boolean  "movies_influential",                                    :default => false, :null => false
    t.boolean  "luxury_influential",                                    :default => false, :null => false
    t.boolean  "moms_influential",                                      :default => false, :null => false
    t.boolean  "teens_influential",                                     :default => false, :null => false
    t.boolean  "college_influential",                                   :default => false, :null => false
    t.boolean  "young_women_influential",                               :default => false, :null => false
    t.boolean  "young_men_influential",                                 :default => false, :null => false
    t.boolean  "adult_women_influential",                               :default => false, :null => false
    t.boolean  "adult_men_influential",                                 :default => false, :null => false
  end

  add_index "influencers", ["user_id"], :name => "index_influencers_on_user_id", :unique => true

  create_table "keywords", :force => true do |t|
    t.string   "name"
    t.text     "keywords"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "retweets", :force => true do |t|
    t.integer  "tweet_id"
    t.string   "twitter_id"
    t.string   "twitter_screen_name"
    t.datetime "twitter_created_at"
    t.integer  "twitter_retweet_count"
    t.integer  "twitter_friends_count"
    t.integer  "twitter_followers_count"
    t.string   "twitter_image_url"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "site_advertiser_contacts", :force => true do |t|
    t.string   "name"
    t.string   "company"
    t.string   "email"
    t.string   "campaign"
    t.text     "objectives"
    t.string   "budget"
    t.string   "date"
    t.text     "demographic"
    t.text     "hobbies"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "position"
  end

  create_table "site_contacts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "subject"
    t.text     "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "transactions", :force => true do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.integer  "user_id"
    t.datetime "transaction_at",                                                      :null => false
    t.string   "transaction_type",                                                    :null => false
    t.text     "details"
    t.boolean  "borwin_transaction",                               :default => false, :null => false
    t.decimal  "amount",             :precision => 8, :scale => 2, :default => 0.0,   :null => false
    t.decimal  "balance",            :precision => 8, :scale => 2, :default => 0.0,   :null => false
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
    t.integer  "referrer_id"
    t.integer  "cash_out_id"
  end

  add_index "transactions", ["cash_out_id"], :name => "index_transactions_on_cash_out_id"
  add_index "transactions", ["transaction_at"], :name => "index_transactions_on_transaction_at"
  add_index "transactions", ["user_id"], :name => "index_transactions_on_user_id"

  create_table "tweet_groups", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "influencer_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "tweets", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "influencer_id"
    t.integer  "tweet_group_id"
    t.string   "text"
    t.datetime "tweet_at"
    t.string   "link_code"
    t.string   "link_url"
    t.string   "fee_type"
    t.decimal  "tweet_fee",            :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "cpc_fee",              :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.integer  "clicks_count",                                       :default => 0,   :null => false
    t.string   "status"
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
    t.decimal  "influencer_tweet_fee", :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "influencer_cpc_fee",   :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.string   "twitter_id"
    t.datetime "twitter_created_at"
    t.integer  "retweet_count",                                      :default => 0,   :null => false
    t.text     "reject_cause"
  end

  add_index "tweets", ["campaign_id"], :name => "index_tweets_on_campaign_id"
  add_index "tweets", ["influencer_id"], :name => "index_tweets_on_influencer_id"
  add_index "tweets", ["link_code"], :name => "index_tweets_on_link_code", :unique => true
  add_index "tweets", ["tweet_at"], :name => "index_tweets_on_tweet_at"

  create_table "twitter_countries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "twitter_countries", ["name"], :name => "index_twitter_countries_on_name", :unique => true

  create_table "twitter_followers", :force => true do |t|
    t.integer  "influencer_id"
    t.integer  "twitter_user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "twitter_followers", ["influencer_id", "twitter_user_id"], :name => "index_twitter_followers_on_influencer_id_and_twitter_user_id", :unique => true
  add_index "twitter_followers", ["influencer_id"], :name => "index_twitter_followers_on_influencer_id"
  add_index "twitter_followers", ["twitter_user_id"], :name => "index_twitter_followers_on_twitter_user_id"

  create_table "twitter_states", :force => true do |t|
    t.integer  "twitter_country_id"
    t.string   "name"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "twitter_states", ["name"], :name => "index_twitter_states_on_name", :unique => true

  create_table "twitter_users", :force => true do |t|
    t.string   "twitter_uid"
    t.string   "twitter_screen_name"
    t.string   "name"
    t.string   "location"
    t.string   "profile_image_url"
    t.integer  "followers"
    t.integer  "friends"
    t.integer  "tweets"
    t.integer  "twitter_country_id"
    t.integer  "twitter_state_id"
    t.boolean  "male",                :default => false, :null => false
    t.boolean  "female",              :default => false, :null => false
    t.boolean  "sports",              :default => false, :null => false
    t.boolean  "fashion",             :default => false, :null => false
    t.boolean  "music",               :default => false, :null => false
    t.boolean  "movies",              :default => false, :null => false
    t.boolean  "politics",            :default => false, :null => false
    t.boolean  "technology",          :default => false, :null => false
    t.boolean  "travel",              :default => false, :null => false
    t.boolean  "luxury",              :default => false, :null => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.boolean  "moms",                :default => false, :null => false
    t.boolean  "teens",               :default => false, :null => false
    t.boolean  "college_students",    :default => false, :null => false
    t.boolean  "young_women",         :default => false, :null => false
    t.boolean  "young_men",           :default => false, :null => false
    t.boolean  "adult_women",         :default => false, :null => false
    t.boolean  "adult_men",           :default => false, :null => false
    t.datetime "last_sync_at"
    t.boolean  "invalid_page",        :default => false, :null => false
    t.boolean  "private_tweets",      :default => false, :null => false
  end

  add_index "twitter_users", ["invalid_page"], :name => "index_twitter_users_on_invalid_page"
  add_index "twitter_users", ["last_sync_at"], :name => "index_twitter_users_on_last_sync_at"
  add_index "twitter_users", ["private_tweets"], :name => "index_twitter_users_on_private_tweets"
  add_index "twitter_users", ["twitter_uid"], :name => "index_twitter_users_on_twitter_uid", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                                                 :default => "",    :null => false
    t.string   "encrypted_password",                                    :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "twitter_linked",                                        :default => false, :null => false
    t.string   "twitter_screen_name"
    t.string   "twitter_uid"
    t.string   "twitter_token"
    t.string   "twitter_secret"
    t.string   "role",                                                                     :null => false
    t.string   "invitation_code"
    t.boolean  "approved",                                              :default => false, :null => false
    t.integer  "referrer_id"
    t.date     "referrer_on"
    t.integer  "referrer_commission"
    t.boolean  "mail_on_referral_singup",                               :default => true,  :null => false
    t.boolean  "mail_on_referral_profit",                               :default => true,  :null => false
    t.datetime "created_at",                                                               :null => false
    t.datetime "updated_at",                                                               :null => false
    t.decimal  "balance",                 :precision => 8, :scale => 2, :default => 0.0,   :null => false
  end

  add_index "users", ["approved"], :name => "index_users_on_approved"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_code"], :name => "index_users_on_invitation_code", :unique => true
  add_index "users", ["referrer_id"], :name => "index_users_on_referrer_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["role"], :name => "index_users_on_role"
  add_index "users", ["twitter_screen_name"], :name => "index_users_on_twitter_screen_name", :unique => true

end
