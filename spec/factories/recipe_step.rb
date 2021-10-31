FactoryBot.define do
  sequence(:step_number) { 1 }

  factory :recipe_step, class: Recipe::Step do
    step_number { generate(:step_number) }
    ingredient_amount { 10 }
  end
end
