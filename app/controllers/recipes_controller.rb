class RecipesController < ApplicationController
  def index
    @recipes = RecipesFinder.new(products).recipes
    render :index
  end

  private

  def products
    params[:products]&.split("\r\n")
  end
end
