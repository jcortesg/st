# encoding: utf-8
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
        'Aceptado'
      when 'activated'
        'Públicado'
    end
  end

  def advertiser_attachable_link(attachable)
    return '&nbsp'.html_safe if attachable.nil?
    if attachable.class.to_s == "Tweet"
      link_to("Tweet", [:advertiser, attachable.campaign, attachable])
    end
  end
end
