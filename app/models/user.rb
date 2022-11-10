class User < ApplicationRecord
  include AverageRating

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :clubs, through: :memberships, source: :beer_club

  validates :username, uniqueness: true,
                       length: { minimum: 3,
                                 maximum: 30 }

  validates :password, format: { with: /\A(?=.*[A-Z])(?=.*[0-9]).{4,}\z/,
                                 message: "Password must be at least 4 characters long and contain at least 1 number and 1 uppercase letter" }

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    average_score_by_style.last[0]
  end

  def favorite_brewery
    return nil if ratings.empty?

    average_score_by_brewery.last[0]
  end

  # Returns an array that has average ratings for each style for user 
  # example output: [["Lager", 24.0], ["IPA", 27.5], ["lowalcohol", 15.5], ["Porter", 5.0]]
  def average_score_by_style
    ratings.group_by { |r| r.beer.style }.map { |style, ratings|  [style,  ratings.map(&:score).sum / ratings.size.to_f]}.sort_by { |_, rating| rating }
  end

  def average_score_by_brewery
    ratings.group_by { |r| r.beer.brewery }.map { |brewery, ratings|  [brewery.name,  ratings.map(&:score).sum / ratings.size.to_f]}.sort_by { |_, rating| rating }
  end
end
