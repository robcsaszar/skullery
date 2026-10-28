import 'package:larder_api/larder_api.dart';

/// Everything the static build renders, read once from the larder.
class SiteData {
  const SiteData({
    required this.recipes,
    required this.chefs,
    required this.categories,
    required this.meals,
    required this.kitchens,
    required this.labels,
  });

  /// Every recipe, newest first.
  final List<Recipe> recipes;
  final List<Chef> chefs;
  final List<Category> categories;
  final List<Meal> meals;
  final List<Kitchen> kitchens;
  final List<Label> labels;

  static const pageSize = 20;

  int get pageCount =>
      recipes.isEmpty ? 1 : (recipes.length + pageSize - 1) ~/ pageSize;

  List<Recipe> page(int n) {
    final start = (n - 1) * pageSize;
    if (start >= recipes.length) return const [];
    return recipes.sublist(start, (start + pageSize).clamp(0, recipes.length));
  }

  Recipe? bySlug(String slug) {
    for (final r in recipes) {
      if (r.slug == slug) return r;
    }
    return null;
  }

  List<Recipe> byChef(String slug) =>
      recipes.where((r) => r.chef.slug == slug).toList();
  List<Recipe> byCategory(String slug) =>
      recipes.where((r) => r.categories.any((c) => c.slug == slug)).toList();
  List<Recipe> byMeal(String slug) =>
      recipes.where((r) => r.meal?.slug == slug).toList();
  List<Recipe> byKitchen(String slug) =>
      recipes.where((r) => r.kitchen?.slug == slug).toList();
  List<Recipe> byLabel(String slug) =>
      recipes.where((r) => r.labels.any((l) => l.slug == slug)).toList();

  /// Reads the whole collection through the interface, page by page.
  static Future<SiteData> load(Larder larder) async {
    final recipes = <Recipe>[];
    var page = 1;
    while (true) {
      final p = await larder.listRecipes(page: page, pageSize: 50);
      recipes.addAll(p.recipes);
      if (recipes.length >= p.total || p.recipes.isEmpty) break;
      page++;
    }
    return SiteData(
      recipes: List.unmodifiable(recipes),
      chefs: await larder.listChefs(),
      categories: await larder.listCategories(),
      meals: await larder.listMeals(),
      kitchens: await larder.listKitchens(),
      labels: await larder.listLabels(),
    );
  }
}
