import 'types.dart';

/// The read interface of the larder. The private core over SQLite and the
/// public stub answer these calls the same way.
///
/// Recipe lists are newest first by [Recipe.date], then by title. Lookup lists
/// are in name order. Every list a recipe carries (groups, ingredients, steps)
/// is in display order, resolved from places by the implementation.
///
/// Read methods only. Writing comes with forks, versions and changes later.
abstract class Larder {
  /// One page of the whole collection, newest first. [page] is 1-based; a
  /// page past the end gives an empty list with the right [RecipePage.total].
  Future<RecipePage> listRecipes({int page = 1, int pageSize = 20});

  /// The recipe with [slug], or null when there is none.
  Future<Recipe?> getRecipe(String slug);

  /// Recipes by the chef with [slug], newest first. Empty for an unknown slug.
  Future<List<Recipe>> listByChef(String slug);

  /// Recipes in the category with [slug], newest first.
  Future<List<Recipe>> listByCategory(String slug);

  /// Recipes for the meal with [slug], newest first.
  Future<List<Recipe>> listByMeal(String slug);

  /// Recipes from the kitchen with [slug], newest first.
  Future<List<Recipe>> listByKitchen(String slug);

  /// Recipes with the label with [slug], newest first.
  Future<List<Recipe>> listByLabel(String slug);

  /// Every chef with at least one recipe, in name order.
  Future<List<Chef>> listChefs();

  /// Every category with at least one recipe, in name order.
  Future<List<Category>> listCategories();

  /// Every meal with at least one recipe, in name order.
  Future<List<Meal>> listMeals();

  /// Every kitchen with at least one recipe, in name order.
  Future<List<Kitchen>> listKitchens();

  /// Every label from the fixed list, in name order, used or not.
  Future<List<Label>> listLabels();
}
