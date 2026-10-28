/// The site's own addresses. One place, so pages and JSON-LD agree.
library;

const siteOrigin = 'https://skullery.net';

String recipePath(String slug) => '/recipe/$slug';
String chefPath(String slug) => '/chef/$slug';
String categoryPath(String slug) => '/category/$slug';
String mealPath(String slug) => '/meal/$slug';
String kitchenPath(String slug) => '/kitchen/$slug';
String labelPath(String slug) => '/label/$slug';
String homePath(int page) => page == 1 ? '/' : '/page/$page';

/// Where an image key is served from.
String imagePath(String key) => '/images/$key';

String absolute(String path) => '$siteOrigin$path';
