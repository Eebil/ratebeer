class Beer < ApplicationRecord
  include AverageRating

  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user

  validates :name, length: { minimum: 1 },
                   presence: true
  validates :style, presence: true
  validates :brewery_id, presence: true

  def to_s
    "#{name}, #{brewery.name}"
  end
end
