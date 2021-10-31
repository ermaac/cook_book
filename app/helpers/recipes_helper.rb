module RecipesHelper
  def ingredient_description(recipe_step)
    amount = number_to_human(recipe_step.ingredient_amount)
    unit = ingredient_unit(recipe_step)
    name = recipe_step.ingredient.name
    "#{amount} #{unit} #{name}"
  end

  private

  def ingredient_unit(recipe_step)
    unit = recipe_step.ingredient_unit.name
    unit unless unit == 'absolute'
  end
end
