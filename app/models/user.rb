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
end
