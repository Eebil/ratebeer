require 'rails_helper'

include Helpers

describe "User" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:brewery2) { FactoryBot.create :brewery, name: "BestBrew" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery }
  let!(:beer3) { FactoryBot.create :beer, name: "IpaDapa", brewery:brewery2, style: "IPA" }
  let!(:user1) { FactoryBot.create :user }
  let!(:user2) { FactoryBot.create :user, username: "Eebil", password: "Password12", password_confirmation: "Password12" }
  before :each do
    
  end

  describe "who has signed up" do

    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'

    end

    it "when signed up with good credentials, is added to the system" do
      visit signup_path
      fill_in('user_username', with: 'Brian')
      fill_in('user_password', with: 'Secret55')
      fill_in('user_password_confirmation', with: 'Secret55')
    
      expect{
        click_button('Create User')
      }.to change{User.count}.by(1)
    end

    it "sees their own ratings from user page" do
      sign_in(username: "Pekka", password: "Foobar1")
      create_rating('iso 3', '12')
      visit user_path(user1)
      expect(page).to have_content 'Pekka has made 1 rating with an average score of 12.0'
      click_link "Sign out"
      sign_in(username: "Eebil", password: "Password12")
      visit user_path(user2)
      expect(page).to have_content 'Eebil has made 0 ratings with an average score of 0.0'
    end

    it "can delete their ratings from user page" do
      sign_in(username: "Pekka", password: "Foobar1")
      create_rating('iso 3', '20')
      create_rating('iso 3', '30')
      visit user_path(user1)
      expect(page).to have_content "Pekka has made 2 ratings with an average score of 25.0"
      click_link(href: "/ratings/2")
      expect(page).to have_content "Pekka has made 1 rating with an average score of 20.0"
    end

    it "Sees their favorite style and brewery when the user has made ratings" do
      sign_in(username: "Pekka", password: "Foobar1")
      create_rating('iso 3', '20')
      create_rating('IpaDapa', '30')
      visit user_path(user1)

      expect(page).to have_content "Favorite beer style: IPA"
      expect(page).to have_content "Favorite Brewery: BestBrew"
    end
  end
end