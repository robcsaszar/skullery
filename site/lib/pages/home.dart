import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../jsonld.dart';
import '../site_data.dart';
import '../urls.dart';
import 'layout.dart';

/// One page of the collection, newest first.
class HomePage extends StatelessComponent {
  const HomePage({required this.data, required this.page, super.key});

  final SiteData data;
  final int page;

  @override
  Component build(BuildContext context) {
    final recipes = data.page(page);
    return Page(
      title: page == 1 ? 'Recipes' : 'Recipes, page $page',
      head: [jsonLdScript(jsonLdText(itemListJsonLd(recipes, page: page)))],
      children: [
        h1([Component.text('Recipes')]),
        p(classes: 'meta', [
          Component.text(
            '${data.recipes.length} recipes, newest first. Page $page of ${data.pageCount}.',
          ),
        ]),
        recipeList(recipes),
        nav(classes: 'pager', [
          if (page > 1) a([Component.text('Newer')], href: homePath(page - 1)),
          if (page < data.pageCount)
            a([Component.text('Older')], href: homePath(page + 1)),
        ]),
      ],
    );
  }
}
