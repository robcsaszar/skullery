import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:larder_api/larder_api.dart';

import '../format.dart';
import '../jsonld.dart';
import '../urls.dart';
import 'layout.dart';

/// One recipe.
class RecipePage extends StatelessComponent {
  const RecipePage({required this.recipe, super.key});

  final Recipe recipe;

  @override
  Component build(BuildContext context) {
    final r = recipe;
    return Page(
      title: r.title,
      head: [jsonLdScript(jsonLdText(recipeJsonLd(r)))],
      children: [
        article([
          h1([Component.text(r.title)]),
          if (!r.reviewed)
            p([
              small(classes: 'unreviewed', [
                Component.text('not yet reviewed'),
              ]),
            ]),
          if (r.summary != null) p([Component.text(r.summary!)]),
          for (final i in r.images)
            figure([
              img(
                src: imagePath(i.key),
                alt: r.title,
                width: i.width,
                height: i.height,
              ),
              if (i.creditText != null)
                figcaption([
                  Component.text('Image: '),
                  if (i.creditUrl != null)
                    a([Component.text(i.creditText!)], href: i.creditUrl!)
                  else
                    Component.text(i.creditText!),
                ]),
            ]),
          dl(classes: 'meta', [
            dt([Component.text('Chef')]),
            dd([
              a([Component.text(r.chef.name)], href: chefPath(r.chef.slug)),
            ]),
            dt([Component.text('Date')]),
            dd([Component.text(formatDate(r.date))]),
            if (r.meal != null) ...[
              dt([Component.text('Meal')]),
              dd([
                a([Component.text(r.meal!.name)], href: mealPath(r.meal!.slug)),
              ]),
            ],
            if (r.kitchen != null) ...[
              dt([Component.text('Kitchen')]),
              dd([
                a([
                  Component.text(r.kitchen!.name),
                ], href: kitchenPath(r.kitchen!.slug)),
              ]),
            ],
            if (r.categories.isNotEmpty) ...[
              dt([Component.text('Categories')]),
              dd([
                for (final c in r.categories) ...[
                  a([Component.text(c.name)], href: categoryPath(c.slug)),
                  Component.text(' '),
                ],
              ]),
            ],
            if (r.labels.isNotEmpty) ...[
              dt([Component.text('Labels')]),
              dd([
                for (final l in r.labels) ...[
                  a([Component.text(l.name)], href: labelPath(l.slug)),
                  Component.text(' '),
                ],
              ]),
            ],
            if (r.yields.isNotEmpty) ...[
              dt([Component.text('Yield')]),
              dd([Component.text(r.yields.map(formatYield).join(', '))]),
            ],
            if (r.creditUrl != null) ...[
              dt([Component.text('Credit')]),
              dd([
                a([Component.text(r.creditUrl!)], href: r.creditUrl!),
              ]),
            ],
          ]),
          h2([Component.text('Ingredients')]),
          for (final g in r.groups) ...[
            if (g.name != null) h3([Component.text(g.name!)]),
            ul([
              for (final i in g.ingredients)
                li([
                  if (i.amount.type != AmountType.none) ...[
                    span(classes: 'amount', [
                      Component.text(formatAmount(i.amount)),
                    ]),
                    Component.text(' '),
                  ],
                  Component.text(i.raw ?? i.item ?? ''),
                  if (i.optional) Component.text(' (optional)'),
                  for (final n in i.notes) ...[
                    Component.text(' '),
                    em([Component.text(n.text)]),
                  ],
                ]),
            ]),
          ],
          h2([Component.text('Steps')]),
          ol([
            for (final s in r.steps)
              li([
                Component.text(s.text),
                for (final n in s.notes) ...[
                  Component.text(' '),
                  em([Component.text(n.text)]),
                ],
              ]),
          ]),
          if (r.notes.isNotEmpty) ...[
            h2([Component.text('Notes')]),
            ul([
              for (final n in r.notes) li([Component.text(n.text)]),
            ]),
          ],
        ]),
      ],
    );
  }
}
