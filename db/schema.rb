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

ActiveRecord::Schema.define(:version => 20120604063657) do

  create_table "advertisers", :force => true do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "twitter_location"
    t.string   "twitter_image_url"
    t.string   "twitter_bio"
    t.string   "company"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.integer  "zip_code"
    t.string   "phone"
    t.boolean  "can_create_campaigns", :default => false, :null => false
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  add_index "advertisers", ["user_id"], :name => "index_advertisers_on_user_id", :unique => true

  create_table "affiliates", :force => true do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company"
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
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "affiliates", ["user_id"], :name => "index_affiliates_on_user_id", :unique => true

  create_table "audiences", :force => true do |t|
    t.integer  "influencer_id"
    t.integer  "followers",           :default => 0, :null => false
    t.integer  "friends",             :default => 0, :null => false
    t.integer  "tweets",              :default => 0, :null => false
    t.integer  "retweets",            :default => 0, :null => false
    t.integer  "peerindex",           :default => 0, :null => false
    t.integer  "klout",               :default => 0, :null => false
    t.integer  "males",               :default => 0, :null => false
    t.integer  "females",             :default => 0, :null => false
    t.integer  "moms",                :default => 0, :null => false
    t.integer  "teens",               :default => 0, :null => false
    t.integer  "college_students",    :default => 0, :null => false
    t.integer  "young_women",         :default => 0, :null => false
    t.integer  "young_men",           :default => 0, :null => false
    t.integer  "adult_women",         :default => 0, :null => false
    t.integer  "adult_men",           :default => 0, :null => false
    t.integer  "sports",              :default => 0, :null => false
    t.integer  "fashion",             :default => 0, :null => false
    t.integer  "music",               :default => 0, :null => false
    t.integer  "movies",              :default => 0, :null => false
    t.integer  "politics",            :default => 0, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "audiences", ["influencer_id"], :name => "index_audiences_on_influencer_id"

  create_table "campaigns", :force => true do |t|
    t.integer  "advertiser_id"
    t.string   "name"
    t.text     "objective"
    t.boolean  "archived",                                         :default => false, :null => false
    t.text     "locations"
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
    t.string   "followers_quantity"
    t.integer  "clicks_count",                                     :default => 0,     :null => false
    t.decimal  "cost",               :precision => 8, :scale => 2, :default => 0.0,   :null => false
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
  end

  add_index "campaigns", ["advertiser_id"], :name => "index_campaigns_on_advertiser_id"
  add_index "campaigns", ["archived"], :name => "index_campaigns_on_archived"

  create_table "clicks", :force => true do |t|
    t.integer  "tweet_id"
    t.string   "remote_ip"
    t.string   "remote_agent"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "clicks", ["tweet_id"], :name => "index_clicks_on_tweet_id"

  create_table "influencers", :force => true do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "twitter_location"
    t.string   "twitter_image_url"
    t.string   "twitter_bio"
    t.datetime "twitter_joined"
    t.decimal  "borwin_fee",           :precision => 8, :scale => 2, :default => 0.3, :null => false
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
    t.decimal  "automatic_tweet_fee",  :precision => 8, :scale => 2
    t.decimal  "automatic_cpc_fee",    :precision => 5, :scale => 2
    t.decimal  "manual_tweet_fee",     :precision => 8, :scale => 2
    t.decimal  "manual_cpc_fee",       :precision => 8, :scale => 2
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
  end

  add_index "influencers", ["user_id"], :name => "index_influencers_on_user_id", :unique => true

  create_table "site_contacts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "subject"
    t.text     "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tweets", :force => true do |t|
    t.integer  "campaign_id"
    t.string   "text"
    t.string   "link_code"
    t.string   "link_url"
    t.string   "fee_type"
    t.decimal  "tweet_fee",    :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "cpc",          :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.integer  "clicks_count",                               :default => 0,   :null => false
    t.string   "status"
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
  end

  add_index "tweets", ["campaign_id"], :name => "index_tweets_on_campaign_id"
  add_index "tweets", ["link_code"], :name => "index_tweets_on_link_code", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                   :default => "",    :null => false
    t.string   "encrypted_password",      :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "twitter_linked",          :default => false, :null => false
    t.string   "twitter_screen_name"
    t.string   "twitter_uid"
    t.string   "twitter_token"
    t.string   "twitter_secret"
    t.string   "role",                                       :null => false
    t.string   "invitation_code"
    t.boolean  "approved",                :default => false, :null => false
    t.integer  "referrer_id"
    t.date     "referrer_on"
    t.integer  "referrer_commission"
    t.boolean  "mail_on_referral_singup", :default => true,  :null => false
    t.boolean  "mail_on_referral_profit", :default => true,  :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "users", ["approved"], :name => "index_users_on_approved"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_code"], :name => "index_users_on_invitation_code", :unique => true
  add_index "users", ["referrer_id"], :name => "index_users_on_referrer_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["role"], :name => "index_users_on_role"
  add_index "users", ["twitter_screen_name"], :name => "index_users_on_twitter_screen_name", :unique => true

end
