class RecipesProcessor
  attr_reader :file_path

  def initialize(file_path)
    @file_path = file_path
  end

  def process
    File.open(file_path).each_line(&method(:process_line))
  end

  private

  def process_line(source)
    recipe_data = JSON.parse(source, symbolize_names: true)
    Recipes::Importer.new(recipe_data).import
  end
end
