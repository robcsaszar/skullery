import 'package:larder_api/larder_api.dart';

import 'stub_recipes.dart';

/// A [Larder] over the five invented recipes in `stub_recipes.dart`.
class StubLarder implements Larder {
  const StubLarder();

  List<Recipe> get _newestFirst {
    final list = List<Recipe>.of(stubRecipes);
    list.sort((a, b) {
      final byDate = b.date.compareTo(a.date);
      return byDate != 0 ? byDate : a.title.compareTo(b.title);
    });
    return list;
  }

  @override
  Future<RecipePage> listRecipes({int page = 1, int pageSize = 20}) async {
    final all = _newestFirst;
    final start = (page - 1) * pageSize;
    final slice = start >= all.length
        ? const <Recipe>[]
        : all.sublist(start, (start + pageSize).clamp(0, all.length));
    return RecipePage(
      recipes: List.unmodifiable(slice),
      page: page,
      pageSize: pageSize,
      total: all.length,
    );
  }

  @override
  Future<Recipe?> getRecipe(String slug) async {
    for (final r in stubRecipes) {
      if (r.slug == slug) return r;
    }
    return null;
  }

  Future<List<Recipe>> _where(bool Function(Recipe) test) async =>
      List.unmodifiable(_newestFirst.where(test));

  @override
  Future<List<Recipe>> listByChef(String slug) =>
      _where((r) => r.chef.slug == slug);

  @override
  Future<List<Recipe>> listByCategory(String slug) =>
      _where((r) => r.categories.any((c) => c.slug == slug));

  @override
  Future<List<Recipe>> listByMeal(String slug) =>
      _where((r) => r.meal?.slug == slug);

  @override
  Future<List<Recipe>> listByKitchen(String slug) =>
      _where((r) => r.kitchen?.slug == slug);

  @override
  Future<List<Recipe>> listByLabel(String slug) =>
      _where((r) => r.labels.any((l) => l.slug == slug));

  List<T> _lookups<T>(Iterable<T> all, String Function(T) name) {
    final list = all.toList();
    list.sort((a, b) => name(a).compareTo(name(b)));
    return List.unmodifiable(list);
  }

  @override
  Future<List<Chef>> listChefs() async => _lookups(
    {for (final r in stubRecipes) r.chef.slug: r.chef}.values,
    (c) => c.name,
  );

  @override
  Future<List<Category>> listCategories() async => _lookups(
    {
      for (final r in stubRecipes)
        for (final c in r.categories) c.slug: c,
    }.values,
    (c) => c.name,
  );

  @override
  Future<List<Meal>> listMeals() async => _lookups(
    {
      for (final r in stubRecipes)
        if (r.meal != null) r.meal!.slug: r.meal!,
    }.values,
    (m) => m.name,
  );

  @override
  Future<List<Kitchen>> listKitchens() async => _lookups(
    {
      for (final r in stubRecipes)
        if (r.kitchen != null) r.kitchen!.slug: r.kitchen!,
    }.values,
    (k) => k.name,
  );

  @override
  Future<List<Label>> listLabels() async => _lookups(stubLabels, (l) => l.name);
}
