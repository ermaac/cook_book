class RecipesController < ApplicationController
  def index
    @recipes = RecipesFinder.new(products).recipes
  end

  private

  def products
    @products = params[:products]
    @products&.split("\r\n")
  end
end
