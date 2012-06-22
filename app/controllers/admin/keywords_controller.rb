# encoding: utf-8
class Admin::KeywordsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin

  # Show the list of keywords
  def index
    @search = Keyword.search(params[:search])
    @keywords = @search.page(params[:page])
  end

  # Shows a keyword
  def show
    @keyword = Keyword.find(params[:id])
  end

  # Shows the form to update a keyword
  def edit
    @keyword = Keyword.find(params[:id])
  end

  # Updates a keyword
  def update
    @keyword = Keyword.find(params[:id])

    if @keyword.update_attributes(params[:keyword])
      flash[:notice] = "Los keywords fueron actualizados"
      redirect_to [:admin, @keyword]
    else
      flash.now[:error] = "Hubo un error al intentar actualizar los keywords"
      render action: :edit
    end
  end

end
