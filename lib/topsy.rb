# encoding: utf-8

class Topsy
  API_KEY = "DB588F3A20E34B398D7534A472C02584"

  class << self

    def hashtag_histogram(hashtag)
      begin
        uri = URI.parse("http://otter.topsy.com/searchhistogram.json?q="+hashtag+"&count_method=citation&apikey="+API_KEY)
        response = Net::HTTP.get_response(uri)
        parsed_json = ActiveSupport::JSON.decode(response.body)
        histogram =  parsed_json['response']['histogram'].reverse.collect {|cm| cm}.join(',')
      rescue Exception => e
        puts "Algo salió mal obteniendo el histograma del hashtag... #{e.message.to_s}"
      end
    end

    def hashtag_experts(hashtag)
      begin
        uri = URI.parse("http://otter.topsy.com/experts.json?q="+hashtag+"&allow_lang=es&apikey="+API_KEY)
        response = Net::HTTP.get_response(uri)
        parsed_json = ActiveSupport::JSON.decode(response.body)
        experts =  parsed_json['response']['list'].collect {|cm| cm}
      rescue Exception => e
        puts "Algo salió mal obteniendo los expertos del hashtag... #{e.message.to_s}"
      end
    end

    def phrase_histogram(phrase)
      begin
        uri = URI.parse("http://otter.topsy.com/searchhistogram.json?q="+URI.encode(phrase).to_s+"&count_method=citation&apikey="+API_KEY)
        response = Net::HTTP.get_response(uri)
        parsed_json = ActiveSupport::JSON.decode(response.body)
        histogram_phrase =  parsed_json['response']['histogram'].reverse.collect {|cm| cm}.join(',')
      rescue Exception => e
        puts "Algo salió mal obteniendo el histograma de la frase... #{e.message.to_s}"
      end
    end

    def phrase_experts(phrase)
      begin
        uri = URI.parse("http://otter.topsy.com/experts.json?q="+URI.encode(phrase).to_s+"&allow_lang=es&apikey="+API_KEY)
        response = Net::HTTP.get_response(uri)
        parsed_json = ActiveSupport::JSON.decode(response.body)
        phrase_experts =  parsed_json['response']['list'].collect {|cm| cm}
      rescue Exception => e
        puts "Algo salió mal obteniendo los expertos de la frase... #{e.message.to_s}"
      end
    end

    def twitter_user_histogram(twitter_screen_name)
      begin
        uri = URI.parse("http://otter.topsy.com/searchhistogram.json?q="+twitter_screen_name+"&count_method=citation&apikey="+API_KEY)
        response = Net::HTTP.get_response(uri)
        parsed_json = ActiveSupport::JSON.decode(response.body)
        histogram_twitter_user =  parsed_json['response']['histogram'].reverse.collect {|cm| cm}.join(',')
      rescue Exception => e
        puts "Algo salió mal obteniendo el histograma para un usuario... #{e.message.to_s}"
      end
    end

    def twitter_user_experts(twitter_screen_name)
      begin
        uri = URI.parse("http://otter.topsy.com/experts.json?q="+twitter_screen_name+"&allow_lang=es&apikey="+API_KEY)
        response = Net::HTTP.get_response(uri)
        parsed_json = ActiveSupport::JSON.decode(response.body)
        user_experts =  parsed_json['response']['list'].collect {|cm| cm}
      rescue Exception => e
        puts "Algo salió mal obteniendo los expertos de un usuario... #{e.message.to_s}"
      end
    end
  end

end