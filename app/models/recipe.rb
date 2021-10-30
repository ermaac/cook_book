class Recipe < ApplicationRecord
  has_many :steps, class_name: 'Recipe::Step', dependent: :destroy
end
