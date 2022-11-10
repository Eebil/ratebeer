require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }
  
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end
  
    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
    
      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings({user: user}, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: user }, 25 )

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user) { FactoryBot.create(:user) }

    it "has a method for determining favorite style" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings doesn't have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "Is the style of the beer if only one is rated by the user" do
      beer = create_beer_with_rating({ user: user }, 25 )
      expect(user.favorite_style).to eq(beer.style)
    end

    it "Is the style with best avrage score when user has rated many syled beers" do
      create_beers_with_many_ratings({user: user}, 10, 20, 15, 7, 9) # Lager average 12.2
      best_beer_style = create_beer_with_rating({user: user}, 40, "Stout").style
      create_beer_with_rating({user: user}, 30, "Stout")
      create_beer_with_rating({user: user}, 20, "Sour")

      expect(user.favorite_style).to eq(best_beer_style)
    end
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end
  
    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)
  
      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end

    describe "with invalid password" do
      let(:user_short_pw){ User.create username: "Pekka", password: "Pw1", password_confirmation: "Pw1" }
      let(:user_lowercase_pw){ User.create username: "Pekka", password: "secret1", password_confirmation: "secret1" }

      it "is not saved when password given is too short" do
        expect(user_short_pw).to_not be_valid
        expect(User.count).to eq(0)
      end

      it "nor when the password given doesn't contain uppercase character" do
        expect(user_lowercase_pw).to_not be_valid
        expect(User.count).to eq(0)
      end


    end
  end
end


def create_beer_with_rating(object, score, style = "Lager")
  beer = FactoryBot.create(:beer, style:)
  FactoryBot.create(:rating, beer:, score:, user: object[:user])
  beer
end

def create_beers_with_many_ratings(object, *scores)
  scores.each do |score|
    create_beer_with_rating(object, score)
  end
end
