# encoding: utf-8
namespace :borwin do
  desc 'Updates the influencers twitter data'
  task update_influencer_twitter_data: :environment do
    Influencer.all.each do |influencer|
      next unless influencer.user.twitter_linked?
      influencer.update_audience
    end
    puts "#{Influencer.count} influencer accounts updated"
  end

  desc 'Publish active tweets'
  task public_active_tweets: :environment do
    tweets = Tweet.where("status = 'accepted' and tweet_at > ? and tweet_at < ?", Time.now - 5.minutes, Time.now + 5.minutes).all
    tweets.each do |tweet|
      influencer = tweet.influencer
      Twitter.configure do |config|
        config.consumer_key = TWITTER_CONSUMER_KEY
        config.consumer_secret = TWITTER_CONSUMER_SECRET
        config.oauth_token = influencer.user.twitter_token
        config.oauth_token_secret = influencer.user.twitter_secret
      end
      Twitter.update(tweet.text)
      tweet.activate
    end
  end

  desc 'Generate default keywords'
  task generate_default_keywords: :environment do
    ['males', 'females', 'sports', 'fashion', 'music', 'movies', 'politics', 'technology', 'travel', 'luxury'].each do |keyword_name|
        Keyword.create(name: keyword_name) unless Keyword.where(name: keyword_name).exists?
    end
  end

  desc 'Generate the default countries'
  task generate_default_countries: :environment do
    ['Argentina', 'Colombia', 'Chile', 'Ecuador', 'Paraguay', 'Uruguay'].each do |country_name|
      TwitterCountry.create(name: country_name) unless TwitterCountry.where(name: country_name).exists?
    end
  end

  desc 'Generate the default states'
  task genreate_default_states: :environment do
    argentina = TwitterCountry.where(name: 'Argentina').first
    ['Buenos Aires', 'Catamarca', 'Chaco', 'Córdoba', 'Corrientes', 'Entre Ríos', 'Formosa', 'Jujuy', 'La Pampa',
     'La Rioja', 'Mendoza', 'Misiones', 'Neuquén', 'Rio Negro', 'Salta', 'San Juan', 'San Luis', 'Santa Cruz',
     'Santa Fe', 'Sgo. del Estero', 'Tierra del Fuego', 'Tucumán'].each do |state_name|
      TwitterState.create(name: state_name, twitter_country: argentina) unless TwitterState.where(name: state_name).exists?
    end
  end

  desc 'Updates the list of twitter users and followership relations'
  task update_twitter_users: :environment do
    # Itarate on every influencer, to get who follows him
    Influencer.joins(:audience).includes(:user).order('audiences.followers asc').all.each do |influencer|
      puts "Fetching #{influencer.full_name} followers"
      # First we get the list of all the followers
      cursor = "-1"
      follower_ids = []
      while cursor != 0 do
        followers = Twitter.follower_ids(influencer.user.twitter_screen_name, {cursor: cursor})

        cursor = followers.next_cursor
        follower_ids += followers.ids
        sleep(1)
      end

      puts "Updating #{influencer.full_name} followers on twitter"
      TwitterFollower.delete_all(["influencer_id = ?", influencer.id])

      # Now we create the user if it doesn't exist
      follower_ids.each do |follower_id|
        # Find or create the twitter user
        twitter_user = TwitterUser.where(twitter_uid: follower_id).first || TwitterUser.create(twitter_uid: follower_id)
        twitter_user.influencers << influencer
        twitter_user.save
      end

      puts "Followers for #{influencer.full_name} updated"
    end

    puts "Followers update process done"
  end

  desc 'Fetch screen names for the twitter users'
  task fetch_screen_names: :environment do
    keywords_males = Keyword.where(name: 'males').first.keywords.split(',')
    keywords_females = Keyword.where(name: 'females').first.keywords.split(',')

    TwitterUser.where("twitter_screen_name is null").find_in_batches(batch_size: 100) do |twitter_users|
      puts "Updating a batch of 100 twitter users without screen name"

      # Get the user ids
      twitter_user_ids = twitter_users.collect { |tu| tu.twitter_uid }
      users = Twitter.users(user_id: twitter_user_ids.join(','))
      users.each do |user|
        twitter_user = twitter_users.detect { |tu| tu.twitter_uid.to_i == user.id.to_i }
        twitter_user.twitter_screen_name = user.screen_name
        twitter_user.name = user.name
        twitter_user.location = user.location
        twitter_user.profile_image_url = user.profile_image_url
        twitter_user.followers = user.followers
        twitter_user.friends = user.friends
        twitter_user.tweets = user.statuses_count

        # We check if the user is a male or female
        if keywords_males.detect { |k| twitter_user.name.downcase.include?("#{k} ") || twitter_user.name.downcase == k }
          twitter_user.male = true
        elsif keywords_females.detect { |k| twitter_user.name.downcase.include?("#{k} ") || twitter_user.name.downcase == k }
          twitter_user.female = true
        end

        location = twitter_user.location.to_s.downcase

        # And now check the state
        if (location.match /buenos/) || (location.match(/bs/) && location.match(/as/))
          twitter_user.twitter_state = TwitterState.where(name: 'Buenos Aires').first
        elsif location.match /catamarca/
          twitter_user.twitter_state = TwitterState.where(name: 'Catamarca').first
        elsif location.match /chaco/
          twitter_user.twitter_state = TwitterState.where(name: 'Chaco').first
        elsif location.match(/cordoba/) || location.match(/córdoba/)
          twitter_user.twitter_state = TwitterState.where(name: 'Córdoba').first
        elsif location.match /corrientes/
          twitter_user.twitter_state = TwitterState.where(name: 'Corrientes').first
        elsif location.match(/entre/) && (location.match(/ríos/) || location.match(/rios/))
          twitter_user.twitter_state = TwitterState.where(name: 'Entre Ríos').first
        elsif location.match /formosa/
          twitter_user.twitter_state = TwitterState.where(name: 'Formosa').first
        elsif location.match /jujuy/
          twitter_user.twitter_state = TwitterState.where(name: 'Jujuy').first
        elsif location.match /pampa/
          twitter_user.twitter_state = TwitterState.where(name: 'La Pampa').first
        elsif location.match /rioja/
          twitter_user.twitter_state = TwitterState.where(name: 'La Rioja').first
        elsif location.match /mendoza/
          twitter_user.twitter_state = TwitterState.where(name: 'Mendoza').first
        elsif location.match /misiones/
          twitter_user.twitter_state = TwitterState.where(name: 'Misiones').first
        elsif location.match(/neuquen/)|| location.match(/neuquén/)
          twitter_user.twitter_state = TwitterState.where(name: 'Neuquén').first
        elsif location.match /negro/
          twitter_user.twitter_state = TwitterState.where(name: 'Rio Negro').first
        elsif location.match /salta/
          twitter_user.twitter_state = TwitterState.where(name: 'Salta').first
        elsif location.match(/san/) && location.match(/juan/)
          twitter_user.twitter_state = TwitterState.where(name: 'San Juan').first
        elsif location.match(/san/) && location.match(/luis/)
          twitter_user.twitter_state = TwitterState.where(name: 'San Luis').first
        elsif location.match(/santa/) && location.match(/cruz/)
          twitter_user.twitter_state = TwitterState.where(name: 'Santa Cruz').first
        elsif location.match(/santa/) && location.match(/fe/)
          twitter_user.twitter_state = TwitterState.where(name: 'Santa Fe').first
        elsif location.match(/estero/) && (location.match(/santiago/) || location.match(/sgo/))
          twitter_user.twitter_state = TwitterState.where(name: 'Sgo. del Estero').first
        elsif location.match(/tierra/) && location.match(/fuego/)
          twitter_user.twitter_state = TwitterState.where(name: 'Tierra del Fuego').first
        elsif location.match(/tucumán/) || location.match(/tucuman/)
          twitter_user.twitter_state = TwitterState.where(name: 'Tucumán').first
        end

        # Finally check the country
        if twitter_user.twitter_state || location.match(/argentin/)
          twitter_user.twitter_country = TwitterCountry.where(name: 'Argentina').first
        elsif location.match /colombia/
          twitter_user.twitter_country = TwitterCountry.where(name: 'Colombia').first
        elsif location.match /chile/
          twitter_user.twitter_country = TwitterCountry.where(name: 'Chile').first
        elsif location.match /ecuador/
          twitter_user.twitter_country = TwitterCountry.where(name: 'Ecuador').first
        elsif location.match /paraguay/
          twitter_user.twitter_country = TwitterCountry.where(name: 'Paraguay').first
        elsif location.match /uruguay/
          twitter_user.twitter_country = TwitterCountry.where(name: 'Uruguay').first
        end

        twitter_user.save
      end
    end

    puts "Screen names fetched"
  end

  desc 'Fetch twitter user stats to update the audiences'
  task fetch_twitter_user_stats: :environment do
    # First we get the different keywords
    keywords_sports = Keyword.where(name: 'sports').first.keywords.split(',')
    keywords_fashion = Keyword.where(name: 'fashion').first.keywords.split(',')
    keywords_music = Keyword.where(name: 'music').first.keywords.split(',')
    keywords_movies = Keyword.where(name: 'movies').first.keywords.split(',')
    keywords_politics = Keyword.where(name: 'politics').first.keywords.split(',')
    keywords_technology = Keyword.where(name: 'technology').first.keywords.split(',')
    keywords_travel = Keyword.where(name: 'travel').first.keywords.split(',')
    keywords_luxury = Keyword.where(name: 'luxury').first.keywords.split(',')

    # We setup mechanize to start fetching each one of the user details
    agent = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
      agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
    }

    # Now we fetch all the data for each one of the twitter users
    TwitterUser.where("twitter_screen_name is not null").find_each(batch_size: 10000) do |twitter_user|
      tries = 100
      begin
        page = agent.get("http://mobile.twitter.com/#{twitter_user.twitter_screen_name}")
      rescue Net::HTTPForbidden, Net::HTTPNotFound, Mechanize::ResponseCodeError
        tries = 0
        sleep(1)
        next
      rescue Exception => e
        tries -= 1
        sleep(1)
        retry if tries > 0
      end

      next if page.parser.css('.protected').size > 0

      # First we get the location
      #location = page.parser.css('.location').text
      #twitter_user.location = location if location.to_s.size > 0

      # Get the bio and tweets
      bio = page.parser.css('.bio').text.to_s
      tweets = []
      page.parser.css('.tweet-text').each {|tt| tweets << tt.text}

      # Parse bio and tweets for each one of the keywords
      text_to_parse = bio.to_s + "\n" + tweets.join("\n")
      text_to_parse = text_to_parse.downcase

      # Test category keywords
      twitter_user.sports = true if keywords_sports.detect { |k| text_to_parse.include?("#{k} ") }
      twitter_user.fashion = true if keywords_fashion.detect { |k| text_to_parse.include?("#{k} ") }
      twitter_user.music = true if keywords_music.detect { |k| text_to_parse.include?("#{k} ") }
      twitter_user.movies = true if keywords_movies.detect { |k| text_to_parse.include?("#{k} ") }
      twitter_user.politics = true if keywords_politics.detect { |k| text_to_parse.include?("#{k} ") }
      twitter_user.technology = true if keywords_technology.detect { |k| text_to_parse.include?("#{k} ") }
      twitter_user.travel = true if keywords_travel.detect { |k| text_to_parse.include?("#{k} ") }
      twitter_user.luxury = true if keywords_luxury.detect { |k| text_to_parse.include?("#{k} ") }

      # Update the user
      twitter_user.save
    end
  end

  desc 'Updates audiences'
  task update_audiences: :environment do
    Audience.includes(:influencer).order('audiences.followers asc').all.each do |audience|
      # First we update the gender
      gender_total = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).
        where("(male = 1 and female = 0) or (male = 0 and female = 1)").count
      male = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).
        where("male = 1 and female = 0").count
      percent_males = ((male * 100) / gender_total).round
      percent_females = 100 - percent_males
      audience.males = percent_males
      audience.females = percent_females

      # Now we update the different keyword categories
      followers_total = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).count
      sports = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).where("sports = 1").count
      fashion = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).where("fashion = 1").count
      music = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).where("music = 1").count
      movies = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).where("movies = 1").count
      politics = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).where("politics = 1").count
      technology = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).where("technology = 1").count
      travel = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).where("travel = 1").count
      luxury = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).where("luxury = 1").count

      audience.sports = ((sports * 100) / followers_total).round
      audience.fashion = ((fashion * 100) / followers_total).round
      audience.music = ((music * 100) / followers_total).round
      audience.movies = ((movies * 100) / followers_total).round
      audience.politics = ((politics * 100) / followers_total).round
      audience.technology = ((technology * 100) / followers_total).round
      audience.travel = ((travel * 100) / followers_total).round
      audience.luxury = ((luxury * 100) / followers_total).round

      # Finally update the audiences for countries and states
      country_users = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).where("twitter_country_id is not null").count
      country_argentina = TwitterUser.joins(:twitter_followers, :twitter_country).where("influencer_id = ?", audience.influencer_id).where("twitter_country_id is not null").where("twitter_countries.name = 'Argentina'").count
      country_colombia = TwitterUser.joins(:twitter_followers, :twitter_country).where("influencer_id = ?", audience.influencer_id).where("twitter_country_id is not null").where("twitter_countries.name = 'Colombia'").count
      country_chile = TwitterUser.joins(:twitter_followers, :twitter_country).where("influencer_id = ?", audience.influencer_id).where("twitter_country_id is not null").where("twitter_countries.name = 'Chile'").count
      country_ecuador = TwitterUser.joins(:twitter_followers, :twitter_country).where("influencer_id = ?", audience.influencer_id).where("twitter_country_id is not null").where("twitter_countries.name = 'Ecuador'").count
      country_paraguay = TwitterUser.joins(:twitter_followers, :twitter_country).where("influencer_id = ?", audience.influencer_id).where("twitter_country_id is not null").where("twitter_countries.name = 'Paraguay'").count
      country_uruguay = TwitterUser.joins(:twitter_followers, :twitter_country).where("influencer_id = ?", audience.influencer_id).where("twitter_country_id is not null").where("twitter_countries.name = 'Uruguay'").count

      audience.country_argentina = ((country_argentina * 100) / country_users).round
      audience.country_colombia = ((country_colombia * 100) / country_users).round
      audience.country_chile = ((country_chile * 100) / country_users).round
      audience.country_ecuador = ((country_ecuador * 100) / country_users).round
      audience.country_paraguay = ((country_paraguay * 100) / country_users).round
      audience.country_uruguay = ((country_uruguay * 100) / country_users).round

      states_users = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").count
      state_buenos_aires = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Buenos Aires'").count
      state_catamarca = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Catamarca'").count
      state_chaco = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Chaco'").count
      state_cordoba = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Córdoba'").count
      state_corrientes = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Corrientes'").count
      state_entre_rios = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Entre Ríos'").count
      state_formosa = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Formosa'").count
      state_jujuy = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Jujuy'").count
      state_la_pampa = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'La Pampa'").count
      state_la_rioja = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'La Rioja'").count
      state_mendoza = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Mendoza'").count
      state_misiones = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Misiones'").count
      state_neuquen = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Neuquén'").count
      state_rio_negro = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Rio Negro'").count
      state_salta = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Salta'").count
      state_san_juan = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'San Juan'").count
      state_san_luis = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'San Luis'").count
      state_santa_cruz = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Santa Cruz'").count
      state_santa_fe = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Santa Fe'").count
      state_sgo_del_estero = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Sgo. del Estero'").count
      state_tierra_del_fuego = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Tierra del Fuego'").count
      state_tucuman = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Tucumán'").count

      audience.state_buenos_aires = ((state_buenos_aires * 100) / states_users).round
      audience.state_catamarca = ((state_catamarca * 100) / states_users).round
      audience.state_chaco = ((state_chaco * 100) / states_users).round
      audience.state_cordoba = ((state_cordoba * 100) / states_users).round
      audience.state_corrientes = ((state_corrientes * 100) / states_users).round
      audience.state_entre_rios = ((state_entre_rios * 100) / states_users).round
      audience.state_formosa = ((state_formosa * 100) / states_users).round
      audience.state_jujuy = ((state_jujuy * 100) / states_users).round
      audience.state_la_pampa = ((state_la_pampa * 100) / states_users).round
      audience.state_la_rioja = ((state_la_rioja * 100) / states_users).round
      audience.state_mendoza = ((state_mendoza * 100) / states_users).round
      audience.state_misiones = ((state_misiones * 100) / states_users).round
      audience.state_neuquen = ((state_neuquen * 100) / states_users).round
      audience.state_rio_negro = ((state_rio_negro * 100) / states_users).round
      audience.state_salta = ((state_salta * 100) / states_users).round
      audience.state_san_juan = ((state_san_juan * 100) / states_users).round
      audience.state_san_luis = ((state_san_luis * 100) / states_users).round
      audience.state_santa_cruz = ((state_santa_cruz * 100) / states_users).round
      audience.state_santa_fe = ((state_santa_fe * 100) / states_users).round
      audience.state_sgo_del_estero = ((state_sgo_del_estero * 100) / states_users).round
      audience.state_tierra_del_fuego = ((state_tierra_del_fuego * 100) / states_users).round
      audience.state_tucuman = ((state_tucuman * 100) / states_users).round

      audience.save
    end
  end

  desc "Updates the klout index for each one of the influencers"
  task update_klout: :environment do
    Influencer.includes(:user).order('id').all.each do |influencer|
      puts "Updating klout for #{influencer.full_name}"
      klout_id = Klout::Identity.find_by_screen_name(influencer.user.twitter_screen_name)
      user = Klout::User.new(klout_id.id)
      audience = Audience.where(influencer_id: influencer.id).first
      audience.klout = user.score.score.round
      audience.save
      puts "New Klout index: #{audience.klout}"
    end
  end
end