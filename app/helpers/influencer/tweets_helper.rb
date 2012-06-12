# encoding: utf-8
module Influencer::TweetsHelper
  def influencer_tweet_status(status)
    case status
      when 'created'
        'Pendiente'
      when 'influencer_reviewed'
        'Revisión del anunciante'
      when 'influencer_rejected'
        'Rechazado'
      when 'advertiser_reviewed'
        'Pendiente'
      when 'advertiser_rejected'
        'Rechazado'
      when 'accepted'
        'Aceptado'
      when 'active'
        'Activo'
    end
  end

  def influencer_tweet_title(status)
    case status
      when 'created'
      when 'influencer_reviewed'
      when 'influencer_rejected'
      when 'advertiser_reviewed'
      when 'advertiser_rejected'
      when 'accepted'
      when 'active'
    end
  end
end
