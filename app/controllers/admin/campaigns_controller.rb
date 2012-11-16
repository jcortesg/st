# encoding: utf-8
require 'topsy'

class Admin::CampaignsController < ApplicationController
  before_filter :authenticate_user!, :require_admin

  # Shows the campaigns
  def index
    if params[:search].nil?
      @search = Campaign.created_and_active.order('created_at desc').search(params[:search])
    else
      @search = Campaign.created_and_active.search(params[:search])
    end
    @campaigns = @search.page(params[:page])
  end

  # Shows the archived campaigns
  def archived
    @search = Campaign.archived.search(params[:search])
    @campaigns = @search.page(params[:page])
  end

  # Shows a campaign
  def show
    @campaign = Campaign.find(params[:id])
  end

  # Shows the form to update a campaign
  def edit
    @campaign = Campaign.find(params[:id])
  end

  # Updates a campaign
  def update
    @campaign = Campaign.find(params[:id])

    if @campaign.update_attributes(params[:campaign])
      flash[:notice] = "La campaña #{@campaign.name} fue actualizada"
      redirect_to [:admin, @campaign]
    else
      flash.now[:error] = "Hubo un error al intentar actualizar la campaña"
      render action: :edit
    end
  end

  # Destroys a campaign
  def destroy
    @campaign = Campaign.find(params[:id])
    @campaign.destroy
    flash[:notice] = "La campaña #{@campaign.name} ha sido eliminada"
    redirect_to action: :index
  end

  # Shows the form to set the audience for the campaign
  def audience
    @campaign = Campaign.find(params[:id])
  end

  # Sets the audience for the campaign
  def set_audience
    @campaign = Campaign.find(params[:id])

    if @campaign.update_attributes(params[:campaign])
      flash[:notice] = "Has configurado la audiencia para la campaña"
      redirect_to [:admin, @campaign]
    else
      flash.now[:error] = "Hubo un error al configurar la audiencia de la campaña"
      render action: :audience
    end
  end

  # Archives a campaign
  def archive
    @campaign = Campaign.find(params[:id])

    if @campaign.archive_campaign
      flash[:notice] = "La campanaña #{@campaign.name} ha sido archivada"
      redirect_to [:admin, @campaign]
    else
      flash.now[:error] = "Hubo un error al archivar la campaña"
      redirect_to :back
    end
  end

  # Activates a campaign
  def activate
    @campaign = Campaign.find(params[:id])

    if @campaign.update_attribute(:archived, false)
      flash[:notice] = "La campaña #{@campaign.name} ha sido activada"
      redirect_to [:admin, @campaign]
    else
      flash[:error] = "Hubo un error al reactivar la campaña"
      redirect_to :back
    end
  end

  # Shows the statistics for the campaign
  def statistics
    @campaign = Campaign.find(params[:id])
    if @campaign.status == 'created'
      flash[:notice] = "La Campaña no tiene Tweets públicados"
      redirect_to action: :index
    end

    unless @campaign.hashtag.nil? or @campaign.hashtag.empty?
      @histogram = Topsy.hashtag_histogram(@campaign.hashtag.sub(/#/,'').to_s)
      @experts = Topsy.hashtag_experts(@campaign.hashtag.sub(/#/,'').to_s)
      @histogram_label = histogram_month_labels
    end

    unless @campaign.phrase.nil? or @campaign.phrase.empty?
      @histogram_phrase = Topsy.phrase_histogram(@campaign.phrase)
      @phrase_experts = Topsy.phrase_experts(@campaign.phrase)
      @histogram_phrase_label = histogram_month_labels
    end

    unless @campaign.twitter_screen_name.nil? or @campaign.twitter_screen_name.empty?
      @histogram_twitter_user = Topsy.twitter_user_histogram(@campaign.twitter_screen_name)
      @user_experts = Topsy.twitter_user_experts(@campaign.twitter_screen_name)
      @histogram_twitter_user_label = histogram_month_labels
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
