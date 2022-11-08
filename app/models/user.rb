class User < ApplicationRecord
  include AverageRating

  has_many :ratings
  has_many :beers, through: :ratings
  has_many :memberships
  has_many :clubs, through: :memberships, source: :beer_club

  validates :username, uniqueness: true,
                       length: { minimum: 3,
                                 maximum: 30 }
end
