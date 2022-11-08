class Brewery < ApplicationRecord
  include AverageRating

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, length: { minimum: 1 }
  validates :year, numericality: { greater_than_or_equal_to: 1040 }
  validate :establishment_year_cannot_be_in_the_future

  def establishment_year_cannot_be_in_the_future
    return unless year > Time.zone.now.year

    errors.add(:year, "cannot be greater than current year")
  end
end
