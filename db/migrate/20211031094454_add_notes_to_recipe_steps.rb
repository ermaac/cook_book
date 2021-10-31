class AddNotesToRecipeSteps < ActiveRecord::Migration[6.1]
  def change
    add_column :recipe_steps, :notes, :string, default: ''
  end
end
