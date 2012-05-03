module Admin::DashboardHelper
  def img_link_to_twitter(influencer)
    if influencer.twitter_image_url.size > 0
      link_to(image_tag(influencer.twitter_image_url), "https://twitter.com/#!/#{influencer.user.twitter_screen_name}", target: '_blank')
    else
      "&nbsp;"
    end
  end
end
