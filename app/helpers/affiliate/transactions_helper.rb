module Affiliate::TransactionsHelper
  def influencer_attachable_link(attachable)
    return '&nbsp'.html_safe if attachable.nil?
    if attachable.class.to_s == "Tweet"
      link_to("Tweet", [:affiliate, attachable])
    elsif attachable.class.to_s == "CashOut"
      link_to("CashOut", [:affiliate, attachable])
    end
  end
end
