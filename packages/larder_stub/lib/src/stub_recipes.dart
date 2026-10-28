import 'package:larder_api/larder_api.dart';

// Five invented recipes. Nothing here copies a published recipe.

const _tamsin = Chef(slug: 'tamsin', name: 'tamsin');
const _oskar = Chef(slug: 'oskar', name: 'oskar');

const _breakfast = Meal(slug: 'breakfast', name: 'breakfast');
const _main = Meal(slug: 'main', name: 'main');
const _side = Meal(slug: 'side', name: 'side');
const _dessert = Meal(slug: 'dessert', name: 'dessert');

const _asian = Kitchen(slug: 'asian', name: 'asian');
const _italian = Kitchen(slug: 'italian', name: 'italian');
const _mexican = Kitchen(slug: 'mexican', name: 'mexican');

const _quick = Category(slug: 'quick', name: 'quick');
const _oven = Category(slug: 'oven', name: 'oven');
const _baking = Category(slug: 'baking', name: 'baking');
const _snack = Category(slug: 'snack', name: 'snack');
const _healthyish = Category(slug: 'healthyish', name: 'healthyish');
const _pickling = Category(slug: 'pickling', name: 'pickling');
const _raw = Category(slug: 'raw', name: 'raw');

/// The fixed label list, the same fourteen names the core seeds.
const stubLabels = [
  Label(slug: 'vegetarian', name: 'vegetarian'),
  Label(slug: 'beef', name: 'beef'),
  Label(slug: 'pork', name: 'pork'),
  Label(slug: 'poultry', name: 'poultry'),
  Label(slug: 'duck', name: 'duck'),
  Label(slug: 'seafood', name: 'seafood'),
  Label(slug: 'pasta', name: 'pasta'),
  Label(slug: 'rice', name: 'rice'),
  Label(slug: 'bread', name: 'bread'),
  Label(slug: 'fruit', name: 'fruit'),
  Label(slug: 'nuts', name: 'nuts'),
  Label(slug: 'burger', name: 'burger'),
  Label(slug: 'christmas', name: 'christmas'),
  Label(slug: 'thanksgiving', name: 'thanksgiving'),
];

Label _label(String slug) => stubLabels.firstWhere((l) => l.slug == slug);

Amount _g(double value) => Amount(
  type: AmountType.exact,
  value: value,
  unit: 'g',
  metricValue: value,
  metricUnit: 'g',
);

Amount _ml(double value) => Amount(
  type: AmountType.exact,
  value: value,
  unit: 'ml',
  metricValue: value,
  metricUnit: 'ml',
);

Amount _count(double value) => Amount(type: AmountType.exact, value: value);

/// The five recipes, in no particular order. [StubLarder] sorts them.
final List<Recipe> stubRecipes = List.unmodifiable([
  Recipe(
    slug: 'charred-leek-toast',
    title: 'Charred Leek Toast',
    summary: 'Leeks gone soft and smoky on thick bread.',
    chef: _tamsin,
    meal: _breakfast,
    categories: const [_quick, _snack],
    labels: [_label('vegetarian'), _label('bread')],
    date: DateTime.utc(2026, 3, 2),
    yields: const [Yield(amount: 2, unit: 'servings')],
    groups: [
      IngredientGroup(
        ingredients: [
          Ingredient(amount: _count(2), raw: 'leeks, trimmed and halved'),
          Ingredient(amount: _ml(30), raw: 'olive oil'),
          Ingredient(amount: _count(2), raw: 'thick slices of sourdough'),
          Ingredient(
            amount: _g(40),
            raw: 'soft goat cheese',
            notes: const [Note('or ricotta')],
          ),
          const Ingredient(raw: 'flaky salt and black pepper'),
        ],
      ),
    ],
    steps: const [
      Step(
        text: 'Heat a dry pan until it smokes. Lay the leeks cut side down and leave them for 6 minutes without moving.',
      ),
      Step(
        text:
            'Turn the leeks, add the oil, and cook 4 minutes more until soft.',
      ),
      Step(
        text: 'Toast the bread. Spread the cheese, pile on the leeks, season.',
      ),
    ],
    notes: const [Note('Spring leeks need less time than winter ones.')],
  ),
  Recipe(
    slug: 'miso-butter-mushrooms',
    title: 'Miso Butter Mushrooms',
    summary: 'Roasted mushrooms in a glaze that does all the work.',
    chef: _tamsin,
    meal: _side,
    kitchen: _asian,
    categories: const [_quick, _oven],
    labels: [_label('vegetarian')],
    date: DateTime.utc(2026, 2, 14),
    reviewed: true,
    yields: const [Yield(amount: 4, unit: 'servings')],
    groups: [
      IngredientGroup(
        name: 'mushrooms',
        ingredients: [
          Ingredient(amount: _g(500), raw: 'mixed mushrooms, torn'),
          Ingredient(amount: _ml(15), raw: 'neutral oil'),
        ],
      ),
      IngredientGroup(
        name: 'glaze',
        ingredients: [
          Ingredient(amount: _g(40), raw: 'butter, soft'),
          Ingredient(amount: _g(20), raw: 'white miso'),
          Ingredient(amount: _count(1), raw: 'clove garlic, grated'),
          Ingredient(
            amount: _count(1),
            raw: 'spring onion, sliced',
            notes: const [Note('to finish')],
          ),
        ],
      ),
    ],
    steps: const [
      Step(
        text: 'Heat the oven to 220 °C. Toss the mushrooms with the oil on a tray and roast 15 minutes.',
        temperatureValue: 220,
        temperatureUnit: 'C',
        timeSeconds: 900,
      ),
      Step(text: 'Mash the butter, miso and garlic together.'),
      Step(
        text: 'Stir the glaze through the hot mushrooms and roast 5 minutes more. Top with spring onion.',
        timeSeconds: 300,
      ),
    ],
  ),
  Recipe(
    slug: 'pearl-barley-pea-risotto',
    title: 'Pearl Barley Pea Risotto',
    summary: 'Barley instead of rice: nutty, chewy, forgiving.',
    chef: _oskar,
    meal: _main,
    kitchen: _italian,
    categories: const [_healthyish],
    labels: [_label('vegetarian')],
    date: DateTime.utc(2025, 11, 30),
    creditUrl: 'https://example.com/barley',
    yields: const [Yield(amount: 3, unit: 'servings')],
    groups: [
      IngredientGroup(
        ingredients: [
          Ingredient(amount: _g(250), raw: 'pearl barley, rinsed'),
          Ingredient(amount: _ml(900), raw: 'vegetable stock, hot'),
          Ingredient(amount: _count(1), raw: 'onion, finely chopped'),
          Ingredient(amount: _g(150), raw: 'frozen peas'),
          Ingredient(amount: _g(30), raw: 'parmesan, grated'),
          Ingredient(
            amount: const Amount(type: AmountType.toTaste),
            raw: 'lemon zest',
          ),
        ],
      ),
    ],
    steps: const [
      Step(
        text: 'Soften the onion in a little oil, 8 minutes.',
        timeSeconds: 480,
      ),
      Step(
        text: 'Add the barley and a ladle of stock. Keep adding stock as it is absorbed, about 35 minutes.',
        timeSeconds: 2100,
      ),
      Step(
        text: 'Stir in the peas and parmesan. Rest 2 minutes, finish with lemon zest.',
      ),
    ],
    notes: const [
      Note('Leftovers firm up; loosen with stock when reheating.'),
      Note('Spelt works the same way.'),
    ],
  ),
  Recipe(
    slug: 'apricot-cardamom-cake',
    title: 'Apricot Cardamom Cake',
    summary: 'A one-bowl cake that is better on the second day.',
    chef: _oskar,
    meal: _dessert,
    categories: const [_baking, _oven],
    labels: [_label('fruit'), _label('nuts'), _label('vegetarian')],
    date: DateTime.utc(2026, 1, 9),
    yields: const [Yield(amount: 8, unit: 'pieces')],
    groups: [
      IngredientGroup(
        ingredients: [
          Ingredient(amount: _g(150), raw: 'butter, soft'),
          Ingredient(amount: _g(150), raw: 'sugar'),
          Ingredient(amount: _count(3), raw: 'eggs'),
          Ingredient(amount: _g(100), raw: 'ground almonds'),
          Ingredient(amount: _g(100), raw: 'flour'),
          Ingredient(
            amount: const Amount(type: AmountType.range, value: 6, valueMax: 8),
            raw: 'apricots, halved',
          ),
          Ingredient(amount: _count(8), raw: 'cardamom pods, seeds ground'),
        ],
      ),
    ],
    steps: const [
      Step(
        text: 'Heat the oven to 180 °C. Line a 20 cm tin.',
        temperatureValue: 180,
        temperatureUnit: 'C',
      ),
      Step(
        text: 'Beat the butter and sugar, then the eggs one at a time. Fold in the almonds, flour and cardamom.',
      ),
      Step(
        text: 'Spread in the tin, press the apricots on top cut side up. Bake 40 minutes.',
        timeSeconds: 2400,
      ),
    ],
  ),
  Recipe(
    slug: 'lime-pickled-onions',
    title: 'Lime Pickled Onions',
    summary: 'Pink in twenty minutes. Goes on everything.',
    chef: _tamsin,
    meal: _side,
    kitchen: _mexican,
    categories: const [_pickling, _raw, _quick],
    labels: [_label('vegetarian')],
    date: DateTime.utc(2026, 3, 20),
    yields: const [Yield(amount: 300, unit: 'g')],
    groups: [
      IngredientGroup(
        ingredients: [
          Ingredient(amount: _count(2), raw: 'red onions, sliced thin'),
          Ingredient(amount: _ml(60), raw: 'lime juice'),
          Ingredient(amount: _g(5), raw: 'salt'),
          Ingredient(
            amount: _count(1),
            raw: 'small chilli, sliced',
            optional: true,
          ),
        ],
      ),
    ],
    steps: const [
      Step(text: 'Mix everything in a jar. Press the onions under the juice.'),
      Step(
        text: 'Leave 20 minutes. Keeps a week in the fridge.',
        timeSeconds: 1200,
      ),
    ],
  ),
]);
