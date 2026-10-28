import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'pages/collections.dart';
import 'pages/home.dart';
import 'pages/recipe.dart';
import 'routes.dart';
import 'site_data.dart';
import 'urls.dart';

const _chefKind = LookupKind(title: 'Chefs', single: 'Chef', path: chefPath);
const _categoryKind = LookupKind(
  title: 'Categories',
  single: 'Category',
  path: categoryPath,
);
const _mealKind = LookupKind(title: 'Meals', single: 'Meal', path: mealPath);
const _kitchenKind = LookupKind(
  title: 'Kitchens',
  single: 'Kitchen',
  path: kitchenPath,
);
const _labelKind = LookupKind(
  title: 'Labels',
  single: 'Label',
  path: labelPath,
);

/// The router: one route per path in [sitePaths], so the static build
/// renders every page. Routes carry no path parameters on purpose.
class App extends StatelessComponent {
  const App({required this.data, super.key});

  final SiteData data;

  @override
  Component build(BuildContext context) {
    final d = data;
    return Router(
      routes: [
        for (var p = 1; p <= d.pageCount; p++)
          Route(
            path: homePath(p),
            builder: (_, _) => HomePage(data: d, page: p),
          ),
        for (final r in d.recipes)
          Route(
            path: recipePath(r.slug),
            builder: (_, _) => RecipePage(recipe: r),
          ),
        Route(
          path: '/chef',
          builder: (_, _) => LookupListPage(
            kind: _chefKind,
            entries: [
              for (final c in d.chefs)
                (c.slug, c.name, d.byChef(c.slug).length),
            ],
          ),
        ),
        for (final c in d.chefs)
          Route(
            path: chefPath(c.slug),
            builder: (_, _) => LookupPage(
              kind: _chefKind,
              name: c.name,
              recipes: d.byChef(c.slug),
            ),
          ),
        Route(
          path: '/category',
          builder: (_, _) => LookupListPage(
            kind: _categoryKind,
            entries: [
              for (final c in d.categories)
                (c.slug, c.name, d.byCategory(c.slug).length),
            ],
          ),
        ),
        for (final c in d.categories)
          Route(
            path: categoryPath(c.slug),
            builder: (_, _) => LookupPage(
              kind: _categoryKind,
              name: c.name,
              recipes: d.byCategory(c.slug),
            ),
          ),
        Route(
          path: '/meal',
          builder: (_, _) => LookupListPage(
            kind: _mealKind,
            entries: [
              for (final m in d.meals)
                (m.slug, m.name, d.byMeal(m.slug).length),
            ],
          ),
        ),
        for (final m in d.meals)
          Route(
            path: mealPath(m.slug),
            builder: (_, _) => LookupPage(
              kind: _mealKind,
              name: m.name,
              recipes: d.byMeal(m.slug),
            ),
          ),
        Route(
          path: '/kitchen',
          builder: (_, _) => LookupListPage(
            kind: _kitchenKind,
            entries: [
              for (final k in d.kitchens)
                (k.slug, k.name, d.byKitchen(k.slug).length),
            ],
          ),
        ),
        for (final k in d.kitchens)
          Route(
            path: kitchenPath(k.slug),
            builder: (_, _) => LookupPage(
              kind: _kitchenKind,
              name: k.name,
              recipes: d.byKitchen(k.slug),
            ),
          ),
        Route(
          path: '/label',
          builder: (_, _) => LookupListPage(
            kind: _labelKind,
            entries: [
              for (final l in d.labels)
                (l.slug, l.name, d.byLabel(l.slug).length),
            ],
          ),
        ),
        for (final l in d.labels)
          Route(
            path: labelPath(l.slug),
            builder: (_, _) => LookupPage(
              kind: _labelKind,
              name: l.name,
              recipes: d.byLabel(l.slug),
            ),
          ),
        for (final e in placeholderPages.entries)
          Route(
            path: e.key,
            builder: (_, _) => PlaceholderPage(title: e.value),
          ),
      ],
    );
  }
}
