module Advertiser::TweetsHelper
  def advertiser_tweet_status(status)
    case status
      when 'created'
        'Propuesto'
      when 'influencer_reviewed'
        'Revisado por celebirdad'
      when 'influencer_rejected'
        'Rechazado'
      when 'advertiser_reviewed'
        'Propuesto'
      when 'advertiser_rejected'
        'Rechazado'
      when 'accepted'
        'Activo'
    end
  end
end
