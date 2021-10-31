module Recipes
  class RecipeStepsImporter
    def self.import_all!(recipe, ingredients)
      ingredients.each_with_index do |ingredient_description, index|
        new(recipe, ingredient_description, index).import!
      end
    end

    attr_reader :recipe, :ingredient_description, :step_number,
                :ingredient, :ingredient_unit, :recipe

    def initialize(recipe, ingredient_description, step_number)
      @recipe = recipe
      @ingredient_description = ingredient_description
      @step_number = step_number
    end

    def import!
      import_ingredient!
      import_ingredient_unit!
      import_recipe_step!
    end

    private

    def ingredient_info
      @ingredient_info ||= IngredientParser.new(ingredient_description).parse
    end

    def import_ingredient!
      @ingredient = Ingredient.find_or_create_by!(name: ingredient_info[:name])
    end

    def import_ingredient_unit!
      unit_name = ingredient_info[:unit] || 'absolute'
      @ingredient_unit = IngredientUnit.find_or_create_by!(name: unit_name)
    end

    def import_recipe_step!
      Recipe::Step.create!(recipe_step_params)
    end

    def recipe_step_params
      { ingredient: ingredient,
        ingredient_unit: ingredient_unit,
        ingredient_amount: @ingredient_info[:amount] || 1,
        recipe: recipe,
        step_number: step_number,
        notes: @ingredient_info[:notes] }
    end
  end
end
