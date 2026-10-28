/// The server entry point. In static mode `jaspr build` runs it once,
/// requests every route the router registers and writes the HTML files.
library;

import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:larder_select/larder_select.dart';

import 'app.dart';
import 'site_data.dart';

/// Read once per process, shared by every rendered page.
final Future<SiteData> _data = openLarder().then(SiteData.load);

void main() {
  Jaspr.initializeApp();
  runApp(
    Document(
      lang: 'en',
      head: [link(href: '/styles.css', rel: 'stylesheet')],
      body: AsyncBuilder(builder: (_) async => App(data: await _data)),
    ),
  );
}
