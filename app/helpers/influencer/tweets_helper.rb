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
      when 'activated'
        'Públicado'
      when 'expired'
        'Vencido'
    end
  end

end
