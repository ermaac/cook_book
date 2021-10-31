module Recipes
  class IngredientParser
    attr_reader :description, :ingredient_info

    INGREDIENT_FIELDS = %i[unit amount name notes].freeze

    def initialize(description)
      @description = description
      @ingredient_info = {}
    end

    def parse
      ingredient_info.tap do
        INGREDIENT_FIELDS.each { |f| send("parse_#{f}") }
      end.transform_values(&:presence)
    end

    private

    def parse_unit
      @ingredient_info[:unit] = parsed_amount[:unit]&.strip&.singularize
    end

    def parse_amount
      @ingredient_info[:amount] = parsed_amount[:value]&.to_r&.to_f
    end

    def parse_name
      @ingredient_info[:name] = parsed_description[:name]&.strip
    end

    def parse_notes
      @ingredient_info[:notes] = parsed_description[:notes]&.strip
    end

    def parsed_description
      # TODO: refactor building regexp
      optional_amount_notes = '(\s\(.+\))?'
      amount = "(?<amount>\\d[^\\s]*#{optional_amount_notes})?"
      name = '(?<name>[^()]+)'
      notes = '(?:\((?<notes>(.+))\))?'
      @parsed_description ||= (description&.match(/#{amount}\s?#{name}\s?#{notes}/) || {})
    end

    def parsed_amount
      amount&.match(/(?<value>\d+(\/\d+|\.\d+)?)(?<unit>.*)/) || {}
    end

    def amount
      parsed_description[:amount] if parsed_description
    end
  end
end
