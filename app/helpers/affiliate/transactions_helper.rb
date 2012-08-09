module Affiliate::TransactionsHelper
  def affiliate_attachable_link(attachable)
    return '&nbsp'.html_safe if attachable.nil?
    if attachable.class.to_s == "CashOut"
      link_to("CashOut", [:affiliate, attachable])
    end
  end
end
