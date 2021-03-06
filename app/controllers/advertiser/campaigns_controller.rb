# encoding: utf-8
require 'topsy'

class Advertiser::CampaignsController < ApplicationController
  before_filter :authenticate_user!, :require_advertiser
  before_filter :verify_can_create_campaign, only: [:new, :create]

  # Shows the campaigns
  def index
    @campaign_count = Campaign.created_and_active.where(advertiser_id: current_role.id).count
    if @campaign_count > 0
      if params[:search].nil?
        @search = Campaign.created_and_active.where(advertiser_id: current_role.id).order('created_at desc').search(params[:search])
      else
        @search = Campaign.created_and_active.where(advertiser_id: current_role.id).search(params[:search])
      end
      @campaigns = @search.page(params[:page])
    else
      render action: 'no_active_campaigns'
    end
  end

  # Shows the archived campaigns
  def archived
    @search = Campaign.archived.where(advertiser_id: current_role.id).search(params[:search])
    @campaigns = @search.page(params[:page])
  end

  # Shows a campaign
  def show
    @campaign = current_role.campaigns.find(params[:id])
    if @campaign.tweets.count == 0
      render action: 'no_tweets'
    else
      search_params = params[:search] || {}
      search_params.reverse_merge!({"meta_sort" => "tweet_at.desc"})

      @search = Tweet.where(campaign_id: @campaign.id).search(search_params)
      @tweets = @search.page(params[:page])
    end
  end

  # Shows the form to create a new campaign
  def new
    @campaign = Campaign.new
  end

  # Creates a new campaign
  def create
    @campaign = Campaign.new(params[:campaign])
    @campaign.advertiser_id = current_role.id

    # Set default values for the campaign
    @campaign.moms=true;
    @campaign.teens=true;
    @campaign.college_students=true;
    @campaign.young_women=true;
    @campaign.young_men=true;
    @campaign.adult_men=true;
    @campaign.adult_women=true;

    @campaign.males=true;
    @campaign.females=true;

    @campaign.sports=true;
    @campaign.music=true;
    @campaign.fashion=true;
    @campaign.movies=true;
    @campaign.politics=true;
    @campaign.technology=true;
    @campaign.travel=true;
    @campaign.luxury=true;

    @campaign.locations = ["Cualquiera"]

    @campaign.followers_qty = ["0-500", "500-2000", "2000-10000", "10000-100000", "100000-300000", "300000-600000",
                               "600000-900000", "900000-2000000", "2000000-50000000"]

    case APP_CONFIG['app_country']
      when 'AR'
        @campaign.tweet_price = ["0-300", "300-1000", "1000-2000", "2000-3000", "3000-5000", "5000-7000", "7000-10000",
                                 "10000-20000", "20000-50000", "+50000"]
      when 'CO'
        @campaign.tweet_price = ["0-150000", "150000-500000", "500000-1000000", "1000000-1500000", "1500000-2500000", "2500000-3500000", "3500000-5000000",
               "5000000-10000000", "10000000-25000000", "+25000000"]
      when 'MX'
        @campaign.tweet_price = ["0-750", "750-2500", "2500-5000", "5000-7500", "7500-12500", "12500-17500", "17500-25000",
               "25000-50000", "50000-125000", "+125000"]
    end

    if @campaign.save
      flash[:notice] = "La campaña #{@campaign.name} fue creada con éxito"
      redirect_to [:audience, :advertiser, @campaign]
    else
      flash.now[:error] = "Hubo un error al intentar crear la campaña"
      render action: :new
    end

  end

  # Shows the form to update a campaign
  def edit
    @campaign = current_role.campaigns.find(params[:id])
  end

  # Updates a campaign
  def update
    @campaign = current_role.campaigns.find(params[:id])

    if @campaign.update_attributes(params[:campaign])
      flash[:notice] = "La campaña #{@campaign.name} fue actualizada"
      redirect_to [:advertiser, @campaign]
    else
      flash.now[:error] = "Hubo un error al intentar actualizar la campaña"
      render action: :edit
    end
  end

  # Shows the form to set the audience for the campaign
  def audience
    @campaign = current_role.campaigns.find(params[:id])
  end

  # Shows the statistics for the campaign
  def statistics
    @campaign = current_role.campaigns.find(params[:id])
    if @campaign.status == 'created'
      flash[:notice] = "La Campaña no tiene Tweets públicados"
      redirect_to action: 'show'
    end

    unless @campaign.hashtag.nil? or @campaign.hashtag.empty?
      @histogram = Topsy.hashtag_histogram(@campaign.hashtag.sub(/#/,'').to_s)
      @experts = Topsy.hashtag_experts(@campaign.hashtag.sub(/#/,'').to_s)
      @histogram_label = histogram_month_labels
      @hashtag_tweets = Topsy.hashtag_tweets(@campaign.hashtag.sub(/#/,'').to_s)
    end

    unless @campaign.phrase.nil? or @campaign.phrase.empty?
      @histogram_phrase = Topsy.phrase_histogram(@campaign.phrase)
      @phrase_experts = Topsy.phrase_experts(@campaign.phrase)
      @histogram_phrase_label = histogram_month_labels
      @phrase_tweets = Topsy.phrase_tweets(@campaign.phrase)
    end

    unless @campaign.twitter_screen_name.nil? or @campaign.twitter_screen_name.empty?
      @histogram_twitter_user = Topsy.twitter_user_histogram(@campaign.twitter_screen_name)
      @user_experts = Topsy.twitter_user_experts(@campaign.twitter_screen_name)
      @histogram_twitter_user_label = histogram_month_labels
      @twitter_user_tweets = Topsy.twitter_user_tweets(@campaign.twitter_screen_name)
    end

    respond_to do |format|
      format.html
      format.pdf {
        content = render_to_string(layout: false)
        pdf_file_name = generate_pdf_report(content)
        send_data File.open(pdf_file_name).read, type: 'application/pdf', disposition: "attachment; filename=campaign_report.pdf"
      }
    end
  end

  # Sets the audience for the campaign
  def set_audience
    @campaign = current_role.campaigns.find(params[:id])

    if @campaign.update_attributes(params[:campaign])
      flash[:notice] = "Has configurado la audiencia para tu campaña"
      redirect_to [:advertiser, @campaign, :tweets]
    else
      flash.now[:error] = "Hubo un error al configurar la audiencia de la campaña"
      render action: :audience
    end
  end

  # Archives a campaign
  def archive
    @campaign = current_role.campaigns.find(params[:id])

    if @campaign.archive_campaign
      flash[:notice] = "La campanaña #{@campaign.name} ha sido archivada"
      redirect_to [:advertiser, @campaign]
    else
      flash[:error] = "Hubo un error al archivar la campaña"
      redirect_to :back
    end
  end

  # Activates a campaign
  def activate
    @campaign = current_role.campaigns.find(params[:id])

    if @campaign.activate_campaign
      flash[:notice] = "La campaña #{@campaign.name} ha sido activada"
      redirect_to [:advertiser, @campaign]
    else
      flash[:error] = "Hubo un error al reactivar la campaña"
      redirect_to :back
    end
  end

  private

  def histogram_month_labels
    histogram_label = ''
    for i in 30.downto(0)
      date = (Time.now - i.day)
      if histogram_label.size == 0
        histogram_label = "'#{date.strftime('%d-%m')}'"
      else
        histogram_label += ", '#{date.strftime('%d-%m')}'"
      end
    end
    histogram_label
  end

  def random_string(size = 20)
    o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
    (0..20).map{ o[rand(o.length)]  }.join
  end

  def generate_pdf_report(content)
    html_file_name = "#{Rails.root}/tmp/pdf/#{random_string}.html"
    File.open(html_file_name, 'w') do |f|
      f << content
    end
    pdf_file_name = "#{Rails.root}/tmp/pdf/#{random_string}.pdf"

    command = "/usr/local/bin/wkhtmltopdf --margin-right 0.75in --page-size Letter --margin-top 0.75in --margin-bottom 0.75in --encoding UTF-8 --margin-left 0.75in --quiet #{html_file_name} #{pdf_file_name}"
    Rails.logger.info command
    system(command)
    pdf_file_name
  end

end