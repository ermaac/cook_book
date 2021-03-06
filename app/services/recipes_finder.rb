class RecipesFinder
  WITH_INGREDIENTS_QUERY = 'array_agg(ingredient_id) <@ array[?]::bigint[]'.freeze
  BLACKLISTED_SYMBOLS = '[^\p{L}\s\-\']'.freeze

  attr_reader :products

  def initialize(products)
    @products = products
  end

  def recipes
    return [] unless products.present? && products_regexp.present?

    available_ingredients = Ingredient.where('ingredients.name ~ ?', products_regexp)
    Recipe.includes(steps: [:ingredient, :ingredient_unit]).joins(:steps).group('recipes.id')
          .having(WITH_INGREDIENTS_QUERY, available_ingredients.ids)
  end

  private

  def products_regexp
    @products_regexp ||= products.map(&method(:with_word_boundries)).join('|')
  end

  def with_word_boundries(product)
    sanitized_product_name = product.gsub(/#{BLACKLISTED_SYMBOLS}/, '')
    "\\y#{sanitized_product_name}\\y" # Postgres: \y	matches only at the beginning or end of a word
  end
end
