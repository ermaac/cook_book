module Recipes
  class Importer
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def import
      import_recipe_with_steps
    rescue StandardError => e
      Rails.logger.tagged(self.class) do |logger|
        message = "#{e.class}: #{e.message}"
        logger.error(message)
      end
    end

    private

    def import_recipe_with_steps
      ActiveRecord::Base.transaction do
        import_recipe!
        import_recipe_steps!
      end
    end

    def import_recipe!
      @recipe = Recipe.create!(recipe_params)
    end

    def import_recipe_steps!
      RecipeStepsImporter.import_all!(@recipe, @data[:ingredients])
    end

    def recipe_params
      { name: @data[:name],
        people_quantity: @data[:people_quantity],
        notes: @data[:author_tip],
        rate: @data[:rate].to_f }
    end
  end
end
