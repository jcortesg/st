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
      when 'expired'
        'Vencido'
    end
  end

  def advertiser_attachable_link(attachable)
    return '&nbsp'.html_safe if attachable.nil?
    if attachable.class.to_s == "Tweet"
      link_to("Tweet", [:advertiser, attachable.campaign, attachable])
    end
  end

  def influencer_kkp(influencer)
    #class .mini-flag.score.kscore
    klout = Audience.where(influencer_id: influencer.influencer_id).first.klout rescue 0
    kred = Audience.where(influencer_id: influencer.influencer_id).first.kred rescue 0
    peerindex = Audience.where(influencer_id: influencer.influencer_id).first.peerindex rescue 0
    kkp = (klout + (kred/10) + peerindex)/3
    sprintf("%.01f", kkp)
  end
end
