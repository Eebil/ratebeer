class Rating < ApplicationRecord
  belongs_to :beer

  # Returns rating in following string format: "<Beer name> <rating> Rating submitted: <rating created at timestamp>"
  def to_s
    "#{beer.name} | Score: #{score} | Rating submitted: #{created_at.inspect}"
  end
end
