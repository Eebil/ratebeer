class PlacesController < ApplicationController
  def index
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      session[:latest_city] = params[:city].downcase
      render :index, status: 418
    end
  end

  def show
    @place = Rails.cache.read(session[:latest_city]).find(params[:id]).first
  end
end
