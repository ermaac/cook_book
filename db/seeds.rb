file_path = Rails.root.join('db', 'recipes.json')
RecipesProcessor.new(file_path).process
