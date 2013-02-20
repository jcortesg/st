# encoding: utf-8
namespace :social_target do
  desc 'Updates the influencers twitter data'
  task update_influencer_twitter_data: :environment do
    Influencer.all.each do |influencer|
      next unless influencer.user.twitter_linked?
      influencer.update_audience rescue nil
    end
    puts "#{Influencer.count} influencer accounts updated"
    $stdout.flush
  end

  desc 'Publish active tweets'
  task public_active_tweets: :environment do
    puts "[INFO] Horario de ejecución: " + Time.now.to_s
    $stdout.flush

    tweets = Tweet.where("status = 'accepted' and tweet_at > ? and tweet_at <= ?", Time.now - 5.minutes, Time.now).order('tweet_at asc').all

    tweets.each do |tweet|
      begin
        influencer = tweet.influencer
        puts "[INFO] Tweet por publicar a @" + influencer.user.twitter_screen_name + " - " + tweet.tweet_at.to_s
        $stdout.flush

        publish = true

        #Checks if its a dialog campaign. Need the acceptance of all influencers involved in.
        if tweet.campaign.dialog_campaign
          shared_campaign_tweets = Tweet.where("campaign_id = ?", tweet.campaign_id)
          shared_campaign_tweets.each do |shared_tweet|
            if !(shared_tweet.status == 'accepted' or shared_tweet.status == 'activated')
              publish = false

              puts "Tweet de campaña compartida no listo para lanzarse "+ tweet.text.to_s
              $stdout.flush

              break
            end
          end
        end

        if publish
          Twitter.configure do |config|
            config.consumer_key = TWITTER_CONSUMER_KEY
            config.consumer_secret = TWITTER_CONSUMER_SECRET
            config.oauth_token = influencer.user.twitter_token
            config.oauth_token_secret = influencer.user.twitter_secret
          end
          twitter_tweet = Twitter.update(tweet.text)

          # Update the tweet fields
          if !twitter_tweet.attrs[:id_str].empty?
            tweet.twitter_id = twitter_tweet.attrs[:id_str]
            tweet.twitter_created_at = twitter_tweet.attrs[:created_at]
            tweet.retweet_count = 0
            tweet.status = 'activated'
            puts "[SUCCESS] Publicado en Twitter. ID: " + twitter_tweet.attrs[:id_str]
            $stdout.flush
            if tweet.save
              puts "[SUCCESS] Guardado con éxito"
              $stdout.flush
            else
              puts "[ERROR] El tweet no pudo ser guardado!"
              $stdout.flush
            end
          else
            puts "[ERROR] El tweet no pudo ser publicado!"
            $stdout.flush
          end
        else
          puts "No publicable. "
          $stdout.flush
        end
      rescue Exception => e

        puts "[ERROR] #{e.message}"
        $stdout.flush

        Notifier.error_publishing(tweet)
      end

      begin
        # Now activates the tweet. Internally activates the campaign if needed
        tweet.activate

        # Activate the campaign if needed
        unless tweet.campaign.status == 'active'
          puts "[INFO] La campaña debe ser activada!"
          $stdout.flush

          if (tweet.campaign.activate_campaign rescue nil).nil?
            puts "[ERROR] Error activando campaña"
            $stdout.flush
          end
        end

        # Update campaign reach and share
        if (tweet.campaign.update_reach_and_share rescue nil).nil?
          puts "[ERROR] No se pudo actualizar el Reach & Share de la campaña"
          $stdout.flush
        end

      rescue Exception => e
        puts "[ERROR] #{e.message}"
        $stdout.flush
      end
    end
  end

  desc 'Alert Tweet Expiration in 120 minutes'
  task alert_tweet_expiration: :environment do
    tweets = Tweet.where("status in('created', 'advertiser_reviewed', 'influencer_reviewed') and tweet_at > ? and tweet_at < ?", Time.now + 58.minutes, Time.now + 63.minutes).all
    tweets.each {|t| t.send_expiration_alert(60) }
    tweets = Tweet.where("status in('created', 'advertiser_reviewed', 'influencer_reviewed') and tweet_at > ? and tweet_at < ?", Time.now + 118.minutes, Time.now + 123.minutes).all
    tweets.each {|t| t.send_expiration_alert(120) }
    tweets = Tweet.where("status in('created', 'advertiser_reviewed', 'influencer_reviewed') and tweet_at > ? and tweet_at < ?", Time.now + 178.minutes, Time.now + 183.minutes).all
    tweets.each {|t| t.send_expiration_alert(180) }
  end

  desc 'Expire tweets'
  task expire_tweets: :environment do
    tweets = Tweet.where("status in('created', 'advertiser_reviewed', 'influencer_reviewed') and tweet_at > ? and tweet_at < ?", Time.now - 5.minutes, Time.now + 5.minutes).all
    tweets.each {|t| expire }
  end

  desc 'Generate default keywords'
  task generate_default_keywords: :environment do
    ['males', 'females', 'sports', 'fashion', 'music', 'movies', 'politics', 'technology', 'travel', 'luxury',
     'moms', 'teens', 'college_students', 'young_women', 'young_men', 'adult_women', 'adult_men'].each do |keyword_name|
      Keyword.create(name: keyword_name) unless Keyword.where(name: keyword_name).exists?
    end
  end

  desc 'Generate the default countries'
  task generate_default_countries: :environment do
    ['Argentina', 'Colombia', 'Chile', 'Ecuador', 'Paraguay', 'Uruguay', 'Mexico'].each do |country_name|
      TwitterCountry.create(name: country_name) unless TwitterCountry.where(name: country_name).exists?
    end
  end

  desc 'Generate the default states'
  task generate_default_states: :environment do
    argentina = TwitterCountry.where(name: 'Argentina').first
    ['Buenos Aires', 'Catamarca', 'Chaco', 'Córdoba', 'Corrientes', 'Entre Ríos', 'Formosa', 'Jujuy', 'La Pampa',
     'La Rioja', 'Mendoza', 'Misiones', 'Neuquén', 'Rio Negro', 'Salta', 'San Juan', 'San Luis', 'Santa Cruz',
     'Santa Fe', 'Sgo. del Estero', 'Tierra del Fuego', 'Tucumán'].each do |state_name|
      TwitterState.create(name: state_name, twitter_country: argentina) unless TwitterState.where(name: state_name).exists?
    end

    colombia = TwitterCountry.where(name: 'Colombia').first
    ["Amazonas", "Antioquia", "Arauca", "Atlántico", "Bolívar", "Boyacá", "Caldas", "Caquetá", "Casanare", "Cauca",
     "Cesar", "Chocó", "Córdoba", "Cundinamarca", "Guainía", "Guaviare", "Huila", "La Guajira", "Magdalena", "Meta",
     "Nariño", "Norte de Santander", "Putumayo", "Quindío", "Risaralda", "San Andrés y Providencia", "Santander",
     "Sucre", "Tolima", "Valle del Cauca", "Vaupés", "Vichada", "Colombia"].each do |state_name|
      TwitterState.create(name: state_name, twitter_country: colombia) unless TwitterState.where(name: state_name).exists?
    end

    chile = TwitterCountry.where(name: 'Chile').first
    ["Arica y Parinacota", "Tarapacá", "Antofagasta", "Atacama", "Coquimbo", "Valparaíso", "Santiago", "O'Higgins",
     "Maule", "Biobío", "La Araucanía", "Los Ríos", "Los Lagos", "Aysén", "Magallanes"].each do |state_name|
      TwitterState.create(name: state_name, twitter_country: chile) unless TwitterState.where(name: state_name).exists?
    end

    ecuador = TwitterCountry.where(name: 'Ecuador').first
    ["Azuay", "Bolívar", "Cañar", "Carchi", "Chimborazo", "Cotopaxi", "El Oro", "Esmeraldas", "Galápagos", "Guayas",
     "Imbabura", "Loja", "Los Ríos", "Manabí", "Morona Santiago", "Napo", "Orellana", "Pastaza", "Pichincha",
     "Santa Elena", "Santo Domingo de los Tsáchilas", "Sucumbíos", "Tungurahua", "Zamora Chinchipe"].each do |state_name|
      TwitterState.create(name: state_name, twitter_country: ecuador) unless TwitterState.where(name: state_name).exists?
    end

    mexico = TwitterCountry.where(name: 'Mexico').first
    ["Aguascalientes","Baja California", "Baja California Sur", "Campeche", "Chiapas", "Chihuahua", "Coahuila de Zaragoza",
     "Colima", "Distrito Federal", "Durango", "Guanajuato", "Guerrero", "Hidalgo", "Jalisco", "México",
     "Michoacán de Ocampo", "Morelos", "Nayarit", "Nuevo León", "Oaxaca", "Puebla", "Querétaro", "Quintana Roo",
     "San Luis Potosí", "Sinaloa", "Sonora", "Tabasco", "Tamaulipas", "Tlaxcala", "Veracruz de Ignacio de la Llave",
     "Yucatán", "Zacatecas"].each do |state_name|
      TwitterState.create(name: state_name, twitter_country: mexico) unless TwitterState.where(name: state_name).exists?
    end

    paraguay = TwitterCountry.where(name: 'Paraguay').first
    ["Asunción", "Concepción", "San Pedro", "Cordillera", "Guairá", "Caaguazú", "Caazapá", "Itapúa", "Misiones",
     "Paraguarí", "Alto Paraná", "Central", "Ñeembucú", "Amambay", "Canindeyú", "Presidente Hayes", "Alto Paraguay",
     "Boquerón"].each do |state_name|
      TwitterState.create(name: state_name, twitter_country: paraguay) unless TwitterState.where(name: state_name).exists?
    end

    uruguay = TwitterCountry.where(name: 'Uruguay').first
    ["Artigas", "Canelones", "Cerro Largo", "Colonia", "Durazno", "Flores", "Florida", "Lavalleja", "Maldonado",
     "Montevideo", "Paysandú", "Río Negro", "Rivera", "Rocha", "Salto", "San José", "Soriano", "Tacuarembó",
     "Treinta y Tres"].each do |state_name|
      TwitterState.create(name: state_name, twitter_country: uruguay) unless TwitterState.where(name: state_name).exists?
    end
  end

  desc 'Normalize tweets fee'
  task normalize_tweet_fee: :environment do
    Influencer.all.each do |influencer|
      next unless influencer.campaign_fee == 0.0
      influencer.campaign_fee = influencer.tweet_fee
      unless influencer.manual_tweet_fee.blank?
        influencer.manual_tweet_fee = influencer.manual_tweet_fee / 3
      end
      unless influencer.automatic_tweet_fee.blank?
        influencer.automatic_tweet_fee = influencer.automatic_tweet_fee / 3
      end
      influencer.save
    end
  end

  desc 'Updates the list of twitter users and followership relations'
  task update_twitter_users: :environment do
    # Itarate on every influencer, to get who follows him
    Influencer.joins(:audience).includes(:user).order('audiences.followers asc').all.each do |influencer|
      puts "Fetching #{influencer.full_name} followers"
      $stdout.flush

      # First we get the list of all the followers
      cursor = "-1"
      follower_ids = []
      begin
        while cursor != 0 do
          followers = Twitter.follower_ids(influencer.user.twitter_screen_name, {cursor: cursor})

          cursor = followers.next_cursor
          follower_ids += followers.ids
          sleep(1)
        end
      rescue Exception => e
        puts "There was a problem fetching followers for #{influencer.full_name}: #{e.message}"
        $stdout.flush
      end

      puts "Updating #{influencer.full_name} followers on twitter"
      $stdout.flush

      TwitterFollower.delete_all(["influencer_id = ?", influencer.id])

      # Now we create the user if it doesn't exist
      follower_ids.each do |follower_id|
        # Find or create the twitter user
        twitter_user = TwitterUser.where(twitter_uid: follower_id).first || TwitterUser.create(twitter_uid: follower_id)
        twitter_user.influencers << influencer unless twitter_user.influencers.include?(influencer)
        twitter_user.save
      end

      puts "Followers for #{influencer.full_name} updated"
      $stdout.flush
    end

    puts "Followers update process done"
    $stdout.flush
  end

  desc 'Fetch screen names for the twitter users'
  task fetch_screen_names: :environment do
    keywords_males = Keyword.where(name: 'males').first.keywords.split(',')
    keywords_females = Keyword.where(name: 'females').first.keywords.split(',')

    influencers = User.joins(:influencer => :audience).order("audiences.followers").all
    i = -1
    remaining_calls = 0

    influencer = influencers[0]

    TwitterUser.where("twitter_screen_name is null").find_in_batches(batch_size: 100) do |twitter_users|
      begin
        puts "Cycle begins"
        $stdout.flush

        while(remaining_calls < 10)
          i = i + 1
          i = 0 if i > influencers.size
          influencer = influencers[i]

          puts "Verificando usuario con id: #{influencer.id}"
          $stdout.flush

          begin
            Twitter.configure do |config|
              config.consumer_key = TWITTER_CONSUMER_KEY
              config.consumer_secret = TWITTER_CONSUMER_SECRET
              config.oauth_token = influencer.twitter_token
              config.oauth_token_secret = influencer.twitter_secret
            end
            remaining_calls = 150 # Twitter.rate_limit_status.remaining_hits.to_i
            if remaining_calls > 10
              puts "Usando las credenciales de #{influencer.full_name}, #{remaining_calls} disponibles"
              $stdout.flush
            else
              puts "Credenciales de #{influencer.full_name} no pueden ser usadas: #{remaining_calls} disponibles"
              $stdout.flush
            end
          rescue
            puts "Credenciales de #{influencer.full_name} no pueden ser usadas, la API no autentifica"
            $stdout.flush

            remaining_calls = 0
          end
        end

        puts "Updateando 100 usuarios, credenciales: #{influencer.full_name}, llamadas restantes: #{remaining_calls}"
        $stdout.flush

        # Get the user ids
        twitter_user_ids = twitter_users.collect { |tu| tu.twitter_uid }
        next if twitter_user_ids.blank?
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
            # COLOMBIA
          elsif location.match(/amazonas/)
            twitter_user.twitter_state = TwitterState.where(name: 'Amazonas').first
          elsif location.match(/antioquia/) || location.match(/antioquía/)
            twitter_user.twitter_state = TwitterState.where(name: 'Antioquia').first
          elsif location.match(/atlántico/) || location.match(/atlantico/)
            twitter_user.twitter_state = TwitterState.where(name: 'Atlántico').first
          elsif location.match(/bolívar/) || location.match(/bolivar/)
            twitter_user.twitter_state = TwitterState.where(name: 'Bolívar').first
          elsif location.match(/boyacá/) || location.match(/boyaca/)
            twitter_user.twitter_state = TwitterState.where(name: 'Boyacá').first
          elsif location.match(/caldas/)
            twitter_user.twitter_state = TwitterState.where(name: 'Caldas').first
          elsif location.match(/caquetá/) || location.match(/caqueta/)
            twitter_user.twitter_state = TwitterState.where(name: 'Caquetá').first
          elsif location.match(/casanare/)
            twitter_user.twitter_state = TwitterState.where(name: 'Casanare').first
          elsif location.match(/cauca/)
            twitter_user.twitter_state = TwitterState.where(name: 'Cauca').first
          elsif location.match(/cesar/)
            twitter_user.twitter_state = TwitterState.where(name: 'Cesar').first
          elsif location.match(/chocó/) || location.match(/choco/)
            twitter_user.twitter_state = TwitterState.where(name: 'Chocó').first
          elsif location.match(/córdoba/) || location.match(/cordoba/)
            twitter_user.twitter_state = TwitterState.where(name: 'Córdoba').first
          elsif location.match(/cundinamarca/)
            twitter_user.twitter_state = TwitterState.where(name: 'Cundinamarca').first
          elsif location.match(/guainía/) || location.match(/guainia/)
            twitter_user.twitter_state = TwitterState.where(name: 'Guainía').first
          elsif location.match(/guaviare/)
            twitter_user.twitter_state = TwitterState.where(name: 'Guaviare').first
          elsif location.match(/huila/)
            twitter_user.twitter_state = TwitterState.where(name: 'Huila').first
          elsif location.match(/guajira/)
            twitter_user.twitter_state = TwitterState.where(name: 'La Guajira').first
          elsif location.match(/magdalena/)
            twitter_user.twitter_state = TwitterState.where(name: 'Magdalena').first
          elsif location.match(/meta/)
            twitter_user.twitter_state = TwitterState.where(name: 'Meta').first
          elsif location.match(/nariño/) || location.match(/narino/)
            twitter_user.twitter_state = TwitterState.where(name: 'Nariño').first
          elsif location.match(/norte/) && location.match(/santander/)
            twitter_user.twitter_state = TwitterState.where(name: 'Norte de Santander').first
          elsif location.match(/putumayo/)
            twitter_user.twitter_state = TwitterState.where(name: 'Putumayo').first
          elsif location.match(/quindio/) || location.match(/quindío/)
            twitter_user.twitter_state = TwitterState.where(name: 'Quindío').first
          elsif location.match(/risaralda/)
            twitter_user.twitter_state = TwitterState.where(name: 'Risaralda').first
          elsif ( location.match(/andrés/) || location.match(/andres/)) && location.match(/providencia/)
            twitter_user.twitter_state = TwitterState.where(name: 'San Andrés y Providencia').first
          elsif location.match(/santander/)
            twitter_user.twitter_state = TwitterState.where(name: 'Santander').first
          elsif location.match(/sucre/)
            twitter_user.twitter_state = TwitterState.where(name: 'Sucre').first
          elsif location.match(/tolima/)
            twitter_user.twitter_state = TwitterState.where(name: 'Tolima').first
          elsif location.match(/valle/) && location.match(/cauca/)
            twitter_user.twitter_state = TwitterState.where(name: 'Valle del Cauca').first
          elsif location.match(/vaupes/) || location.match(/vaupés/)
            twitter_user.twitter_state = TwitterState.where(name: 'Vaupés').first
          elsif location.match(/vichada/)
            twitter_user.twitter_state = TwitterState.where(name: 'Vichada').first
          elsif location.match(/colombia/)
            twitter_user.twitter_state = TwitterState.where(name: 'Colombia').first
            # MEXICO
          elsif location.match(/aguascalientes/)
            twitter_user.twitter_state = TwitterState.where(name: 'Aguascalientes').first
          elsif location.match(/baja/) && location.match(/california/) && !location.match(/sur/)
            twitter_user.twitter_state = TwitterState.where(name: 'Baja California').first
          elsif location.match(/baja/) && location.match(/california/) && location.match(/sur/)
            twitter_user.twitter_state = TwitterState.where(name: 'Baja California Sur').first
          elsif location.match(/campeche/)
            twitter_user.twitter_state = TwitterState.where(name: 'Campeche').first
          elsif location.match(/chiapas/)
            twitter_user.twitter_state = TwitterState.where(name: 'Chiapas').first
          elsif location.match(/chihuahua/)
            twitter_user.twitter_state = TwitterState.where(name: 'Chihuahua').first
          elsif location.match(/coahuila/) && location.match(/zaragoza/)
            twitter_user.twitter_state = TwitterState.where(name: 'Coahuila de Zaragoza').first
          elsif location.match(/colima/)
            twitter_user.twitter_state = TwitterState.where(name: 'Colima').first
          elsif (location.match(/distrito/) && location.match(/federal/)) || location.match(/df/)
            twitter_user.twitter_state = TwitterState.where(name: 'Distrito Federal').first
          elsif location.match(/durango/)
            twitter_user.twitter_state = TwitterState.where(name: 'Durango').first
          elsif location.match(/guanajuato/)
            twitter_user.twitter_state = TwitterState.where(name: 'Guanajuato').first
          elsif location.match(/guerrero/)
            twitter_user.twitter_state = TwitterState.where(name: 'Guerrero').first
          elsif location.match(/hidalgo/)
            twitter_user.twitter_state = TwitterState.where(name: 'Hidalgo').first
          elsif location.match(/jalisco/)
            twitter_user.twitter_state = TwitterState.where(name: 'Jalisco').first
          elsif location.match(/mexico/) || location.match(/méxico/)
            twitter_user.twitter_state = TwitterState.where(name: 'México').first
          elsif location.match(/michoacán/) || location.match(/michoacan/)
            twitter_user.twitter_state = TwitterState.where(name: 'Michoacán de Ocampo').first
          elsif location.match(/morelos/)
            twitter_user.twitter_state = TwitterState.where(name: 'Morelos').first
          elsif location.match(/nayarit/)
            twitter_user.twitter_state = TwitterState.where(name: 'Nayarit').first
          elsif location.match(/león/) && location.match(/leon/)
            twitter_user.twitter_state = TwitterState.where(name: 'Nuevo León').first
          elsif location.match(/oaxaca/)
            twitter_user.twitter_state = TwitterState.where(name: 'Oaxaca').first
          elsif location.match(/puebla/)
            twitter_user.twitter_state = TwitterState.where(name: 'Puebla').first
          elsif location.match(/querétaro/) || location.match(/queretaro/)
            twitter_user.twitter_state = TwitterState.where(name: 'Querétaro').first
          elsif location.match(/quitana/) && location.match(/roo/)
            twitter_user.twitter_state = TwitterState.where(name: 'Quintana Roo').first
          elsif location.match(/san/) && location.match(/luis/) && location.match(/potosí/)
            twitter_user.twitter_state = TwitterState.where(name: 'San Luis Potosí').first
          elsif location.match(/sinaloa/)
            twitter_user.twitter_state = TwitterState.where(name: 'Sinaloa').first
          elsif location.match(/sonora/)
            twitter_user.twitter_state = TwitterState.where(name: 'Sonora').first
          elsif location.match(/tabasco/)
            twitter_user.twitter_state = TwitterState.where(name: 'Tabasco').first
          elsif location.match(/tamaulipas/)
            twitter_user.twitter_state = TwitterState.where(name: 'Tamaulipas').first
          elsif location.match(/tlaxcala/)
            twitter_user.twitter_state = TwitterState.where(name: 'Tlaxcala').first
          elsif location.match(/veracruz/)
            twitter_user.twitter_state = TwitterState.where(name: 'Veracruz de Ignacio de la Llave').first
          elsif location.match(/yucatán/) || location.match(/yucatan/)
            twitter_user.twitter_state = TwitterState.where(name: 'Yucatán').first
          elsif location.match(/zacatecas/)
            twitter_user.twitter_state = TwitterState.where(name: 'Zacatecas').first
            #CHILE
          elsif location.match(/arica/) || location.match(/parinacota/)
            twitter_user.twitter_state = TwitterState.where(name: 'Arica y Parinacota').first
          elsif location.match(/tarapacá/) || location.match(/tarapaca/)
            twitter_user.twitter_state = TwitterState.where(name: 'Tarapacá').first
          elsif location.match(/antofagasta/)
            twitter_user.twitter_state = TwitterState.where(name: 'Antofagasta').first
          elsif location.match(/atacama/)
            twitter_user.twitter_state = TwitterState.where(name: 'Atacama').first
          elsif location.match(/coquimbo/)
            twitter_user.twitter_state = TwitterState.where(name: 'Coquimbo').first
          elsif location.match(/valparaíso/) || location.match(/valparaiso/)
            twitter_user.twitter_state = TwitterState.where(name: 'Valparaíso').first
          elsif location.match(/santiago/)
            twitter_user.twitter_state = TwitterState.where(name: 'Santiago').first
          elsif location.match(/o'higgins/)
            twitter_user.twitter_state = TwitterState.where(name: "O'Higgins").first
          elsif location.match(/maule/)
            twitter_user.twitter_state = TwitterState.where(name: "Maule").first
          elsif location.match(/biobío/) || location.match(/biobio/)
            twitter_user.twitter_state = TwitterState.where(name: 'Biobío').first
          elsif location.match(/araucanía/) || location.match(/araucania/)
            twitter_user.twitter_state = TwitterState.where(name: 'La Araucanía').first
          elsif location.match(/ríos/) || location.match(/rios/)
            twitter_user.twitter_state = TwitterState.where(name: 'Los Ríos').first
          elsif location.match(/lagos/)
            twitter_user.twitter_state = TwitterState.where(name: 'Los Lagos').first
          elsif location.match(/aysén/) || location.match(/aysen/)
            twitter_user.twitter_state = TwitterState.where(name: 'Aysén').first
          elsif location.match(/magallanes/)
            twitter_user.twitter_state = TwitterState.where(name: 'Magallanes').first
            #ECUADOR
          elsif location.match(/azuay/)
            twitter_user.twitter_state = TwitterState.where(name: 'Azuay').first
          elsif location.match(/bolívar/) || location.match(/bolivar/)
            twitter_user.twitter_state = TwitterState.where(name: 'Bolívar').first
          elsif location.match(/cañar/) || location.match(/canar/)
            twitter_user.twitter_state = TwitterState.where(name: 'Cañar').first
          elsif location.match(/carchi/)
            twitter_user.twitter_state = TwitterState.where(name: 'Carchi').first
          elsif location.match(/chimborazo/)
            twitter_user.twitter_state = TwitterState.where(name: 'Chimborazo').first
          elsif location.match(/cotopaxi/)
            twitter_user.twitter_state = TwitterState.where(name: 'Cotopaxi').first
          elsif location.match(/oro/)
            twitter_user.twitter_state = TwitterState.where(name: 'El Oro').first
          elsif location.match(/esmeraldas/)
            twitter_user.twitter_state = TwitterState.where(name: 'Esmeraldas').first
          elsif location.match(/galápagos/) || location.match(/galapagos/)
            twitter_user.twitter_state = TwitterState.where(name: 'Galápagos').first
          elsif location.match(/guayas/)
            twitter_user.twitter_state = TwitterState.where(name: 'Guayas').first
          elsif location.match(/imbabura/)
            twitter_user.twitter_state = TwitterState.where(name: 'Imbabura').first
          elsif location.match(/loja/)
            twitter_user.twitter_state = TwitterState.where(name: 'Loja').first
          elsif location.match(/los/) && (location.match(/rios/) || location.match(/ríos/))
            twitter_user.twitter_state = TwitterState.where(name: 'Los Ríos').first
          elsif location.match(/manabi/) || location.match(/manabí/)
            twitter_user.twitter_state = TwitterState.where(name: 'Manabí').first
          elsif location.match(/morona/) && location.match(/santiago/)
            twitter_user.twitter_state = TwitterState.where(name: 'Morona Santiago').first
          elsif location.match(/napo/)
            twitter_user.twitter_state = TwitterState.where(name: 'Napo').first
          elsif location.match(/orellana/)
            twitter_user.twitter_state = TwitterState.where(name: 'Orellana').first
          elsif location.match(/pastaza/)
            twitter_user.twitter_state = TwitterState.where(name: 'Pastaza').first
          elsif location.match(/pichincha/)
            twitter_user.twitter_state = TwitterState.where(name: 'Pichincha').first
          elsif location.match(/santa/) && location.match(/elena/)
            twitter_user.twitter_state = TwitterState.where(name: 'Santa Elena').first
          elsif (location.match(/santo/) && location.match(/domingo/)) || (location.match(/tsáchilas/) || location.match(/tsachilas/))
            twitter_user.twitter_state = TwitterState.where(name: 'Santo Domingo de los Tsáchilas').first
          elsif location.match(/sucumbios/) || location.match(/sucumbíos/)
            twitter_user.twitter_state = TwitterState.where(name: 'Sucumbíos').first
          elsif location.match(/tungurahua/)
            twitter_user.twitter_state = TwitterState.where(name: 'Tungurahua').first
          elsif location.match(/zamora/) && location.match(/chinchipe/)
            twitter_user.twitter_state = TwitterState.where(name: 'Zamora Chinchipe').first
            #PARAGUAY
          elsif location.match(/asuncion/) || location.match(/asunción/)
            twitter_user.twitter_state = TwitterState.where(name: 'Asunción').first
          elsif location.match(/concepción/) || location.match(/concepcion/)
            twitter_user.twitter_state = TwitterState.where(name: 'Concepción').first
          elsif location.match(/san/) && location.match(/pedro/)
            twitter_user.twitter_state = TwitterState.where(name: 'San Pedro').first
          elsif location.match(/cordillera/)
            twitter_user.twitter_state = TwitterState.where(name: 'Cordillera').first
          elsif location.match(/guairá/) || location.match(/guaira/)
            twitter_user.twitter_state = TwitterState.where(name: 'Guairá').first
          elsif location.match(/caaguazú/) || location.match(/caaguazu/)
            twitter_user.twitter_state = TwitterState.where(name: 'Caaguazú').first
          elsif location.match(/caazapá/) || location.match(/caazapa/)
            twitter_user.twitter_state = TwitterState.where(name: 'Caaguazú').first
          elsif location.match(/itapua/) || location.match(/itapúa/)
            twitter_user.twitter_state = TwitterState.where(name: 'Itapúa').first
          elsif location.match(/misiones/)
            twitter_user.twitter_state = TwitterState.where(name: 'Misiones').first
          elsif location.match(/paraguari/) || location.match(/paraguarí/)
            twitter_user.twitter_state = TwitterState.where(name: 'Paraguarí').first
          elsif location.match(/alto/) && ( location.match(/paraná/) || location.match(/parana/))
            twitter_user.twitter_state = TwitterState.where(name: 'Alto Paraná').first
          elsif location.match(/central/)
            twitter_user.twitter_state = TwitterState.where(name: 'Central').first
          elsif location.match(/ñeembucú/) || location.match(/neembucu/)
            twitter_user.twitter_state = TwitterState.where(name: 'Ñeembucú').first
          elsif location.match(/amambay/)
            twitter_user.twitter_state = TwitterState.where(name: 'Amambay').first
          elsif location.match(/canindeyú/) || location.match(/canindeyu/)
            twitter_user.twitter_state = TwitterState.where(name: 'Canindeyú').first
          elsif location.match(/presidente/) && location.match(/hayes/)
            twitter_user.twitter_state = TwitterState.where(name: 'Presidente Hayes').first
          elsif location.match(/alto/) && location.match(/paraguay/)
            twitter_user.twitter_state = TwitterState.where(name: 'Alto Paraguay').first
          elsif location.match(/boquerón/) || location.match(/boqueron/)
            twitter_user.twitter_state = TwitterState.where(name: 'Boquerón').first
            #URUGUAY
          elsif location.match(/artigas/)
            twitter_user.twitter_state = TwitterState.where(name: 'Artigas').first
          elsif location.match(/canelones/)
            twitter_user.twitter_state = TwitterState.where(name: 'Canelones').first
          elsif location.match(/cerro/) && location.match(/largo/)
            twitter_user.twitter_state = TwitterState.where(name: 'Cerro Largo').first
          elsif location.match(/colonia/)
            twitter_user.twitter_state = TwitterState.where(name: 'Colonia').first
          elsif location.match(/durazno/)
            twitter_user.twitter_state = TwitterState.where(name: 'Durazno').first
          elsif location.match(/flores/)
            twitter_user.twitter_state = TwitterState.where(name: 'Flores').first
          elsif location.match(/florida/)
            twitter_user.twitter_state = TwitterState.where(name: 'Florida').first
          elsif location.match(/lavalleja/)
            twitter_user.twitter_state = TwitterState.where(name: 'Lavalleja').first
          elsif location.match(/maldonado/)
            twitter_user.twitter_state = TwitterState.where(name: 'Maldonado').first
          elsif location.match(/montevideo/)
            twitter_user.twitter_state = TwitterState.where(name: 'Montevideo').first
          elsif location.match(/paysandú/) || location.match(/paysandu/)
            twitter_user.twitter_state = TwitterState.where(name: 'Paysandú').first
          elsif location.match(/río/) && location.match(/negro/)
            twitter_user.twitter_state = TwitterState.where(name: 'Río Negro').first
          elsif location.match(/rivera/)
            twitter_user.twitter_state = TwitterState.where(name: 'Rivera').first
          elsif location.match(/rocha/)
            twitter_user.twitter_state = TwitterState.where(name: 'Rocha').first
          elsif location.match(/salto/)
            twitter_user.twitter_state = TwitterState.where(name: 'Salto').first
          elsif location.match(/san/) && (location.match(/jose/) || location.match(/josé/))
            twitter_user.twitter_state = TwitterState.where(name: 'San José').first
          elsif location.match(/soriano/)
            twitter_user.twitter_state = TwitterState.where(name: 'Soriano').first
          elsif location.match(/tacuarembo/) || location.match(/tacuarembó/)
            twitter_user.twitter_state = TwitterState.where(name: 'Tacuarembó').first
          elsif (location.match(/treinta/) && location.match(/tres/))  || location.match(/33/)
            twitter_user.twitter_state = TwitterState.where(name: 'Treinta y Tres').first
          end

          # Finally check the country
          if (!twitter_user.twitter_state.nil? && ["Buenos Aires",  "Catamarca",  "Chaco", "Córdoba", "Corrientes", "Entre Ríos", "Formosa", "Jujuy", "La Pampa", "La Rioja", "Mendoza", "Misiones", "Neuquén", "Rio Negro", "Salta", "San Juan", "San Luis", "Santa Cruz", "Santa Fe", "Sgo. del Estero", "Tierra del Fuego", "Tucumán"].contains(twitter_user.twitter_state.name)) || location.match(/argentin/)
            twitter_user.twitter_country = TwitterCountry.where(name: 'Argentina').first
          elsif (!twitter_user.twitter_state.nil? && ["Amazonas", "Antioquia", "Arauca", "Atlántico", "Bolívar", "Boyacá", "Caldas", "Caquetá", "Casanare", "Cauca", "Cesar", "Chocó", "Córdoba", "Cundinamarca", "Guainía", "Guaviare", "Huila", "La Guajira", "Magdalena", "Meta", "Nariño", "Norte de Santander", "Putumayo", "Quindío", "Risaralda", "San Andrés y Providencia", "Santander", "Sucre", "Tolima", "Valle del Cauca", "Vaupés", "Vichada", "Colombia"].contains(twitter_user.twitter_state.name)) || (location.match /colombia/)
            twitter_user.twitter_country = TwitterCountry.where(name: 'Colombia').first
          elsif (!twitter_user.twitter_state.nil? && ["Arica y Parinacota", "Tarapacá", "Antofagasta", "Atacama", "Coquimbo", "Valparaíso", "Santiago", "O'Higgins", "Maule", "Biobío", "La Araucanía", "Los Ríos", "Los Lagos", "Aysén", "Magallanes"].contains(twitter_user.twitter_state.name)) || (location.match /chile/)
            twitter_user.twitter_country = TwitterCountry.where(name: 'Chile').first
          elsif (!twitter_user.twitter_state.nil? && ["Azuay", "Bolívar", "Cañar", "Carchi", "Chimborazo", "Cotopaxi", "El Oro", "Esmeraldas", "Galápagos", "Guayas", "Imbabura", "Loja", "Los Ríos", "Manabí", "Morona Santiago", "Napo", "Orellana", "Pastaza", "Pichincha", "Santa Elena", "Santo Domingo de los Tsáchilas", "Sucumbíos", "Tungurahua", "Zamora Chinchipe"].contains(twitter_user.twitter_state.name)) || (location.match /ecuador/)
            twitter_user.twitter_country = TwitterCountry.where(name: 'Ecuador').first
          elsif (!twitter_user.twitter_state.nil? && ["Asunción", "Concepción", "San Pedro", "Cordillera", "Guairá", "Caaguazú", "Caazapá", "Itapúa", "Misiones", "Paraguarí", "Alto Paraná", "Central", "Ñeembucú", "Amambay", "Canindeyú", "Presidente Hayes", "Alto Paraguay", "Boquerón"].contains(twitter_user.twitter_state.name)) || (location.match /paraguay/)
            twitter_user.twitter_country = TwitterCountry.where(name: 'Paraguay').first
          elsif (!twitter_user.twitter_state.nil? && ["Artigas", "Canelones", "Cerro Largo", "Colonia", "Durazno", "Flores", "Florida", "Lavalleja", "Maldonado", "Montevideo", "Paysandú", "Río Negro", "Rivera", "Rocha", "Salto", "San José", "Soriano", "Tacuarembó", "Treinta y Tres"].contains(twitter_user.twitter_state.name)) || (location.match /uruguay/)
            twitter_user.twitter_country = TwitterCountry.where(name: 'Uruguay').first
          elsif (!twitter_user.twitter_state.nil? && ["Aguascalientes","Baja California", "Baja California Sur", "Campeche", "Chiapas", "Chihuahua", "Coahuila de Zaragoza", "Colima", "Distrito Federal", "Durango", "Guanajuato", "Guerrero", "Hidalgo", "Jalisco", "México", "Michoacán de Ocampo", "Morelos", "Nayarit", "Nuevo León", "Oaxaca", "Puebla", "Querétaro", "Quintana Roo", "San Luis Potosí", "Sinaloa", "Sonora", "Tabasco", "Tamaulipas", "Tlaxcala", "Veracruz de Ignacio de la Llave", "Yucatán", "Zacatecas"].contains(twitter_user.twitter_state.name)) || (location.match /mexico/)
            twitter_user.twitter_country = TwitterCountry.where(name: 'Mexico').first
          end

          #puts twitter_user.location.to_s + " => " + ((!twitter_user.twitter_country.nil?)? twitter_user.twitter_country.name.to_s : " " )+ " "+  ((!twitter_user.twitter_state.nil?)? twitter_user.twitter_state.name.to_s : " ")

          twitter_user.save
        end
      rescue Exception => e
        if twitter_user_ids && twitter_user_ids.respond_to?(:join)
          puts "There was a problem fetching the twitter user ids: #{twitter_user_ids.join(',')}: #{e.message}"
          $stdout.flush
        else
          puts "There was a problem fetching the twitter user ids that cannot be join: #{twitter_user_ids}: #{e.message}"
          $stdout.flush
        end
      ensure
        remaining_calls = remaining_calls - 1
      end
    end

    puts "Screen names fetched"
    $stdout.flush
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
    keywords_moms = Keyword.where(name: 'moms').first.keywords.split(',')
    keywords_teens = Keyword.where(name: 'teens').first.keywords.split(',')
    keywords_college_students = Keyword.where(name: 'college_students').first.keywords.split(',')
    keywords_young_women = Keyword.where(name: 'young_women').first.keywords.split(',')
    keywords_young_men = Keyword.where(name: 'young_men').first.keywords.split(',')
    keywords_adult_women = Keyword.where(name: 'adult_women').first.keywords.split(',')
    keywords_adult_men = Keyword.where(name: 'adult_men').first.keywords.split(',')


    # We setup mechanize to start fetching each one of the user details
    agent = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
      agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
    }

    # Now we fetch all the data for each one of the twitter users
    TwitterUser.where("twitter_screen_name is not null and last_sync_at is null and invalid_page is false and private_tweets is false").find_each(batch_size: 10000) do |twitter_user|
      puts "Updateando #{twitter_user.twitter_screen_name}"
      $stdout.flush

      tries = 100
      begin
        page = agent.get("http://mobile.twitter.com/#{twitter_user.twitter_screen_name}")
      rescue Net::HTTPForbidden, Net::HTTPNotFound, Mechanize::ResponseCodeError
        puts "No se encuentra la pagina"
        $stdout.flush
        twitter_user.invalid_page = true
        twitter_user.save
        tries = 0
        sleep(1)
        next
      rescue Exception => e
        tries -= 1
        sleep(1)
        retry if tries > 0
      end

      if page.parser.css('.protected').size > 0
        puts "Los tweets del usuario estan protegidos"
        $stdout.flush
        twitter_user.private_tweets = true
        twitter_user.save
        next
      end

      puts "Datos encontrados, parseando y guardando"
      $stdout.flush

      # First we get the location
      #location = page.parser.css('.location').text
      #twitter_user.location = location if location.to_s.size > 0

      # Get the bio and tweets
      bio = page.parser.css('.bio').text.to_s
      tweets = []
      page.parser.css('.tweet-text').each { |tt| tweets << tt.text }

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
      twitter_user.moms = true if keywords_moms.detect {|k| text_to_parse.include?("#{k} ")}
      twitter_user.teens = true if keywords_teens.detect {|k| text_to_parse.include?("#{k} ")}
      twitter_user.college_students = true if keywords_college_students.detect {|k| text_to_parse.include?("#{k} ")}
      twitter_user.young_women = true if keywords_young_women.detect {|k| text_to_parse.include?("#{k} ")}
      twitter_user.young_men = true if keywords_young_men.detect {|k| text_to_parse.include?("#{k}" )}
      twitter_user.adult_women = true if keywords_adult_women.detect {|k| text_to_parse.include?("#{k} ")}
      twitter_user.adult_men = true if keywords_adult_men.detect {|k| text_to_parse.include?("#{k}" )}

      twitter_user.last_sync_at = Time.now

      # Update the user
      twitter_user.save
    end
  end

  desc 'Fetch screen names for the twitter users'
  task fetch_twitter_user_stats_2: :environment do

    # First we get the different keywords
    keywords_sports = Keyword.where(name: 'sports').first.keywords.split(',')
    keywords_fashion = Keyword.where(name: 'fashion').first.keywords.split(',')
    keywords_music = Keyword.where(name: 'music').first.keywords.split(',')
    keywords_movies = Keyword.where(name: 'movies').first.keywords.split(',')
    keywords_politics = Keyword.where(name: 'politics').first.keywords.split(',')
    keywords_technology = Keyword.where(name: 'technology').first.keywords.split(',')
    keywords_travel = Keyword.where(name: 'travel').first.keywords.split(',')
    keywords_luxury = Keyword.where(name: 'luxury').first.keywords.split(',')
    keywords_moms = Keyword.where(name: 'moms').first.keywords.split(',')
    keywords_teens = Keyword.where(name: 'teens').first.keywords.split(',')
    keywords_college_students = Keyword.where(name: 'college_students').first.keywords.split(',')
    keywords_young_women = Keyword.where(name: 'young_women').first.keywords.split(',')
    keywords_young_men = Keyword.where(name: 'young_men').first.keywords.split(',')
    keywords_adult_women = Keyword.where(name: 'adult_women').first.keywords.split(',')
    keywords_adult_men = Keyword.where(name: 'adult_men').first.keywords.split(',')

    influencers = User.joins(:influencer => :audience).order("audiences.followers").all
    i = -1
    remaining_calls = 0

    influencer = influencers[0]

    TwitterUser.where("last_sync_at is null and twitter_screen_name is not null and private_tweets is false").find_each do |twitter_user|
      begin
        while(remaining_calls < 10)
          i = i + 1
          i = 0 if i > influencers.size
          influencer = influencers[i]
          puts "Verificando usuario con id: #{influencer.id}"
          $stdout.flush
          begin
            Twitter.configure do |config|
              config.consumer_key = TWITTER_CONSUMER_KEY
              config.consumer_secret = TWITTER_CONSUMER_SECRET
              config.oauth_token = influencer.twitter_token
              config.oauth_token_secret = influencer.twitter_secret
            end
            remaining_calls = 150 # Twitter.rate_limit_status.remaining_hits.to_i
            if remaining_calls > 10
              puts "Usando las credenciales de #{influencer.full_name}, #{remaining_calls} disponibles"
              $stdout.flush
            else
              puts "Credenciales de #{influencer.full_name} no pueden ser usadas: #{remaining_calls} disponibles"
              $stdout.flush
            end
          rescue
            puts "Credenciales de #{influencer.full_name} no pueden ser usadas, la API no autentifica"
            $stdout.flush
            remaining_calls = 0
          end
        end

        puts "Updating Twitter User #{twitter_user.id}, screen_name: #{twitter_user.twitter_screen_name}"
        $stdout.flush

        begin
          time_line = Twitter.user_timeline(twitter_user.twitter_screen_name)
          text_to_parse = time_line.collect {|t| t.text}.join(' ').downcase
        rescue Twitter::Error::Unauthorized
          # Tweets are privated
          twitter_user.private_tweets = true
          twitter_user.save(validate: false)
          puts "Private tweets"
          $stdout.flush
          next
        rescue Exception
          # User doesn't exist
          twitter_user.invalid_page = true
          twitter_user.save(validate: false)
          puts "Doesn't exist"
          $stdout.flush
          next
        end

        # Test category keywords
        twitter_user.sports = true if keywords_sports.detect { |k| text_to_parse.include?("#{k} ") }
        twitter_user.fashion = true if keywords_fashion.detect { |k| text_to_parse.include?("#{k} ") }
        twitter_user.music = true if keywords_music.detect { |k| text_to_parse.include?("#{k} ") }
        twitter_user.movies = true if keywords_movies.detect { |k| text_to_parse.include?("#{k} ") }
        twitter_user.politics = true if keywords_politics.detect { |k| text_to_parse.include?("#{k} ") }
        twitter_user.technology = true if keywords_technology.detect { |k| text_to_parse.include?("#{k} ") }
        twitter_user.travel = true if keywords_travel.detect { |k| text_to_parse.include?("#{k} ") }
        twitter_user.luxury = true if keywords_luxury.detect { |k| text_to_parse.include?("#{k} ") }
        twitter_user.moms = true if keywords_moms.detect {|k| text_to_parse.include?("#{k} ")}
        twitter_user.teens = true if keywords_teens.detect {|k| text_to_parse.include?("#{k} ")}
        twitter_user.college_students = true if keywords_college_students.detect {|k| text_to_parse.include?("#{k} ")}
        twitter_user.young_women = true if keywords_young_women.detect {|k| text_to_parse.include?("#{k} ")}
        twitter_user.young_men = true if keywords_young_men.detect {|k| text_to_parse.include?("#{k}" )}
        twitter_user.adult_women = true if keywords_adult_women.detect {|k| text_to_parse.include?("#{k} ")}
        twitter_user.adult_men = true if keywords_adult_men.detect {|k| text_to_parse.include?("#{k}" )}

        twitter_user.last_sync_at = Time.now

        puts "Updated"
        $stdout.flush

        # Update the user
        twitter_user.save


      rescue Exception => e
        if twitter_user && !twitter_user.id.blank?
          puts "There was a problem fetching the stats for: #{twitter_user.id}: #{e.message}"
          $stdout.flush
        else
          puts "There was a problem fetching the stats: #{e.message}"
          $stdout.flush
        end
      ensure
        remaining_calls = remaining_calls - 1
      end
    end

    puts "Twitter User Stats fetched"
    $stdout.flush
  end

  desc 'Updates geographical and male/female audiences, set UPDATE_HOBBIES environment to update the hobbies as well'
  task update_audiences: :environment do
    Audience.includes(:influencer).order('audiences.followers asc').all.each do |audience|
      # First we update the gender
      gender_total = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).
        where("(male = 1 and female = 0) or (male = 0 and female = 1)").count
      male = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).
        where("male = 1 and female = 0").count
      percent_males = (((male * 100) / gender_total).round rescue 0)
      percent_females = 100 - percent_males
      audience.males = percent_males
      audience.females = percent_females

      # Now we update the different keyword categories
      followers_total = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).where("last_sync_at is not null").count
      if (ENV['UPDATE_HOBBIES'])
        sports = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).where("sports = 1").count
        fashion = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).where("fashion = 1").count
        music = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).where("music = 1").count
        movies = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).where("movies = 1").count
        politics = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).where("politics = 1").count
        technology = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).where("technology = 1").count
        travel = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).where("travel = 1").count
        luxury = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).where("luxury = 1").count
        moms = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).where("moms = 1").count
        teens = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).where("teens = 1").count
        college_students = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).where("college_students = 1").count
        young_women = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).where("young_women = 1").count
        young_men = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).where("young_men = 1").count
        adult_women = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).where("adult_women = 1").count
        adult_men = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).where("adult_men = 1").count
      end

      audience.males_count = male
      audience.females_count = gender_total - male

      if (ENV['UPDATE_HOBBIES'])
        audience.sports_count = sports
        audience.fashion_count = fashion
        audience.music_count = music
        audience.movies_count = movies
        audience.politics_count = politics
        audience.technology_count = technology
        audience.travel_count = travel
        audience.luxury_count = luxury
        audience.moms_count = moms
        audience.teens_count = teens
        audience.college_students_count = college_students
        audience.young_women_count = young_women
        audience.young_men_count = young_men
        audience.adult_women_count = adult_women
        audience.adult_men_count = adult_men


        audience.sports = ((sports * 100) / followers_total).round rescue 0
        audience.fashion = ((fashion * 100) / followers_total).round rescue 0
        audience.music = ((music * 100) / followers_total).round rescue 0
        audience.movies = ((movies * 100) / followers_total).round rescue 0
        audience.politics = ((politics * 100) / followers_total).round rescue 0
        audience.technology = ((technology * 100) / followers_total).round rescue 0
        audience.travel = ((travel * 100) / followers_total).round rescue 0
        audience.luxury = ((luxury * 100) / followers_total).round rescue 0
        audience.moms = ((moms * 100) / followers_total).round rescue 0
        audience.teens = ((teens * 100) / followers_total).round rescue 0


        age_percent = audience.college_students_count + audience.young_women_count +
          audience.young_men_count + audience.adult_women_count + audience.adult_men_count

        audience.college_students = ((college_students * 100) / age_percent).round rescue 0
        audience.young_women = ((young_women * 100) / age_percent).round rescue 0
        audience.young_men = ((young_men * 100) / age_percent).round rescue 0
        audience.adult_women = ((adult_women * 100) / age_percent).round rescue 0
        audience.adult_men = ((adult_men * 100) / age_percent).round rescue 0
      end

      # Finally update the audiences for countries and states
      country_users = TwitterUser.joins(:twitter_followers).where("influencer_id = ?", audience.influencer_id).where("twitter_country_id is not null").count
      country_argentina = TwitterUser.joins(:twitter_followers, :twitter_country).where("influencer_id = ?", audience.influencer_id).where("twitter_country_id is not null").where("twitter_countries.name = 'Argentina'").count
      country_colombia = TwitterUser.joins(:twitter_followers, :twitter_country).where("influencer_id = ?", audience.influencer_id).where("twitter_country_id is not null").where("twitter_countries.name = 'Colombia'").count
      country_chile = TwitterUser.joins(:twitter_followers, :twitter_country).where("influencer_id = ?", audience.influencer_id).where("twitter_country_id is not null").where("twitter_countries.name = 'Chile'").count
      country_ecuador = TwitterUser.joins(:twitter_followers, :twitter_country).where("influencer_id = ?", audience.influencer_id).where("twitter_country_id is not null").where("twitter_countries.name = 'Ecuador'").count
      country_mexico = TwitterUser.joins(:twitter_followers, :twitter_country).where("influencer_id = ?", audience.influencer_id).where("twitter_country_id is not null").where("twitter_countries.name = 'Mexico'").count
      country_paraguay = TwitterUser.joins(:twitter_followers, :twitter_country).where("influencer_id = ?", audience.influencer_id).where("twitter_country_id is not null").where("twitter_countries.name = 'Paraguay'").count
      country_uruguay = TwitterUser.joins(:twitter_followers, :twitter_country).where("influencer_id = ?", audience.influencer_id).where("twitter_country_id is not null").where("twitter_countries.name = 'Uruguay'").count

      puts "Countries"
      $stdout.flush
      audience.country_argentina = ((country_argentina * 100) / country_users).round rescue 0
      audience.country_colombia = ((country_colombia * 100) / country_users).round rescue 0
      audience.country_chile = ((country_chile * 100) / country_users).round rescue 0
      audience.country_ecuador = ((country_ecuador * 100) / country_users).round rescue 0
      audience.country_mexico = ((country_mexico * 100) / country_users).round rescue 0
      audience.country_paraguay = ((country_paraguay * 100) / country_users).round rescue 0
      audience.country_uruguay = ((country_uruguay * 100) / country_users).round rescue 0

      #states Argentina
      puts "Argentina..."
      $stdout.flush
      states_users = TwitterUser.joins(:twitter_followers, :twitter_country).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_countries.name = 'Argentina'").count
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

      audience.state_buenos_aires = (((state_buenos_aires * 100) / states_users).round rescue 0)
      audience.state_catamarca = (((state_catamarca * 100) / states_users).round rescue 0)
      audience.state_chaco = (((state_chaco * 100) / states_users).round rescue 0)
      audience.state_cordoba = (((state_cordoba * 100) / states_users).round rescue 0)
      audience.state_corrientes = (((state_corrientes * 100) / states_users).round rescue 0)
      audience.state_entre_rios = (((state_entre_rios * 100) / states_users).round rescue 0)
      audience.state_formosa = (((state_formosa * 100) / states_users).round rescue 0)
      audience.state_jujuy = (((state_jujuy * 100) / states_users).round rescue 0)
      audience.state_la_pampa = (((state_la_pampa * 100) / states_users).round rescue 0)
      audience.state_la_rioja = (((state_la_rioja * 100) / states_users).round rescue 0)
      audience.state_mendoza = (((state_mendoza * 100) / states_users).round rescue 0)
      audience.state_misiones = (((state_misiones * 100) / states_users).round rescue 0)
      audience.state_neuquen = (((state_neuquen * 100) / states_users).round rescue 0)
      audience.state_rio_negro = (((state_rio_negro * 100) / states_users).round rescue 0)
      audience.state_salta = (((state_salta * 100) / states_users).round rescue 0)
      audience.state_san_juan = (((state_san_juan * 100) / states_users).round rescue 0)
      audience.state_san_luis = (((state_san_luis * 100) / states_users).round rescue 0)
      audience.state_santa_cruz = (((state_santa_cruz * 100) / states_users).round rescue 0)
      audience.state_santa_fe = (((state_santa_fe * 100) / states_users).round rescue 0)
      audience.state_sgo_del_estero = (((state_sgo_del_estero * 100) / states_users).round rescue 0)
      audience.state_tierra_del_fuego = (((state_tierra_del_fuego * 100) / states_users).round rescue 0)
      audience.state_tucuman = (((state_tucuman * 100) / states_users).round rescue 0)

      #states Colombia
      puts "Colombia..."
      $stdout.flush
      states_users = TwitterUser.joins(:twitter_followers, :twitter_country).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_countries.name = 'Colombia'").count
      state_col_amazonas = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Amazonas'").count
      state_col_antioquia = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Antioquia'").count
      state_col_arauca = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Arauca'").count
      state_col_atlantico = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Atlántico'").count
      state_col_bolivar = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Bolívar'").count
      state_col_boyaca = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Boyacá'").count
      state_col_caldas = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Caldas'").count
      state_col_caqueta = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Caquetá'").count
      state_col_casanare = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Casanare'").count
      state_col_cauca = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Cauca'").count
      state_col_cesar = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Cesar'").count
      state_col_choco = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Chocó'").count
      state_col_cordoba = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Córdoba'").count
      state_col_cundinamarca = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Cundinamarca'").count
      state_col_guainia = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Guainía'").count
      state_col_guaviare = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Guaviare'").count
      state_col_huila = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Huila'").count
      state_col_la_guajira = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'La Guajira'").count
      state_col_magdalena = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Magdalena'").count
      state_col_meta = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Meta'").count
      state_col_narino = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Nariño'").count
      state_col_norte_de_santander = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Norte de Santander'").count
      state_col_putumayo = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Putumayo'").count
      state_col_quindio = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Quindío'").count
      state_col_risaralda = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Risaralda'").count
      state_col_san_andres = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'San Andrés y Providencia'").count
      state_col_santander = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Santander'").count
      state_col_sucre = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Sucre'").count
      state_col_tolima = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Tolima'").count
      state_col_valle_del_cauca = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Valle del Cauca'").count
      state_col_vaupes = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Vaupés'").count
      state_col_vichada = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Vichada'").count
      state_col_colombia = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Colombia'").count

      audience.state_col_amazonas = (((state_col_amazonas * 100) / states_users).round rescue 0)
      audience.state_col_antioquia = (((state_col_antioquia * 100) / states_users).round rescue 0)
      audience.state_col_arauca = (((state_col_arauca * 100) / states_users).round rescue 0)
      audience.state_col_atlantico = (((state_col_atlantico * 100) / states_users).round rescue 0)
      audience.state_col_bolivar = (((state_col_bolivar * 100) / states_users).round rescue 0)
      audience.state_col_boyaca = (((state_col_boyaca * 100) / states_users).round rescue 0)
      audience.state_col_caldas = (((state_col_caldas * 100) / states_users).round rescue 0)
      audience.state_col_caqueta = (((state_col_caqueta * 100) / states_users).round rescue 0)
      audience.state_col_casanare = (((state_col_casanare * 100) / states_users).round rescue 0)
      audience.state_col_cauca = (((state_col_cauca * 100) / states_users).round rescue 0)
      audience.state_col_cesar = (((state_col_cesar * 100) / states_users).round rescue 0)
      audience.state_col_choco = (((state_col_choco * 100) / states_users).round rescue 0)
      audience.state_col_cordoba = (((state_col_cordoba * 100) / states_users).round rescue 0)
      audience.state_col_cundinamarca = (((state_col_cundinamarca * 100) / states_users).round rescue 0)
      audience.state_col_guainia = (((state_col_guainia * 100) / states_users).round rescue 0)
      audience.state_col_guaviare= (((state_col_guaviare * 100) / states_users).round rescue 0)
      audience.state_col_huila = (((state_col_huila * 100) / states_users).round rescue 0)
      audience.state_col_la_guajira = (((state_col_la_guajira * 100) / states_users).round rescue 0)
      audience.state_col_magdalena = (((state_col_magdalena * 100) / states_users).round rescue 0)
      audience.state_col_meta = (((state_col_meta * 100) / states_users).round rescue 0)
      audience.state_col_narino = (((state_col_narino * 100) / states_users).round rescue 0)
      audience.state_col_norte_de_santander = (((state_col_norte_de_santander * 100) / states_users).round rescue 0)
      audience.state_col_putumayo = (((state_col_putumayo * 100) / states_users).round rescue 0)
      audience.state_col_quindio = (((state_col_quindio * 100) / states_users).round rescue 0)
      audience.state_col_risaralda = (((state_col_risaralda * 100) / states_users).round rescue 0)
      audience.state_col_san_andres = (((state_col_san_andres * 100) / states_users).round rescue 0)
      audience.state_col_santander = (((state_col_santander * 100) / states_users).round rescue 0)
      audience.state_col_sucre = (((state_col_sucre * 100) / states_users).round rescue 0)
      audience.state_col_tolima = (((state_col_tolima * 100) / states_users).round rescue 0)
      audience.state_col_valle_del_cauca = (((state_col_valle_del_cauca * 100) / states_users).round rescue 0)
      audience.state_col_vaupes = (((state_col_vaupes * 100) / states_users).round rescue 0)
      audience.state_col_vichada = (((state_col_vichada * 100) / states_users).round rescue 0)
      audience.state_col_colombia = (((state_col_colombia * 100) / states_users).round rescue 0)

      #states Chile
      puts "Chile..."
      $stdout.flush
      states_users = TwitterUser.joins(:twitter_followers, :twitter_country).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_countries.name = 'Chile'").count
      state_chi_arica = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Arica y Parinacota'").count
      state_chi_tarapaca = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Tarapacá'").count
      state_chi_antofogasta = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Antofagasta'").count
      state_chi_atacama = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Atacama'").count
      state_chi_coquimbo = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Coquimbo'").count
      state_chi_valparaiso = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Valparaíso'").count
      state_chi_santiago = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Santiago'").count
      state_chi_ohiggins = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'O Higgins'").count
      state_chi_maule = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Maule'").count
      state_chi_biobio = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Biobío'").count
      state_chi_la_araucania = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'La Araucanía'").count
      state_chi_los_rios = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Los Ríos'").count
      state_chi_los_lagos = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Los Lagos'").count
      state_chi_aysen = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Aysén'").count
      state_chi_magallanes = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Magallanes'").count

      audience.state_chi_arica = (((state_chi_arica * 100) / states_users).round rescue 0)
      audience.state_chi_tarapaca  = (((state_chi_tarapaca * 100) / states_users).round rescue 0)
      audience.state_chi_antofogasta  = (((state_chi_antofogasta * 100) / states_users).round rescue 0)
      audience.state_chi_atacama = (((state_chi_atacama * 100) / states_users).round rescue 0)
      audience.state_chi_coquimbo = (((state_chi_coquimbo * 100) / states_users).round rescue 0)
      audience.state_chi_valparaiso= (((state_chi_valparaiso * 100) / states_users).round rescue 0)
      audience.state_chi_santiago = (((state_chi_santiago * 100) / states_users).round rescue 0)
      audience.state_chi_ohiggins = (((state_chi_ohiggins * 100) / states_users).round rescue 0)
      audience.state_chi_maule  = (((state_chi_maule * 100) / states_users).round rescue 0)
      audience.state_chi_biobio = (((state_chi_biobio * 100) / states_users).round rescue 0)
      audience.state_chi_la_araucania = (((state_chi_la_araucania * 100) / states_users).round rescue 0)
      audience.state_chi_los_rios = (((state_chi_los_rios * 100) / states_users).round rescue 0)
      audience.state_chi_los_lagos = (((state_chi_los_lagos * 100) / states_users).round rescue 0)
      audience.state_chi_aysen = (((state_chi_aysen * 100) / states_users).round rescue 0)
      audience.state_chi_magallanes = (((state_chi_magallanes * 100) / states_users).round rescue 0)

      #states Ecuador
      puts "Ecuador..."
      $stdout.flush
      states_users = TwitterUser.joins(:twitter_followers, :twitter_country).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_countries.name = 'Ecuador'").count
      state_ecu_azuay = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Azuay'").count
      state_ecu_bolivar = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Bolívar'").count
      state_ecu_canar = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Cañar'").count
      state_ecu_carchi = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Carchi'").count
      state_ecu_chimborazo = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Chimborazo'").count
      state_ecu_cotopaxi = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Cotopaxi'").count
      state_ecu_el_oro = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'El Oro'").count
      state_ecu_esmeraldas = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Esmeraldas'").count
      state_ecu_galapagos = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Galápagos'").count
      state_ecu_guayas = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Guayas'").count
      state_ecu_imbabura = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Imbabura'").count
      state_ecu_loja = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Loja'").count
      state_ecu_los_rios = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Los Ríos'").count
      state_ecu_manabi = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Manabí'").count
      state_ecu_morona_santiago = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Morona Santiago'").count
      state_ecu_napo = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Napo'").count
      state_ecu_orellana = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Orellana'").count
      state_ecu_pastaza = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Pastaza'").count
      state_ecu_pichincha = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Pichincha'").count
      state_ecu_santa_elena = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Santa Elena'").count
      state_ecu_santo_domingo = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Santo Domingo de los Tsáchilas'").count
      state_ecu_sucumbios = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Sucumbíos'").count
      state_ecu_tungurahua = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Tungurahua'").count
      state_ecu_zamora = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Zamora Chinchipe'").count

      audience.state_ecu_azuay = (((state_ecu_azuay * 100) / states_users).round rescue 0)
      audience.state_ecu_bolivar = (((state_ecu_bolivar * 100) / states_users).round rescue 0)
      audience.state_ecu_canar = (((state_ecu_canar * 100) / states_users).round rescue 0)
      audience.state_ecu_carchi = (((state_ecu_carchi * 100) / states_users).round rescue 0)
      audience.state_ecu_chimborazo = (((state_ecu_chimborazo * 100) / states_users).round rescue 0)
      audience.state_ecu_cotopaxi = (((state_ecu_cotopaxi * 100) / states_users).round rescue 0)
      audience.state_ecu_el_oro = (((state_ecu_el_oro * 100) / states_users).round rescue 0)
      audience.state_ecu_esmeraldas = (((state_ecu_esmeraldas * 100) / states_users).round rescue 0)
      audience.state_ecu_galapagos = (((state_ecu_galapagos * 100) / states_users).round rescue 0)
      audience.state_ecu_guayas = (((state_ecu_guayas * 100) / states_users).round rescue 0)
      audience.state_ecu_imbabura = (((state_ecu_imbabura * 100) / states_users).round rescue 0)
      audience.state_ecu_loja = (((state_ecu_loja * 100) / states_users).round rescue 0)
      audience.state_ecu_los_rios = (((state_ecu_los_rios * 100) / states_users).round rescue 0)
      audience.state_ecu_manabi = (((state_ecu_manabi * 100) / states_users).round rescue 0)
      audience.state_ecu_morona_santiago = (((state_ecu_morona_santiago * 100) / states_users).round rescue 0)
      audience.state_ecu_napo = (((state_ecu_napo * 100) / states_users).round rescue 0)
      audience.state_ecu_orellana = (((state_ecu_orellana * 100) / states_users).round rescue 0)
      audience.state_ecu_pastaza = (((state_ecu_pastaza * 100) / states_users).round rescue 0)
      audience.state_ecu_pichincha = (((state_ecu_pichincha * 100) / states_users).round rescue 0)
      audience.state_ecu_santa_elena = (((state_ecu_santa_elena * 100) / states_users).round rescue 0)
      audience.state_ecu_santo_domingo = (((state_ecu_santo_domingo * 100) / states_users).round rescue 0)
      audience.state_ecu_sucumbios = (((state_ecu_sucumbios * 100) / states_users).round rescue 0)
      audience.state_ecu_tungurahua = (((state_ecu_tungurahua * 100) / states_users).round rescue 0)
      audience.state_ecu_zamora = (((state_ecu_zamora * 100) / states_users).round rescue 0)

      #states Mexico
      puts "Mexico.."
      $stdout.flush
      states_users = TwitterUser.joins(:twitter_followers, :twitter_country).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_countries.name = 'Mexico'").count
      state_mex_aguascalientes = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Aguascalientes'").count
      state_mex_baja_california = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Baja California'").count
      state_mex_baja_california_sur = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Baja California Sur'").count
      state_mex_campeche = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Campeche'").count
      state_mex_chiapas = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Chiapas'").count
      state_mex_chihuahua = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Chihuahua'").count
      state_mex_coahuila = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Coahuila de Zaragoza'").count
      state_mex_colima = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Colima'").count
      state_mex_distrito_federal = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Distrito Federal'").count
      state_mex_durango = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Durango'").count
      state_mex_guanajuato = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Guanajuato'").count
      state_mex_guerrero = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Guerrero'").count
      state_mex_hidalgo = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Hidalgo'").count
      state_mex_jalisco = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Jalisco'").count
      state_mex_mexico = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'México'").count
      state_mex_michoacan = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Michoacán de Ocampo'").count
      state_mex_morelos = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Morelos'").count
      state_mex_nayarit = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Nayarit'").count
      state_mex_nuevo_leon = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Nuevo León'").count
      state_mex_oaxaca = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Oaxaca'").count
      state_mex_puebla = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Puebla'").count
      state_mex_queretaro = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Querétaro'").count
      state_mex_quintana_roo = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Quintana Roo'").count
      state_mex_san_luis = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'San Luis Potosí'").count
      state_mex_sinaloa = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Sinaloa'").count
      state_mex_sonora = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Sonora'").count
      state_mex_tabasco = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Tabasco'").count
      state_mex_tamaulipas = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Tamaulipas'").count
      state_mex_tlaxcala = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Tlaxcala'").count
      state_mex_veracruz = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Veracruz de Ignacio de la Llave'").count
      state_mex_yucatan = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Yucatán'").count
      state_mex_zacatecas = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Zacatecas'").count

      audience.state_mex_aguascalientes  = (((state_mex_aguascalientes * 100) / states_users).round rescue 0)
      audience.state_mex_baja_california = (((state_mex_baja_california * 100) / states_users).round rescue 0)
      audience.state_mex_baja_california_sur = (((state_mex_baja_california_sur * 100) / states_users).round rescue 0)
      audience.state_mex_campeche = (((state_mex_campeche * 100) / states_users).round rescue 0)
      audience.state_mex_chiapas = (((state_mex_chiapas * 100) / states_users).round rescue 0)
      audience.state_mex_chihuahua = (((state_mex_chihuahua * 100) / states_users).round rescue 0)
      audience.state_mex_coahuila = (((state_mex_coahuila * 100) / states_users).round rescue 0)
      audience.state_mex_colima = (((state_mex_colima * 100) / states_users).round rescue 0)
      audience.state_mex_distrito_federal = (((state_mex_distrito_federal * 100) / states_users).round rescue 0)
      audience.state_mex_durango = (((state_mex_durango * 100) / states_users).round rescue 0)
      audience.state_mex_guanajuato = (((state_mex_guanajuato * 100) / states_users).round rescue 0)
      audience.state_mex_guerrero = (((state_mex_guerrero * 100) / states_users).round rescue 0)
      audience.state_mex_hidalgo = (((state_mex_hidalgo * 100) / states_users).round rescue 0)
      audience.state_mex_jalisco = (((state_mex_jalisco * 100) / states_users).round rescue 0)
      audience.state_mex_mexico  = (((state_mex_mexico * 100) / states_users).round rescue 0)
      audience.state_mex_michoacan = (((state_mex_michoacan * 100) / states_users).round rescue 0)
      audience.state_mex_morelos = (((state_mex_morelos * 100) / states_users).round rescue 0)
      audience.state_mex_nayarit = (((state_mex_nayarit * 100) / states_users).round rescue 0)
      audience.state_mex_nuevo_leon  = (((state_mex_nuevo_leon * 100) / states_users).round rescue 0)
      audience.state_mex_oaxaca= (((state_mex_oaxaca * 100) / states_users).round rescue 0)
      audience.state_mex_puebla = (((state_mex_puebla * 100) / states_users).round rescue 0)
      audience.state_mex_queretaro = (((state_mex_queretaro * 100) / states_users).round rescue 0)
      audience.state_mex_quintana_roo  = (((state_mex_quintana_roo * 100) / states_users).round rescue 0)
      audience.state_mex_san_luis = (((state_mex_san_luis * 100) / states_users).round rescue 0)
      audience.state_mex_sinaloa  = (((state_mex_sinaloa * 100) / states_users).round rescue 0)
      audience.state_mex_sonora  = (((state_mex_sonora * 100) / states_users).round rescue 0)
      audience.state_mex_tabasco  = (((state_mex_tabasco * 100) / states_users).round rescue 0)
      audience.state_mex_tamaulipas = (((state_mex_tamaulipas * 100) / states_users).round rescue 0)
      audience.state_mex_tlaxcala = (((state_mex_tlaxcala * 100) / states_users).round rescue 0)
      audience.state_mex_veracruz   = (((state_mex_veracruz * 100) / states_users).round rescue 0)
      audience.state_mex_yucatan = (((state_mex_yucatan * 100) / states_users).round rescue 0)
      audience.state_mex_zacatecas  = (((state_mex_zacatecas * 100) / states_users).round rescue 0)

      #states Paraguay
      puts "Paraguay..."
      $stdout.flush
      states_users = TwitterUser.joins(:twitter_followers, :twitter_country).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_countries.name = 'Paraguay'").count
      state_par_asuncion = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Asunción'").count
      state_par_concepcion = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Concepción'").count
      state_par_san_pedro = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'San Pedro'").count
      state_par_cordillera = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Cordillera'").count
      state_par_guaira = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Guairá'").count
      state_par_caaguazu = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Caaguazú'").count
      state_par_caazapa = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Caazapá'").count
      state_par_itapua = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Itapúa'").count
      state_par_misiones = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Misiones'").count
      state_par_paraguari = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Paraguarí'").count
      state_par_alto_parana = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Alto Paraná'").count
      state_par_central = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Central'").count
      state_par_neenbucu = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Ñeembucú'").count
      state_par_amambay = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Amambay'").count
      state_par_canindeyu = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Canindeyú'").count
      state_par_presidente_hayes = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Presidente Hayes'").count
      state_par_alto_paraguay = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Alto Paraguay'").count
      state_par_boqueron = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Boquerón'").count

      audience.state_par_asuncion = (((state_par_asuncion * 100) / states_users).round rescue 0)
      audience.state_par_concepcion = (((state_par_concepcion * 100) / states_users).round rescue 0)
      audience.state_par_san_pedro = (((state_par_san_pedro * 100) / states_users).round rescue 0)
      audience.state_par_cordillera = (((state_par_cordillera * 100) / states_users).round rescue 0)
      audience.state_par_guaira = (((state_par_guaira * 100) / states_users).round rescue 0)
      audience.state_par_caaguazu = (((state_par_caaguazu * 100) / states_users).round rescue 0)
      audience.state_par_caazapa  = (((state_par_caazapa * 100) / states_users).round rescue 0)
      audience.state_par_itapua = (((state_par_itapua * 100) / states_users).round rescue 0)
      audience.state_par_misiones  = (((state_par_misiones * 100) / states_users).round rescue 0)
      audience.state_par_paraguari   = (((state_par_paraguari * 100) / states_users).round rescue 0)
      audience.state_par_alto_parana  = (((state_par_alto_parana * 100) / states_users).round rescue 0)
      audience.state_par_central     = (((state_par_central * 100) / states_users).round rescue 0)
      audience.state_par_neenbucu  = (((state_par_neenbucu * 100) / states_users).round rescue 0)
      audience.state_par_amambay   = (((state_par_amambay * 100) / states_users).round rescue 0)
      audience.state_par_canindeyu  = (((state_par_canindeyu * 100) / states_users).round rescue 0)
      audience.state_par_presidente_hayes  = (((state_par_presidente_hayes * 100) / states_users).round rescue 0)
      audience.state_par_alto_paraguay   = (((state_par_alto_paraguay * 100) / states_users).round rescue 0)
      audience.state_par_boqueron  = (((state_par_boqueron * 100) / states_users).round rescue 0)

      #states Uruguay
      puts "Uruguay..."
      $stdout.flush
      states_users = TwitterUser.joins(:twitter_followers, :twitter_country).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_countries.name = 'Uruguay'").count
      state_uru_artigas = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Artigas'").count
      state_uru_canelones = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Canelones'").count
      state_uru_cerro_largo = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Cerro Largo'").count
      state_uru_colonia = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Colonia'").count
      state_uru_durazno = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Durazno'").count
      state_uru_flores = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Flores'").count
      state_uru_florida = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Florida'").count
      state_uru_lavalleja = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Lavalleja'").count
      state_uru_maldonado = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Maldonado'").count
      state_uru_montevideo = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Montevideo'").count
      state_uru_paysandu = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Paysandú'").count
      state_uru_rio_negro = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Río Negro'").count
      state_uru_rivera = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Rivera'").count
      state_uru_rocha = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Rocha'").count
      state_uru_salto = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Salto'").count
      state_uru_san_jose = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'San José'").count
      state_uru_soriano = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Soriano'").count
      state_uru_tacuarembo = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Tacuarembó'").count
      state_uru_treinta_y_tres = TwitterUser.joins(:twitter_followers, :twitter_state).where("influencer_id = ?", audience.influencer_id).where("twitter_state_id is not null").where("twitter_states.name = 'Treinta y Tres'").count

      audience.state_uru_artigas = (((state_par_asuncion * 100) / states_users).round rescue 0)
      audience.state_uru_canelones = (((state_par_asuncion * 100) / states_users).round rescue 0)
      audience.state_uru_cerro_largo = (((state_par_asuncion * 100) / states_users).round rescue 0)
      audience.state_uru_colonia = (((state_par_asuncion * 100) / states_users).round rescue 0)
      audience.state_uru_durazno = (((state_par_asuncion * 100) / states_users).round rescue 0)
      audience.state_uru_flores = (((state_par_asuncion * 100) / states_users).round rescue 0)
      audience.state_uru_florida = (((state_par_asuncion * 100) / states_users).round rescue 0)
      audience.state_uru_lavalleja = (((state_par_asuncion * 100) / states_users).round rescue 0)
      audience.state_uru_maldonado = (((state_par_asuncion * 100) / states_users).round rescue 0)
      audience.state_uru_montevideo = (((state_par_asuncion * 100) / states_users).round rescue 0)
      audience.state_uru_paysandu   = (((state_par_asuncion * 100) / states_users).round rescue 0)
      audience.state_uru_rio_negro  = (((state_par_asuncion * 100) / states_users).round rescue 0)
      audience.state_uru_rivera   = (((state_par_asuncion * 100) / states_users).round rescue 0)
      audience.state_uru_rocha  = (((state_par_asuncion * 100) / states_users).round rescue 0)
      audience.state_uru_salto  = (((state_par_asuncion * 100) / states_users).round rescue 0)
      audience.state_uru_san_jose  = (((state_par_asuncion * 100) / states_users).round rescue 0)
      audience.state_uru_soriano  = (((state_par_asuncion * 100) / states_users).round rescue 0)
      audience.state_uru_tacuarembo  = (((state_par_asuncion * 100) / states_users).round rescue 0)
      audience.state_uru_treinta_y_tres   = (((state_par_asuncion * 100) / states_users).round rescue 0)

      audience.save

      puts "Audience for #{audience.influencer.full_name} updated"
      $stdout.flush
    end
  end

  desc "Updates the klout index for each one of the influencers"
  task update_klout: :environment do
    Influencer.includes(:user).order('id').all.each do |influencer|
      puts "Updating klout for #{influencer.full_name}"
      $stdout.flush
      begin
        klout_id = Klout::Identity.find_by_screen_name(influencer.user.twitter_screen_name)
        user = Klout::User.new(klout_id.id)
        audience = Audience.where(influencer_id: influencer.id).first
        audience.klout = user.score.score.round
        audience.save
        puts "New Klout index: #{audience.klout}"
        $stdout.flush
      rescue
        puts "Unable to get a klout index for #{influencer.full_name}"
        $stdout.flush
      end

      puts "Updating Kred for #{influencer.full_name}"
      $stdout.flush
      begin
        # We setup mechanize to start fetching each one of the user details
        agent = Mechanize.new { |agent|
          agent.user_agent_alias = 'Mac Safari'
          agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
        }
        app_id = "1a89271a"
        app_key = "d511ab0449dcb36e2810a98c648de706"

        response = agent.get("http://api.kred.com/kredscore?term=#{influencer.user.twitter_screen_name}&source=twitter&app_id=#{app_id}&app_key=#{app_key}")
        parsed_json = ActiveSupport::JSON.decode(response.body)
        audience.kred =  parsed_json['data'][0]['influence']
        audience.save

        puts "New Kred index: #{audience.kred}"
        $stdout.flush
      rescue Exception => e
        puts "Algo salió mal obteniendo el KredScore... #{e.message.to_s}"
        $stdout.flush
      end

      puts "Updating PeerIndex for #{influencer.full_name}"
      $stdout.flush
      begin
        # We setup mechanize to start fetching each one of the user details
        agent = Mechanize.new { |agent|
          agent.user_agent_alias = 'Mac Safari'
          agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
        }
        api_key = "51b459460183a52be5f9eaac38f67b37"

        response = agent.get("http://api.peerindex.net/v2/profile/profile.json?id=#{influencer.user.twitter_screen_name}&api_key=#{api_key}")
        parsed_json = ActiveSupport::JSON.decode(response.body)
        audience.peerindex =  parsed_json['peerindex']
        audience.save

        puts "New PeerIndex index: #{audience.peerindex}"
        $stdout.flush
      rescue Exception => e
        puts "Algo salió mal obteniendo el PeerIndex... #{e.message.to_s}"
        $stdout.flush
      end


      sleep(1)
    end
  end

  desc "Update the twitter fees for influencers"
  task update_twitter_prices: :environment do
    Tweet.all.each do |tweet|
      tweet.tweet_fee = tweet.influencer.tweet_fee
      tweet.influencer_tweet_fee = tweet.influencer.influencer_tweet_fee
      tweet.cpc_fee = tweet.influencer.cpc_fee
      tweet.influencer_cpc_fee = tweet.influencer.influencer_cpc_fee
      tweet.save
    end
  end

  desc "Update the campaign analytics"
  task update_campaign_analytics: :environment do
    Campaign.where(status: 'active').all.each do |campaign|
      campaign.update_metrics
      campaign.update_campaign_counters
    end
  end

  desc "Sync users to mailchimp"
  task sync_mailchimp: :environment do
    Gibbon.api_key = MAILCHIMP_KEY
    puts "Updateando anunciantes"
    $stdout.flush
    User.where(role: 'advertiser').all.each do |user|
      list_id = Gibbon.lists['data'].find {|l| l['name'] == "Anunciantes"}['id']

      Gibbon.listSubscribe(apikey: MAILCHIMP_KEY, id: list_id, email_address: user.email,
                           merge_vars: {'FNAME' => user.advertiser.first_name, 'LNAME' => user.advertiser.last_name},
                           double_optin: false, update_existing: true)
    end
    puts "Updateando celebridades"
    $stdout.flush
    User.where(role: 'influencer').all.each do |user|
      list_id = Gibbon.lists['data'].find {|l| l['name'] == "Celebridades"}['id']

      Gibbon.listSubscribe(apikey: MAILCHIMP_KEY, id: list_id, email_address: user.email,
                           merge_vars: {'FNAME' => user.influencer.first_name, 'LNAME' => user.influencer.last_name},
                           double_optin: false, update_existing: true)
    end
    puts "Updateando afiliados"
    $stdout.flush
    User.where(role: 'affiliate').all.each do |user|
      list_id = Gibbon.lists['data'].find {|l| l['name'] == "Agencias"}['id']

      Gibbon.listSubscribe(apikey: MAILCHIMP_KEY, id: list_id, email_address: user.email,
                           merge_vars: {'FNAME' => user.affiliate.first_name, 'LNAME' => user.affiliate.last_name},
                           double_optin: false, update_existing: true)
    end
  end

  desc "Fix balances"
  task fix_balances: :environment do
    User.all.each do |user|
      puts "Fixing balance for #{user.full_name}"
      $stdout.flush
      user.balance = 0
      user.save
      Transaction.where(user_id: user.id).order('id asc').all.each do |transaction|
        transaction.balance = user.balance + transaction.amount
        user.balance = transaction.balance
        transaction.save
      end
      user.save
    end
  end

  desc 'Test'
  task :tester, [:arg1] => :environment do |t, args|
    args.with_defaults(:arg1 => "0")
    puts args.arg1.to_i.to_s
    $stdout.flush
  end

  # rake borwin:public_forced["299"]
  desc 'Publish active tweets'
  task :public_forced, [:arg1] => :environment do |t, args|
    args.with_defaults(:arg1 => "0")
    puts "[INFO] Horario de ejecución: " + Time.now.to_s
    $stdout.flush

    tweets = Tweet.where("id = #{args.arg1}").all

    tweets.each do |tweet|
      begin
        influencer = tweet.influencer
        puts "[INFO] Tweet por publicar a @" + influencer.user.twitter_screen_name + " - " + tweet.tweet_at.to_s
        $stdout.flush

        publish = true

        if publish
          Twitter.configure do |config|
            config.consumer_key = TWITTER_CONSUMER_KEY
            config.consumer_secret = TWITTER_CONSUMER_SECRET
            config.oauth_token = influencer.user.twitter_token
            config.oauth_token_secret = influencer.user.twitter_secret
          end
          twitter_tweet = Twitter.update(tweet.text)

          # Update the tweet fields
          if ! twitter_tweet.attrs['id_str'].empty?
            tweet.twitter_id = twitter_tweet.attrs['id_str']
            tweet.twitter_created_at = twitter_tweet.attrs['created_at']
            tweet.retweet_count = 0
            tweet.status = 'activated'
            puts "[SUCCESS] Publicado en Twitter. ID: " + twitter_tweet.attrs['id_str']
            $stdout.flush
            if tweet.save
              puts "[SUCCESS] Guardado con éxito"
              $stdout.flush
            else
              puts "[ERROR] El tweet no pudo ser guardado!"
              $stdout.flush
            end
          else
            puts "[ERROR] El tweet no pudo ser publicado!"
            $stdout.flush
          end
        else
          puts "No publicable. "
          $stdout.flush
        end
      rescue Exception => e
        puts "[ERROR] #{e.message}"
        $stdout.flush

        Notifier.error_publishing(tweet)
      end

      begin
        # Now activates the tweet. Internally activates the campaign if needed
        tweet.activate

        # Activate the campaign if needed
        unless tweet.campaign.status == 'active'
          puts "[INFO] La campaña debe ser activada!"
          $stdout.flush
          if (tweet.campaign.activate_campaign rescue nil).nil?
            puts "[ERROR] Error activando campaña"
            $stdout.flush
          end
        end
        # Update campaign reach and share
        if (tweet.campaign.update_reach_and_share rescue nil).nil?
          puts "[ERROR] No se pudo actualizar el Reach & Share de la campaña"
          $stdout.flush
        end

      rescue Exception => e
        puts "[ERROR] #{e.message}"
        $stdout.flush
      end
    end
  end


  def time_diff_in_minutes (datetime)

    ntime = DateTime.new(datetime.year, datetime.month, datetime.day, datetime.hour, datetime.min, 0, '-0300')
    nnow  = DateTime.new(DateTime.now.year, DateTime.now.month, DateTime.now.day, DateTime.now.hour, DateTime.now.min, 0, '-0300')

    time = Time.parse(ntime.to_s)
    time_now = Time.parse(nnow.to_s)

    diff_seconds = (time_now - time).round
    diff_minutes = diff_seconds / 60
    return diff_minutes
  end

end