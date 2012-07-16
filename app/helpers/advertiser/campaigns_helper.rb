module Advertiser::CampaignsHelper
  def followers_quantity_options
    [["0 a 500", "0 - 500"], ["500 a 2.000", "500 - 2000"], ["2.000 a 10.000", "2000 - 10000"],
     ["10.000 a 100.000", "10000 - 100000"], ["100.000 a 300.000", "100000 - 300000"],
     ["300.000 a 600.000", "300000 - 600000"], ["600.000 a 900.000", "600000 - 900000"],
     ["900.000 a 2.000.000", "900000 - 2000000"]]
  end

  def statistics_tweet_cpc(tweet)
    if tweet.fee_type == 'tweet_fee'
      if tweet.clicks_count > 0
        sprintf("$ %.02f", tweet.tweet_fee / tweet.clicks_count)
      else
        " - "
      end
    else
      sprintf("$ %.02f", self.cpc_fee)
    end
  end

  def statistics_tweet_cpms(tweet)
    tweet_cost = tweet.fee_type == 'tweet_fee' ? tweet.tweet_fee : tweet.cpc_fee * tweet.clicks_count
    sprintf("$ %.02f", tweet_cost * (1000.0 / tweet.influencer.audience.followers))
  end
end
