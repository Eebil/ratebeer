module AverageRating
  extend ActiveSupport::Concern

  # Tehtävä 5 mukainen implementaatio:  ratings.map(&:score).sum / ratings.count.to_f
  def average_rating
    ratings.average(:score).to_f
  end
end
