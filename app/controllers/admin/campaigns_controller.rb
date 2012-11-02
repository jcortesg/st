# encoding: utf-8
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
      begin
        uri = URI.parse("http://otter.topsy.com/searchhistogram.json?q="+@campaign.hashtag.sub(/#/,'').to_s+"&count_method=citation&apikey=DB588F3A20E34B398D7534A472C02584")
        response = Net::HTTP.get_response(uri)
        parsed_json = ActiveSupport::JSON.decode(response.body)
        @histogram =  parsed_json['response']['histogram'].reverse.collect {|cm| cm}.join(',')
        @histogram_label = ''

        for i in 30.downto(0)
          date = (Time.now - i.day)
          if @histogram_label.size == 0
            @histogram_label = "'#{date.strftime('%d-%m')}'"
          else
            @histogram_label += ", '#{date.strftime('%d-%m')}'"
          end
        end

      rescue Exception => e
        puts "Algo salió mal obteniendo el histograma del hashtag... #{e.message.to_s}"
      end

      begin
        uri = URI.parse("http://otter.topsy.com/experts.json?q="+@campaign.hashtag.sub(/#/,'').to_s+"&allow_lang=es&apikey=DB588F3A20E34B398D7534A472C02584")
        response = Net::HTTP.get_response(uri)
        parsed_json = ActiveSupport::JSON.decode(response.body)
        @experts =  parsed_json['response']['list'].collect {|cm| cm}
      rescue Exception => e
        puts "Algo salió mal obteniendo los expertos del hashtag... #{e.message.to_s}"
      end
    end

    unless @campaign.phrase.nil? or @campaign.phrase.empty?
      begin
        uri = URI.parse("http://otter.topsy.com/searchhistogram.json?q="+URI.encode(@campaign.phrase).to_s+"&count_method=citation&apikey=DB588F3A20E34B398D7534A472C02584")
        response = Net::HTTP.get_response(uri)
        parsed_json = ActiveSupport::JSON.decode(response.body)
        @histogram_phrase =  parsed_json['response']['histogram'].reverse.collect {|cm| cm}.join(',')
        @histogram_phrase_label = ''

        for i in 30.downto(0)
          date = (Time.now - i.day)
          if @histogram_phrase_label.size == 0
            @histogram_phrase_label = "'#{date.strftime('%d-%m')}'"
          else
            @histogram_phrase_label += ", '#{date.strftime('%d-%m')}'"
          end
        end

      rescue Exception => e
        puts "Algo salió mal obteniendo el histograma de la frase... #{e.message.to_s}"
      end

      begin
        uri = URI.parse("http://otter.topsy.com/experts.json?q="+URI.encode(@campaign.phrase).to_s+"&allow_lang=es&apikey=DB588F3A20E34B398D7534A472C02584")
        response = Net::HTTP.get_response(uri)
        parsed_json = ActiveSupport::JSON.decode(response.body)
        @phrase_experts =  parsed_json['response']['list'].collect {|cm| cm}
      rescue Exception => e
        puts "Algo salió mal obteniendo los expertos de la frase... #{e.message.to_s}"
      end
    end

    unless @campaign.twitter_screen_name.nil? or @campaign.twitter_screen_name.empty?
      begin
        uri = URI.parse("http://otter.topsy.com/searchhistogram.json?q="+@campaign.twitter_screen_name.to_s+"&count_method=citation&apikey=DB588F3A20E34B398D7534A472C02584")
        response = Net::HTTP.get_response(uri)
        parsed_json = ActiveSupport::JSON.decode(response.body)
        @histogram_twitter_user =  parsed_json['response']['histogram'].reverse.collect {|cm| cm}.join(',')
        @histogram_twitter_user_label = ''

        for i in 30.downto(0)
          date = (Time.now - i.day)
          if @histogram_twitter_user_label.size == 0
            @histogram_twitter_user_label = "'#{date.strftime('%d-%m')}'"
          else
            @histogram_twitter_user_label += ", '#{date.strftime('%d-%m')}'"
          end
        end

      rescue Exception => e
        puts "Algo salió mal obteniendo el histograma para un usuario... #{e.message.to_s}"
      end

      begin
        uri = URI.parse("http://otter.topsy.com/experts.json?q="+@campaign.twitter_screen_name.to_s+"&allow_lang=es&apikey=DB588F3A20E34B398D7534A472C02584")
        response = Net::HTTP.get_response(uri)
        parsed_json = ActiveSupport::JSON.decode(response.body)
        @user_experts =  parsed_json['response']['list'].collect {|cm| cm}
      rescue Exception => e
        puts "Algo salió mal obteniendo los expertos de un usuario... #{e.message.to_s}"
      end
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
