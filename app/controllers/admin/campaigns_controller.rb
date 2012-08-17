# encoding: utf-8
class Admin::CampaignsController < ApplicationController
  before_filter :authenticate_user!, :require_admin

  # Shows the campaigns
  def index
    @search = Campaign.created_and_active.search(params[:search])
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
