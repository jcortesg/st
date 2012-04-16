class Transaction < ActiveRecord::Base
  belongs_to :payment_method
  belongs_to :currency
  belongs_to :tweet

  def self.referral_and_influencer_data_for_influencer(influencer_id)
    sql = "SELECT referrals.commission, influencers.lastname, influencers.firstname
             FROM referrals
            INNER JOIN influencers ON referrals.destination_id = influencers.user_id
            WHERE influencers.id = #{influencer_id}"

    @influencer = Influencer.find_by_sql(sql).first
  end

  def self.full_trasactions_for_entity(id, role)
    case role
      when 'administrator'
        @transactions = Tweet.select("tweets.tweet, tweets.date_posted, advertisers.brand, transactions.amount, CASE WHEN transactions.influencer_paid =
        true THEN 'pagada' ELSE 'pendiente de pago' END AS status, transactions.borwin_amount, payment_types.description").joins(:transactions, :advertiser,
                                                                                                                                 :payment_type).order("transactions.influencer_paid")
      when 'affiliate'
        user_id = Affiliate.find_by_id(id).user_id
        @transactions = Tweet.select("tweets.tweet, tweets.date_posted, advertisers.brand, transactions.amount, CASE WHEN transactions.influencer_paid =
        true THEN 'pagada' ELSE 'pendiente de pago' END AS status, transactions.borwin_amount, payment_types.description").joins(:transactions, :advertiser,
                                                                                                                                 :payment_type).where("tweets.influencer_id IN (SELECT influencer_id FROM referrals INNER JOIN influencers ON influencers.user_id =
            referrals.source_id WHERE referrals.destination_id = #{user_id})").order("transactions.influencer_paid")
      when 'advertiser'
        @transactions = Tweet.select("tweets.tweet, tweets.date_posted, advertisers.brand, transactions.amount, CASE WHEN transactions.influencer_paid =
        true THEN 'pagada' ELSE 'pendiente de pago' END AS status, transactions.borwin_amount, payment_types.description").joins(:transactions, :advertiser,
                                                                                                                                 :payment_type).where("tweets.advertiser_id = #{id}").order("transactions.influencer_paid")
      else
        @transactions = Tweet.select("tweets.tweet, tweets.date_posted, advertisers.brand, transactions.amount, CASE WHEN transactions.influencer_paid =
        true THEN 'pagada' ELSE 'pendiente de pago' END AS status, transactions.borwin_amount, payment_types.description").joins(:transactions, :advertiser,
                                                                                                                                 :payment_type).where("tweets.influencer_id = #{id}").order("transactions.influencer_paid")
    end
  end
end