/// The stub core for the site build. The private core has a package of the
/// same name with the same two functions.
library;

import 'dart:io';

import 'package:larder_api/larder_api.dart';
import 'package:larder_stub/larder_stub.dart';

/// The larder the site renders from.
Future<Larder> openLarder() async => const StubLarder();

/// The folder with `legacy/<slug>/<file>` images. The stub has none.
Future<Directory?> legacyImagesDir() async => null;
