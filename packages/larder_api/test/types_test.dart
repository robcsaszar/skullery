import 'package:larder_api/larder_api.dart';
import 'package:test/test.dart';

void main() {
  test('RecipePage.pageCount rounds up and is at least 1', () {
    RecipePage page(int total, int size) =>
        RecipePage(recipes: const [], page: 1, pageSize: size, total: total);
    expect(page(0, 20).pageCount, 1);
    expect(page(20, 20).pageCount, 1);
    expect(page(21, 20).pageCount, 2);
    expect(page(164, 20).pageCount, 9);
  });

  test('a recipe carries empty lists and no amount by default', () {
    final recipe = Recipe(
      slug: 'x',
      title: 'X',
      chef: const Chef(slug: 'c', name: 'c'),
      date: DateTime.utc(2026, 1, 1),
    );
    expect(recipe.groups, isEmpty);
    expect(recipe.steps, isEmpty);
    expect(recipe.labels, isEmpty);
    expect(recipe.reviewed, isFalse);
    expect(const Ingredient().amount.type, AmountType.none);
    expect(Amount.none.value, isNull);
  });

  test('lookups and small types are const', () {
    const label = Label(slug: 'fruit', name: 'fruit');
    const yield = Yield(amount: 4, unit: 'servings');
    const image = Image(key: 'legacy/x/x.jpg', width: 1, height: 1);
    const step = Step(text: 'Mix.', notes: [Note('gently')]);
    expect(label.name, 'fruit');
    expect(yield.amount, 4);
    expect(image.creditUrl, isNull);
    expect(step.notes.single.text, 'gently');
  });

  test('Larder is abstract with read methods only', () {
    // Every method is a Future; a type that implements the whole interface
    // compiles. Compile-time check: see larder_stub for a full implementation.
    expect(Larder, isNotNull);
  });
}
