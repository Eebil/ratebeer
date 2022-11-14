class Beer < ApplicationRecord
  include AverageRating

  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user
  belongs_to :style

  validates :name, length: { minimum: 1 },
                   presence: true
  validates :style, presence: true
  validates :brewery_id, presence: true

  def to_s
    "#{name}, #{brewery.name}"
  end
end
