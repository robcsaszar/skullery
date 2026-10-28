import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:larder_api/larder_api.dart';

import 'layout.dart';

/// One kind of lookup: its title, and how to link one entry.
class LookupKind {
  const LookupKind({
    required this.title,
    required this.single,
    required this.path,
  });

  /// Plural, for the collection page: "Chefs".
  final String title;

  /// Singular, for a single page: "Chef".
  final String single;
  final String Function(String slug) path;
}

/// The collection page of one lookup kind: every entry with its count.
class LookupListPage extends StatelessComponent {
  const LookupListPage({required this.kind, required this.entries, super.key});

  final LookupKind kind;

  /// slug, name, recipe count.
  final List<(String, String, int)> entries;

  @override
  Component build(BuildContext context) => Page(
    title: kind.title,
    children: [
      h1([Component.text(kind.title)]),
      ul(classes: 'lookups', [
        for (final (slug, name, count) in entries)
          li([
            a([Component.text(name)], href: kind.path(slug)),
            Component.text(' ($count)'),
          ]),
      ]),
    ],
  );
}

/// The single page of one lookup entry: its recipes.
class LookupPage extends StatelessComponent {
  const LookupPage({
    required this.kind,
    required this.name,
    required this.recipes,
    super.key,
  });

  final LookupKind kind;
  final String name;
  final List<Recipe> recipes;

  @override
  Component build(BuildContext context) => Page(
    title: '$name, ${kind.single.toLowerCase()}',
    children: [
      h1([Component.text(name)]),
      p(classes: 'meta', [
        Component.text('${kind.single} · ${recipes.length} recipes'),
      ]),
      recipeList(recipes),
    ],
  );
}

/// A placeholder page: the title and one line.
class PlaceholderPage extends StatelessComponent {
  const PlaceholderPage({required this.title, super.key});

  final String title;

  @override
  Component build(BuildContext context) => Page(
    title: title,
    children: [
      h1([Component.text(title)]),
      p([
        Component.text(
          'This page is a placeholder. The text comes in a later session.',
        ),
      ]),
    ],
  );
}
