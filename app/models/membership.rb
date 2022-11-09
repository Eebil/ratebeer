class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :beer_club

  def applicable_clubs(user)
    BeerClub.all.reject { |club| club.members.include?(user) } # skim out clubs that user is already part of
  end
end
