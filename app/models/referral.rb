class Referral < ActiveRecord::Base
  belongs_to :source, :class_name => "User"
  belongs_to :destination, :class_name => "User"
  
  attr_accessible :destination_id, :source_id, :commission, :since, :through
  
  def self.referrals_list_with_full_details(user)
    if user.admin?
      filter = "IS NOT NULL"
      select = ", (SELECT twitter_username FROM influencers WHERE user_id = t.destination_id) AS destination_twitter_username"
    else
      filter = "= #{user.id}"
    end
    
    sql = "SELECT t.destination_id, t.since, t.through, t.commission, t.email, t.firstname, t.lastname, t.influencer_id, SUM(t.amount) AS amount_paid, 
                  SUM(t.amount_pending) AS amount_pending #{select}
             FROM (SELECT referrals.destination_id, referrals.since, referrals.through, referrals.commission, users.email, influencers.firstname, 
                          influencers.lastname, influencers.id AS influencer_id, CASE WHEN transactions.influencer_paid = true THEN 
                          SUM(transactions.amount * referrals.commission) ELSE 0 END AS amount, CASE WHEN transactions.influencer_paid = false THEN 
                          SUM(transactions.amount * referrals.commission) ELSE 0 END AS amount_pending
                     FROM referrals
                    INNER JOIN users ON users.id = referrals.destination_id
                    INNER JOIN influencers ON influencers.user_id = users.id
                    LEFT JOIN tweets ON tweets.influencer_id = influencers.id
                    LEFT JOIN transactions ON transactions.tweet_id = tweets.id
                    WHERE referrals.source_id #{filter}
                    GROUP BY referrals.destination_id, referrals.since, referrals.through, referrals.commission, users.email, influencers.firstname,
                             influencers.lastname, influencers.id, transactions.influencer_paid) t
            GROUP BY t.destination_id, t.since, t.through, t.commission, t.email, t.firstname, t.lastname, t.influencer_id
            ORDER BY through DESC"
  
    @referrals = Referral.find_by_sql(sql)   
  end
  
  def status
    if self.through >= Date.today
      "activo"
    else
      "finalizado"
    end
  end
end