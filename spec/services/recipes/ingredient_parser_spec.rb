require 'rails_helper'

describe Recipes::IngredientParser do
  describe '#parse' do
    subject { described_class.new(ingredient_description).parse }
    context 'with integer ingredient amount' do
      let(:ingredient_description) { "600g de pâte à crêpe" }
      it { is_expected.to include(amount: 600, unit: 'g', name: 'de pâte à crêpe') }
    end

    context 'with rational ingredient amount' do
      let(:ingredient_description) { "1/2poignée de pistache concassées" }
      it { is_expected.to include(amount: 0.5, unit: 'poignée', name: 'de pistache concassées') }
    end

    context 'with ommited ingredient amount' do
      let(:ingredient_description) { "Piment" }
      it { is_expected.to include(name: 'Piment') }
    end

    context 'with ommited ingredint unit' do
      let(:ingredient_description) { "4 oignons" }
      it { is_expected.to include(amount: 4, name: 'oignons') }
    end

    context 'with optional notes for ingredient amount' do
      let(:ingredient_description) { "1boîte (400 g) de crozet au sarrazin(Alpina)" }
      it { is_expected.to include(amount: 1, unit: 'boîte (400 g)', name: 'de crozet au sarrazin') }
    end

    context 'with notes' do
      let(:ingredient_description) { "120g de riz (non cuit)" }
      it { is_expected.to include(amount: 120, unit: 'g', name: 'de riz', notes: 'non cuit') }
    end
  end
end
