module Admin::DashboardHelper
  def img_link_to_twitter(influencer)
    if influencer.twitter_image_url.size > 0
      link_to(image_tag(influencer.twitter_image_url, height: 48, width: 48), "https://twitter.com/#!/#{influencer.user.twitter_screen_name}", target: '_blank')
    else
      "&nbsp;"
    end
  end

  def img_link_to_user(image_url, screen_name)
    link_to(image_tag(image_url), "https://twitter.com/#!/#{screen_name}", target: '_blank')
  end

  def link_to_twitter_screen_name(screen_name)
    link_to(screen_name, "https://twitter.com/#!/#{screen_name}", target: '_blank')
  end
end
