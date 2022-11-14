require 'rails_helper'

RSpec.describe Beer, type: :model do
  let(:test_brewery) { Brewery.create name: "test", year: 2000 }
  let(:test_style)   { Style.create name: "Lager", description: "test" }
  let(:test_beer) { Beer.create name: "testbeer", style: test_style, brewery: test_brewery }
  let(:no_style_beer) { Beer.create name: "testbeer", brewery: test_brewery }
  let(:no_name_beer)  { Beer.create name: "testbeer", brewery: test_brewery }

  describe "When given name, style and valid Brewery" do
    it "is saved" do
      expect(test_beer).to be_valid
      expect(Beer.count).to eq(1)
    end
  end

  describe "when given incomplete beer data" do
    it "is not saved when given no name" do
      expect(no_name_beer).to_not be_valid
      expect(Beer.count).to eq(0)
    end
    it "is not saved when given no style" do
      expect(no_style_beer).to_not be_valid
      expect(Beer.count).to eq(0)
    end
  end
end
