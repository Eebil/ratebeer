require 'rails_helper'

include Helpers

describe "New Beer" do
  before :each do
    FactoryBot.create :brewery
  end

  it "creates new beer when given valid form entries" do
    create_new_beer('test', 'Weizen', 'anonymous')

    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(1)

    expect(page).to have_content 'Beer was successfully created.'
  end

  it "Won't create new new beer from invalid parameters" do
    create_new_beer("", 'Weizen', 'anonymous')

    expect{
      click_button('Create Beer')
    }.to_not change{Beer.count}

    expect(page).to have_content 'Name is too short (minimum is 1 character)'
  end
end