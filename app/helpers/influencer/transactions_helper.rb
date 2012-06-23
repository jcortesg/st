module Influencer::TransactionsHelper
  def influencer_attachable_link(attachable)
    return '&nbsp'.html_safe if attachable.nil?
    if attachable.class.to_s == "Tweet"
      link_to("Tweet", [:influencer, attachable])
    end
  end
end
