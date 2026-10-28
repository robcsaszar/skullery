/// The types a frontend renders. Every field is final and every list is in
/// display order, resolved from places by the implementation. A reader never
/// changes a list it receives.
library;

/// How an ingredient amount was entered.
enum AmountType { exact, range, toTaste, none }

/// The amount of an ingredient: what was entered, and the metric reading of it
/// when the entered unit maps to one.
class Amount {
  const Amount({
    this.type = AmountType.none,
    this.value,
    this.valueMax,
    this.unit,
    this.metricValue,
    this.metricValueMax,
    this.metricUnit,
  });

  /// No amount at all, for lines such as "for garnish:".
  static const Amount none = Amount();

  final AmountType type;
  final double? value;

  /// The upper end of a range.
  final double? valueMax;
  final String? unit;
  final double? metricValue;
  final double? metricValueMax;
  final String? metricUnit;
}

/// Who wrote a recipe.
class Chef {
  const Chef({required this.slug, required this.name});
  final String slug;
  final String name;
}

/// A category such as quick, oven or baking. A recipe has any number.
class Category {
  const Category({required this.slug, required this.name});
  final String slug;
  final String name;
}

/// A meal such as breakfast, main or dessert. A recipe has at most one.
class Meal {
  const Meal({required this.slug, required this.name});
  final String slug;
  final String name;
}

/// A kitchen such as italian or mexican. A recipe has at most one.
class Kitchen {
  const Kitchen({required this.slug, required this.name});
  final String slug;
  final String name;
}

/// A label from the fixed list, such as vegetarian or seafood.
class Label {
  const Label({required this.slug, required this.name});
  final String slug;
  final String name;
}

/// A note on a recipe, an ingredient or a step.
class Note {
  const Note(this.text);
  final String text;
}

/// What a recipe makes: an amount of a unit such as servings or pieces.
class Yield {
  const Yield({required this.amount, required this.unit});
  final double amount;
  final String unit;
}

/// A recipe image. [key] is the path in the image store, such as
/// `legacy/<slug>/<file>`; the frontend turns it into a URL.
class Image {
  const Image({
    required this.key,
    required this.width,
    required this.height,
    this.creditText,
    this.creditUrl,
  });

  final String key;
  final int width;
  final int height;
  final String? creditText;
  final String? creditUrl;
}

/// One ingredient line.
class Ingredient {
  const Ingredient({
    this.amount = Amount.none,
    this.item,
    this.state,
    this.optional = false,
    this.raw,
    this.notes = const [],
  });

  final Amount amount;

  /// The item name, once the line has been split. Null until then.
  final String? item;

  /// The state of the item, such as chopped or cold, once split.
  final String? state;
  final bool optional;

  /// The unsplit text after the amount and the unit.
  final String? raw;
  final List<Note> notes;
}

/// A named or unnamed group of ingredients, in display order.
class IngredientGroup {
  const IngredientGroup({
    this.name,
    this.unitSystem,
    required this.ingredients,
  });

  final String? name;
  final String? unitSystem;
  final List<Ingredient> ingredients;
}

/// One step, in display order within its recipe.
class Step {
  const Step({
    required this.text,
    this.action,
    this.temperatureValue,
    this.temperatureUnit,
    this.timeSeconds,
    this.notes = const [],
  });

  final String text;

  /// The action verb, once the step has been split. Null until then.
  final String? action;
  final double? temperatureValue;
  final String? temperatureUnit;
  final int? timeSeconds;
  final List<Note> notes;
}

/// A recipe with everything a page needs, resolved: lookups are objects, not
/// ids, and groups, ingredients and steps are in display order.
class Recipe {
  const Recipe({
    required this.slug,
    required this.title,
    this.summary,
    required this.chef,
    this.kitchen,
    this.meal,
    this.categories = const [],
    this.labels = const [],
    this.creditUrl,
    this.reviewed = false,
    required this.date,
    this.images = const [],
    this.yields = const [],
    this.groups = const [],
    this.steps = const [],
    this.notes = const [],
  });

  final String slug;
  final String title;

  /// The one-line description.
  final String? summary;
  final Chef chef;
  final Kitchen? kitchen;
  final Meal? meal;
  final List<Category> categories;
  final List<Label> labels;

  /// Where the recipe came from, when it was adapted from somewhere.
  final String? creditUrl;

  /// False until a cook has checked the parsed recipe against the original.
  final bool reviewed;

  /// The publication date.
  final DateTime date;
  final List<Image> images;
  final List<Yield> yields;
  final List<IngredientGroup> groups;
  final List<Step> steps;
  final List<Note> notes;
}

/// One page of the recipe collection.
class RecipePage {
  const RecipePage({
    required this.recipes,
    required this.page,
    required this.pageSize,
    required this.total,
  });

  final List<Recipe> recipes;

  /// 1-based.
  final int page;
  final int pageSize;

  /// Recipes in the whole collection.
  final int total;

  /// Pages in the whole collection, at least 1.
  int get pageCount => total == 0 ? 1 : (total + pageSize - 1) ~/ pageSize;
}
