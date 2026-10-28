import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:larder_api/larder_api.dart';

import '../format.dart';
import '../urls.dart';

/// The shell every page shares: title, header, main, footer.
class Page extends StatelessComponent {
  const Page({
    required this.title,
    required this.children,
    this.head = const [],
    super.key,
  });

  final String title;
  final List<Component> children;

  /// Extra head elements, such as a JSON-LD script.
  final List<Component> head;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      Document.head(title: '$title · Skullery', children: head),
      header([
        nav([
          ul([
            li([
              a([Component.text('Skullery')], href: '/'),
            ]),
            li([
              a([Component.text('Chefs')], href: '/chef'),
            ]),
            li([
              a([Component.text('Categories')], href: '/category'),
            ]),
            li([
              a([Component.text('Meals')], href: '/meal'),
            ]),
            li([
              a([Component.text('Kitchens')], href: '/kitchen'),
            ]),
            li([
              a([Component.text('Labels')], href: '/label'),
            ]),
          ]),
        ]),
      ]),
      Component.element(tag: 'main', children: children),
      footer([
        p([
          Component.text('Skullery. '),
          a([Component.text('About')], href: '/about'),
          Component.text(' · '),
          a([Component.text('Privacy')], href: '/privacy'),
          Component.text(' · '),
          a([Component.text('Colophon')], href: '/colophon'),
        ]),
      ]),
    ]);
  }
}

/// A JSON-LD script for the head.
Component jsonLdScript(String json) => Component.element(
  tag: 'script',
  attributes: {'type': 'application/ld+json'},
  children: [RawText(json)],
);

/// A list of recipes, title and date, linking to each.
Component recipeList(List<Recipe> recipes) => ul(classes: 'recipe-list', [
  for (final r in recipes)
    li([
      a([Component.text(r.title)], href: recipePath(r.slug)),
      Component.text(' '),
      small(classes: 'meta', [
        Component.text('${formatDate(r.date)} · ${r.chef.name}'),
        if (r.meal != null) Component.text(' · ${r.meal!.name}'),
      ]),
    ]),
]);
