# larder_api

The public read interface of the larder, Skullery's core: the abstract class `Larder` and the immutable types a frontend renders (Recipe, IngredientGroup, Ingredient, Amount, Step, Note, Yield, Image, Chef, Category, Meal, Kitchen, Label). Pure Dart, no dependency beyond the SDK, no SQL, no logic. The private core and the public stub both implement `Larder`.

Run: nothing to run; it is a library. Test: `dart test` in this folder.
