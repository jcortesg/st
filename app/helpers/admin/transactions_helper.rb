module Admin::TransactionsHelper
  def admin_attachable_link(attachable)
    return '&nbsp'.html_safe if attachable.nil?
    if attachable.class.to_s == "Tweet"
      link_to("Tweet", [:advertiser, attachable.campaign])
    end
  end
end
