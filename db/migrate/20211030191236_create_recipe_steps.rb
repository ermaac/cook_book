class CreateRecipeSteps < ActiveRecord::Migration[6.1]
  def change
    create_table :recipe_steps do |t|
      t.references :ingredient, null: false, foreign_key: true
      t.references :ingredient_unit, null: false, foreign_key: true
      t.float :ingredient_amount, null: false
      t.references :recipe, null: false, foreign_key: true
      t.integer :step_number, null: false

      t.timestamps
    end
  end
end
