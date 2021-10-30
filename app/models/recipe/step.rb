class Recipe::Step < ApplicationRecord
  belongs_to :ingredient
  belongs_to :ingredient_unit
  belongs_to :recipe
end
