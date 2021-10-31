module Recipes
  class IngredientParser
    attr_reader :description, :ingredient_info

    def initialize(description)
      @description = description
      @ingredient_info = {}
    end

    def parse
      ingredient_info.tap do
        set_unit
        set_amount
        set_name
      end.transform_values(&:presence)
    end

    private

    def set_unit
      @ingredient_info[:unit] = parsed_amount[:unit]&.singularize
    end

    def set_amount
      @ingredient_info[:amount] = parsed_amount[:value]&.to_r&.to_f
    end

    def set_name
      @ingredient_info[:name] = parsed_description[:name]
    end

    def parsed_description
      @parsed_description ||= (description&.match(/((?<amount>\d.*?)\s)?(?<name>.+)/) || {})
    end

    def parsed_amount
      amount&.match(/(?<value>\d+(\/\d+|\.\d+)?)(?<unit>.*)/) || {}
    end

    def amount
      parsed_description[:amount] if parsed_description
    end
  end
end
