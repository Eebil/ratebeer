class PlacesController < ApplicationController
  before_action :set_place, only: %i[show]

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
  end

  private

  def set_place
    @place = Rails.cache.read(session[:latest_city]).select { |place| place.id == params[:id] }.first
  end
end
