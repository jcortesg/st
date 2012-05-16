namespace :borwin do
  desc 'Updates the influencers twitter data'
  task update_influencer_twitter_data: :environment do
    Influencer.all.each do |influencer|
      next unless influencer.user.twitter_linked?
      influencer.update_audience
    end
  end
end