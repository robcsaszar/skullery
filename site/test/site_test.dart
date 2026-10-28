import 'dart:convert';

import 'package:larder_api/larder_api.dart';
import 'package:larder_stub/larder_stub.dart';
import 'package:skullery_site/format.dart';
import 'package:skullery_site/jsonld.dart';
import 'package:skullery_site/routes.dart';
import 'package:skullery_site/site_data.dart';
import 'package:test/test.dart';

void main() {
  late SiteData data;
  setUpAll(() async => data = await SiteData.load(const StubLarder()));

  test('SiteData loads the whole collection newest first', () {
    expect(data.recipes.map((r) => r.slug).first, 'lime-pickled-onions');
    expect(data.recipes, hasLength(5));
    expect(data.pageCount, 1);
    expect(data.page(2), isEmpty);
    expect(data.byKitchen('italian').single.slug, 'pearl-barley-pea-risotto');
    expect(data.labels, hasLength(14));
  });

  test('sitePaths lists every page once', () {
    final paths = sitePaths(data);
    expect(paths.first, '/');
    expect(paths, contains('/recipe/charred-leek-toast'));
    expect(paths, contains('/chef/tamsin'));
    expect(paths, contains('/kitchen/italian'));
    expect(paths, contains('/label/vegetarian'));
    expect(paths, contains('/404.html'));
    expect(paths.toSet().length, paths.length);
    expect(
      paths,
      hasLength(1 + 5 + 1 + 2 + 1 + 7 + 1 + 4 + 1 + 3 + 1 + 14 + 10),
    );
  });

  test('formatAmount reads like a cook', () {
    expect(formatNumber(2), '2');
    expect(formatNumber(1.5), '1½');
    expect(formatNumber(0.25), '¼');
    expect(formatNumber(2.3333), '2⅓');
    expect(formatNumber(2.37), '2.37');
    expect(formatAmount(Amount.none), '');
    expect(formatAmount(const Amount(type: AmountType.toTaste)), 'to taste');
    expect(
      formatAmount(
        const Amount(
          type: AmountType.exact,
          value: 110,
          unit: 'g',
          metricValue: 110,
          metricUnit: 'g',
        ),
      ),
      '110 g',
    );
    expect(
      formatAmount(
        const Amount(
          type: AmountType.exact,
          value: 0.5,
          unit: 'kg',
          metricValue: 500,
          metricUnit: 'g',
        ),
      ),
      '½ kg (500 g)',
    );
    expect(
      formatAmount(const Amount(type: AmountType.range, value: 6, valueMax: 8)),
      '6–8',
    );
    expect(
      formatIngredient(const Ingredient(raw: 'for garnish:')),
      'for garnish:',
    );
  });

  test('JSON-LD has the schema.org fields', () {
    final r = data.bySlug('miso-butter-mushrooms')!;
    final ld = recipeJsonLd(r);
    expect(ld['@type'], 'Recipe');
    expect(ld['name'], 'Miso Butter Mushrooms');
    expect(ld['recipeCuisine'], 'asian');
    expect(ld['recipeYield'], '4 servings');
    expect(
      (ld['recipeIngredient'] as List).first,
      '500 g mixed mushrooms, torn',
    );
    expect((ld['recipeInstructions'] as List), hasLength(3));
    expect(ld.containsKey('image'), isFalse);
    final list = itemListJsonLd(data.page(1), page: 1);
    expect((list['itemListElement'] as List), hasLength(5));
    final text = jsonLdText({'x': '</script>'});
    expect(text, isNot(contains('</script>')));
    expect(jsonDecode(text), {'x': '</script>'});
  });
}
