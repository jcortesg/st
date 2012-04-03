class Bitly < ActiveRecord::Base
  def self.shorten(long_url)
    long_url = sanitize_url(long_url)  
    client.shorten(long_url).short_url
  end
  
  def self.expand(short_url)
    short_url = sanitize_url(short_url)
    client.expand(short_url).long_url
  end
  
  private
  def client
    Bitly.use_api_version_3
  
    client = Bitly.new(
      :username => APP_CONFIG[:bitly][:username],
      :key => APP_CONFIG[:bitly][:key]
    )
  end  
  
  def sanitize_url(url)
    url = "http://" + url unless url.match(/^http:\/\//)
  end
  
  
  
  
  def self.clicks(short_url)
    bitly.clicks(short_url).user_clicks
  end
  
  # clicks per minute for the last hour in reverse chronological order 
  def self.clicks_by_minute(short_url)
    c = bitly.clicks(short_url).clicks_by_minute
    c.clicks #array de 60 posiciones
  end

  # clicks per day for the last 1-30 days in reverse chronological order
  def self.clicks_by_minute(short_url)
    c = bitly.clicks(short_url).clicks_by_day
    c.clicks #array de 30 posiciones, day_start de que dia empieza
  end
end