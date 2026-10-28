import 'site_data.dart';
import 'urls.dart';

/// The placeholder pages: path and title.
const placeholderPages = {
  '/about': 'About',
  '/privacy': 'Privacy',
  '/terms': 'Terms',
  '/cookies': 'Cookies',
  '/open': 'Open',
  '/status': 'Status',
  '/colophon': 'Colophon',
  '/faq': 'FAQ',
  '/404.html': 'Not found',
  '/500.html': 'Something broke',
};

/// Every path the static build renders, in a fixed order. The router builds
/// one route per path; this list is what the tests check.
List<String> sitePaths(SiteData data) => [
  for (var p = 1; p <= data.pageCount; p++) homePath(p),
  for (final r in data.recipes) recipePath(r.slug),
  '/chef',
  for (final c in data.chefs) chefPath(c.slug),
  '/category',
  for (final c in data.categories) categoryPath(c.slug),
  '/meal',
  for (final m in data.meals) mealPath(m.slug),
  '/kitchen',
  for (final k in data.kitchens) kitchenPath(k.slug),
  '/label',
  for (final l in data.labels) labelPath(l.slug),
  ...placeholderPages.keys,
];
