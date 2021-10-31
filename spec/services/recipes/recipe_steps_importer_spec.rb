require 'rails_helper'

describe Recipes::RecipeStepsImporter do
  let!(:recipe) { create(:recipe) }
  let(:ingredients) do
    ["1boîte (400 g) de crozet au sarrazin(Alpina)",
     "1.5l de lait entier microfiltré",
     "1 oeuf entier",
     "250g de comté",
     "30cl de crème fraîche épaisse"]
  end

  describe '.import_all!' do
    subject(:action) { described_class.import_all!(recipe, ingredients) }

    it'imports ingredient units' do
      expect { action }.to change { IngredientUnit.count }.by(ingredients.count)
    end

    it 'imports ingredients' do
      expect { action }.to change { Ingredient.count }.by(ingredients.count)
    end

    it 'imports recipe steps' do
      expect { action }.to change { Recipe::Step.count }.by(ingredients.count)
    end
  end

  describe '#import' do
    let(:step_number) { 1 }
    let(:ingredient_description) { ingredients.last }
    subject(:action) { described_class.new(recipe, ingredient_description, step_number).import! }

    context 'when doesn\'t exist' do
      let(:new_ingredient_unit) { 'cl' }
      let(:new_ingredient) { 'de crème fraîche épaisse' }
      let(:ingredient_amount) { 30 }

      it'creates ingredient unit' do
        expect { action }.to change { IngredientUnit.count }.by(1)
        expect(IngredientUnit.last.name).to eq(new_ingredient_unit)
      end

      it 'creates ingredient' do
        expect { action }.to change { Ingredient.count }.by(1)
        expect(Ingredient.last.name).to eq(new_ingredient)
      end

      it 'creates recipe step' do
        expect { action }.to change { Recipe::Step.count }.by(1)
        recipe_step = Recipe::Step.last
        expect(recipe_step.ingredient_amount).to eq(ingredient_amount)
        expect(recipe_step.step_number).to eq(step_number)
        expect(recipe_step.recipe).to eq(recipe)
      end
    end

    context 'when exist' do
      let!(:ingredient_unit) { create(:ingredient_unit, name: 'cl') }
      let!(:ingredient) { create(:ingredient, name: 'de crème fraîche épaisse') }

      it 'uses exising ingredient unit' do
        expect { action }.not_to change { IngredientUnit.count }
      end

      it 'uses exising ingredient' do
        expect { action }.not_to change { Ingredient.count }
      end
    end
  end
end
