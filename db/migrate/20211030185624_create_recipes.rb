class CreateRecipes < ActiveRecord::Migration[6.1]
  def change
    create_table :recipes do |t|
      t.string :name
      t.integer :people_quantity
      t.string :notes
      t.float :rate

      t.timestamps
    end
  end
end
