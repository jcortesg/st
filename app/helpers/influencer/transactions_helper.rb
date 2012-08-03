module Influencer::TransactionsHelper
  def influencer_attachable_link(attachable)
    return '&nbsp'.html_safe if attachable.nil?
    if attachable.class.to_s == "Tweet"
      link_to("Tweet", [:influencer, attachable])
    elsif attachable.class.to_s == "CashOut"
      link_to("CashOut", [:influencer, attachable])
    end
  end
end
