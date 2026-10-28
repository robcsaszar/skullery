import 'package:larder_stub/larder_stub.dart';
import 'package:test/test.dart';

void main() {
  const larder = StubLarder();

  test('listRecipes pages newest first', () async {
    final page = await larder.listRecipes();
    expect(page.total, 5);
    expect(page.pageCount, 1);
    expect(page.recipes.map((r) => r.slug), [
      'lime-pickled-onions',
      'charred-leek-toast',
      'miso-butter-mushrooms',
      'apricot-cardamom-cake',
      'pearl-barley-pea-risotto',
    ]);
    final small = await larder.listRecipes(page: 2, pageSize: 2);
    expect(small.recipes.map((r) => r.slug), [
      'miso-butter-mushrooms',
      'apricot-cardamom-cake',
    ]);
    expect(small.pageCount, 3);
    expect((await larder.listRecipes(page: 9)).recipes, isEmpty);
  });

  test(
    'getRecipe finds a recipe with groups, steps and notes in order',
    () async {
      final r = (await larder.getRecipe('miso-butter-mushrooms'))!;
      expect(r.groups.map((g) => g.name), ['mushrooms', 'glaze']);
      expect(r.groups[1].ingredients.first.raw, 'butter, soft');
      expect(r.groups[1].ingredients.first.amount.metricUnit, 'g');
      expect(r.steps, hasLength(3));
      expect(r.steps[0].temperatureValue, 220);
      expect(r.reviewed, isTrue);
      expect(r.kitchen?.slug, 'asian');
      expect(await larder.getRecipe('nope'), isNull);
    },
  );

  test('every list method returns something', () async {
    expect(await larder.listByChef('tamsin'), hasLength(3));
    expect(await larder.listByCategory('quick'), hasLength(3));
    expect(await larder.listByMeal('side'), hasLength(2));
    expect(await larder.listByKitchen('italian'), hasLength(1));
    expect(await larder.listByLabel('vegetarian'), hasLength(5));
    expect((await larder.listChefs()).map((c) => c.slug), ['oskar', 'tamsin']);
    expect((await larder.listCategories()).map((c) => c.slug), [
      'baking',
      'healthyish',
      'oven',
      'pickling',
      'quick',
      'raw',
      'snack',
    ]);
    expect((await larder.listMeals()).map((m) => m.slug), [
      'breakfast',
      'dessert',
      'main',
      'side',
    ]);
    expect((await larder.listKitchens()).map((k) => k.slug), [
      'asian',
      'italian',
      'mexican',
    ]);
    expect(await larder.listLabels(), hasLength(14));
    expect(await larder.listByChef('nobody'), isEmpty);
  });

  test('the stub has no images', () async {
    final page = await larder.listRecipes();
    expect(page.recipes.every((r) => r.images.isEmpty), isTrue);
  });
}
