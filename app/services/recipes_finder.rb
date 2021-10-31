class RecipesFinder
  WITH_INGREDIENTS_QUERY = 'array_agg(ingredient_id) <@ array[?]::bigint[]'.freeze

  attr_reader :products

  def initialize(products)
    @products = products
  end

  def recipes
    return [] unless products.present? && products_regexp.present?

    available_ingredients = Ingredient.where('ingredients.name ~* ?', products_regexp)
    Recipe.joins(:steps).group(:id).having(WITH_INGREDIENTS_QUERY, available_ingredients.ids)
  end

  private

  def products_regexp
    @products_regexp = products.map(&method(:with_word_boundries)).join('|')
  end

  def with_word_boundries(product)
    "\\y#{product}\\y" # Postgres: \y	matches only at the beginning or end of a word
  end
end
