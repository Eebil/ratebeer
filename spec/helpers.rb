module Helpers

  def sign_in(credentials)
    visit signin_path
    fill_in('username', with:credentials[:username])
    fill_in('password', with:credentials[:password])
    click_button('Log in')
  end


  def create_beer_with_rating(object, score, style = FactoryBot.create(:style), brewery = FactoryBot.create(:brewery))
    beer = FactoryBot.create(:beer, style:, brewery: brewery)
    FactoryBot.create(:rating, beer:, score:, user: object[:user])
    beer
  end

  def create_beers_with_many_ratings(object, *scores)
    scores.each do |score|
      create_beer_with_rating(object, score)
    end
  end

  def create_new_beer(name, style, brewery)
    visit new_beer_path
    fill_in('beer_name', with: name)
    select( style , from: 'beer_style_id')
    select( brewery, from: 'beer_brewery_id')
  end

  def create_rating(beer, score)
    visit new_rating_path
    select(beer, from: 'rating[beer_id]')
    fill_in('rating[score]', with: score)
    click_button "Create Rating"
  end
end