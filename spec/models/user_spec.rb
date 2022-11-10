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