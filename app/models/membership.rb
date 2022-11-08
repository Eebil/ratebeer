class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :beer_club


  def applicable_clubs_for_current_user
    BeerClub.all
  end
end
