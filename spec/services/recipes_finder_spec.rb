require 'rails_helper'

describe RecipesFinder do
  let!(:recipe) { create(:recipe) }
  let!(:ingredient_unit) { create(:ingredient_unit) }
  let(:required_ingredients) { %w[coffee milk] }
  let!(:ingredient1) { create(:ingredient, name: required_ingredients[0]) }
  let!(:ingredient2) { create(:ingredient, name: required_ingredients[1]) }
  let!(:recipe_step1) do
    create(:recipe_step, recipe: recipe, ingredient_unit: ingredient_unit, ingredient: ingredient1)
  end
  let!(:recipe_step1) do
    create(:recipe_step, recipe: recipe, ingredient_unit: ingredient_unit, ingredient: ingredient2)
  end

  describe '#recipes' do
    subject { described_class.new(products).recipes }

    context 'when search with blank products list' do
      let(:products) { [] }
      it { is_expected.to be_blank }
    end

    context 'when misses some ingreient' do
      let(:products) { required_ingredients[0, 1] }
      it { is_expected.to be_blank }
    end

    context 'when all ingredients present' do
      let(:products) { required_ingredients }
      it { is_expected.to include(recipe) }
    end
  end
end
