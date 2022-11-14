class TransformOldStylesToNewStyles < ActiveRecord::Migration[7.0]
  def change
    Beer.all.each do |beer|
      beer.style = Style.find_by_name(beer.old_style)
      beer.save
    end
  end
end
