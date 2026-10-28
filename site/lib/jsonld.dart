import 'dart:convert';

import 'package:larder_api/larder_api.dart';

import 'format.dart';
import 'urls.dart';

/// schema.org Recipe for one recipe page.
Map<String, Object?> recipeJsonLd(Recipe r) => {
  '@context': 'https://schema.org',
  '@type': 'Recipe',
  'name': r.title,
  'url': absolute(recipePath(r.slug)),
  if (r.summary != null) 'description': r.summary,
  if (r.images.isNotEmpty)
    'image': [for (final i in r.images) absolute(imagePath(i.key))],
  'author': {'@type': 'Person', 'name': r.chef.name},
  'datePublished': formatDate(r.date),
  if (r.categories.isNotEmpty)
    'recipeCategory': [for (final c in r.categories) c.name],
  if (r.kitchen != null) 'recipeCuisine': r.kitchen!.name,
  if (r.labels.isNotEmpty) 'keywords': r.labels.map((l) => l.name).join(', '),
  if (r.yields.isNotEmpty) 'recipeYield': formatYield(r.yields.first),
  'recipeIngredient': [
    for (final g in r.groups)
      for (final i in g.ingredients) formatIngredient(i),
  ],
  'recipeInstructions': [
    for (final s in r.steps) {'@type': 'HowToStep', 'text': s.text},
  ],
};

/// schema.org ItemList for one page of the collection.
Map<String, Object?> itemListJsonLd(
  List<Recipe> recipes, {
  required int page,
}) => {
  '@context': 'https://schema.org',
  '@type': 'ItemList',
  'url': absolute(homePath(page)),
  'numberOfItems': recipes.length,
  'itemListElement': [
    for (var i = 0; i < recipes.length; i++)
      {
        '@type': 'ListItem',
        'position': i + 1,
        'url': absolute(recipePath(recipes[i].slug)),
        'name': recipes[i].title,
      },
  ],
};

/// JSON for a script tag. `</` is escaped so no text can close the tag.
String jsonLdText(Map<String, Object?> data) =>
    jsonEncode(data).replaceAll('</', r'<\/');
