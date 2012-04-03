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

ActiveRecord::Schema.define(:version => 20120218145310) do

  create_table "advertisers", :force => true do |t|
    t.integer "user_id"
    t.string  "twitter_username"
    t.string  "location"
    t.date    "joined_twitter"
    t.string  "image_url"
    t.string  "brand"
    t.string  "address"
    t.string  "city"
    t.string  "state"
    t.string  "country"
    t.integer "zip_code"
    t.string  "phone"
  end

  add_index "advertisers", ["twitter_username"], :name => "index_advertisers_on_twitter_username", :unique => true
  add_index "advertisers", ["user_id"], :name => "index_advertisers_on_user_id", :unique => true

  create_table "affiliates", :force => true do |t|
    t.integer "user_id"
    t.string  "firstname"
    t.string  "lastname"
    t.string  "address"
    t.string  "city"
    t.string  "state"
    t.string  "country"
    t.integer "zip_code"
    t.string  "phone"
  end

  add_index "affiliates", ["user_id"], :name => "index_affiliates_on_user_id", :unique => true

  create_table "audiences", :force => true do |t|
    t.integer  "influencer_id"
    t.integer  "followers",                                         :default => 0
    t.integer  "followers_followers",                               :default => 0
    t.integer  "friends",                                           :default => 0
    t.integer  "tweets",                                            :default => 0
    t.decimal  "retweets",            :precision => 3, :scale => 2
    t.integer  "peerindex",                                         :default => 0
    t.integer  "klout",                                             :default => 0
    t.decimal  "males",               :precision => 3, :scale => 2
    t.boolean  "moms",                                              :default => false
    t.decimal  "kids",                :precision => 3, :scale => 2
    t.decimal  "young_teens",         :precision => 3, :scale => 2
    t.decimal  "mature_teens",        :precision => 3, :scale => 2
    t.decimal  "young_adults",        :precision => 3, :scale => 2
    t.decimal  "mature_adults",       :precision => 3, :scale => 2
    t.decimal  "adults",              :precision => 3, :scale => 2
    t.decimal  "elderly",             :precision => 3, :scale => 2
    t.boolean  "sports",                                            :default => false
    t.boolean  "fashion",                                           :default => false
    t.boolean  "music",                                             :default => false
    t.boolean  "movies",                                            :default => false
    t.boolean  "politics",                                          :default => false
    t.string   "status",                                            :default => "A"
    t.datetime "created_at",                                                           :null => false
    t.datetime "updated_at",                                                           :null => false
  end

  add_index "audiences", ["influencer_id"], :name => "index_audiences_on_influencer_id"

  create_table "audiences_locations", :force => true do |t|
    t.integer "audience_id"
    t.integer "location_id"
    t.decimal "percentage",  :precision => 3, :scale => 2
  end

  add_index "audiences_locations", ["audience_id"], :name => "index_audiences_locations_on_audience_id"

  create_table "campaigns", :force => true do |t|
    t.integer "advertiser_id"
    t.string  "name"
    t.string  "description"
    t.string  "status",        :default => "A"
  end

  create_table "competitors", :force => true do |t|
    t.integer "advertiser_id"
    t.integer "competitor_id"
  end

  add_index "competitors", ["advertiser_id"], :name => "index_competitors_on_advertiser_id"

  create_table "currencies", :force => true do |t|
    t.string "name"
    t.string "description"
    t.string "status",      :default => "A"
  end

  add_index "currencies", ["name"], :name => "index_currencies_on_name", :unique => true

  create_table "influencers", :force => true do |t|
    t.integer "user_id"
    t.string  "twitter_username"
    t.string  "influencer_type"
    t.decimal "borwin_fee",       :precision => 8, :scale => 2, :default => 0.3
    t.string  "location"
    t.date    "joined_twitter"
    t.string  "image_url"
    t.string  "bio"
    t.string  "description"
    t.string  "contact_method"
    t.string  "firstname"
    t.string  "lastname"
    t.text    "sex"
    t.string  "address"
    t.string  "city"
    t.string  "state"
    t.string  "country"
    t.integer "zip_code"
    t.string  "phone"
    t.string  "cell_phone"
    t.string  "contact_time"
    t.string  "account_number"
    t.string  "account_type"
    t.string  "cbu"
    t.string  "bank_name"
  end

  add_index "influencers", ["twitter_username"], :name => "index_influencers_on_twitter_username", :unique => true
  add_index "influencers", ["user_id"], :name => "index_influencers_on_user_id", :unique => true

  create_table "locations", :force => true do |t|
    t.string "suburb"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "status",  :default => "A"
  end

  create_table "messages", :force => true do |t|
    t.integer  "source_id"
    t.integer  "destination_id"
    t.string   "title"
    t.string   "message"
    t.boolean  "read",           :default => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "messages", ["destination_id"], :name => "index_messages_on_destination_id"

  create_table "payment_methods", :force => true do |t|
    t.string "name"
    t.string "description"
    t.string "status",      :default => "A"
  end

  add_index "payment_methods", ["name"], :name => "index_payment_methods_on_name", :unique => true

  create_table "payment_types", :force => true do |t|
    t.string "name"
    t.string "description"
    t.string "status",      :default => "A"
  end

  add_index "payment_types", ["name"], :name => "index_payment_types_on_name", :unique => true

  create_table "profiles", :force => true do |t|
    t.integer  "influencer_id"
    t.decimal  "fee",           :precision => 8, :scale => 2
    t.decimal  "cpc",           :precision => 5, :scale => 2
    t.decimal  "fee_cpc",       :precision => 8, :scale => 2
    t.decimal  "cpc_fee",       :precision => 5, :scale => 2
    t.string   "status",                                      :default => "A"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
  end

  add_index "profiles", ["influencer_id"], :name => "index_profiles_on_influencer_id"

  create_table "referrals", :force => true do |t|
    t.integer "source_id"
    t.integer "destination_id"
    t.date    "since"
    t.date    "through"
    t.decimal "commission",     :precision => 3, :scale => 2
  end

  add_index "referrals", ["source_id"], :name => "index_referrals_on_source_id"

  create_table "top_followers", :force => true do |t|
    t.integer "influencer_id"
    t.string  "twitter_username"
    t.integer "followers"
    t.integer "followers_followers"
    t.integer "clicks"
    t.integer "retweets"
  end

  add_index "top_followers", ["influencer_id"], :name => "index_top_followers_on_influencer_id"

  create_table "transactions", :force => true do |t|
    t.integer  "tweet_id"
    t.decimal  "amount",               :precision => 8, :scale => 2
    t.decimal  "borwin_amount",        :precision => 8, :scale => 2
    t.integer  "currency_id"
    t.integer  "dineromail_id"
    t.integer  "payment_method_id"
    t.string   "holder"
    t.string   "number"
    t.date     "expiration"
    t.string   "bank"
    t.datetime "payment_date"
    t.boolean  "influencer_paid"
    t.datetime "influencer_paid_date"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
  end

  add_index "transactions", ["dineromail_id"], :name => "index_transactions_on_dineromail_id", :unique => true
  add_index "transactions", ["tweet_id"], :name => "index_transactions_on_tweet_id", :unique => true

  create_table "tweet_details", :force => true do |t|
    t.integer "tweet_id"
    t.integer "clicks"
    t.integer "retweets"
  end

  add_index "tweet_details", ["tweet_id"], :name => "index_tweet_details_on_tweet_id", :unique => true

  create_table "tweets", :force => true do |t|
    t.string   "tweet_id"
    t.string   "tweet"
    t.string   "comments"
    t.string   "url"
    t.integer  "payment_type_id"
    t.integer  "influencer_id"
    t.integer  "advertiser_id"
    t.datetime "date_posted"
    t.datetime "date_required"
    t.integer  "campaign_id"
    t.string   "status",          :default => "X"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "tweets", ["advertiser_id"], :name => "index_tweets_on_advertiser_id"
  add_index "tweets", ["campaign_id"], :name => "index_tweets_on_campaign_id"
  add_index "tweets", ["influencer_id"], :name => "index_tweets_on_influencer_id"

  create_table "twitter_credentials", :force => true do |t|
    t.integer  "user_id"
    t.string   "oauth_token"
    t.string   "oauth_secret"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
    t.string   "user_type",                                                :null => false
    t.boolean  "approved",                              :default => false, :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["user_type"], :name => "index_users_on_user_type"

end
