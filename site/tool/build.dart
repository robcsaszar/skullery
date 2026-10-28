/// Builds the site. Run from the repo root:
///
///   dart run site/tool/build.dart                                      stub core
///   LARDER=sqlite LARDER_PATH=<private repo path> dart run site/tool/build.dart  real core (the root README has the path)
///
/// LARDER=sqlite writes the gitignored pubspec_overrides.yaml at the repo
/// root (pointing larder_select at the private core's package of that
/// name) and copies the legacy images into site/web/images/legacy. The
/// stub build removes both. Then `dart pub get` and the Jaspr static build.
library;

import 'dart:io';

Future<void> main() async {
  final root = Directory.current;
  final site = Directory('${root.path}/site');
  if (!File('${site.path}/pubspec.yaml').existsSync()) {
    stderr.writeln('run from the repo root');
    exit(2);
  }
  final mode = Platform.environment['LARDER'] ?? 'stub';
  final overrides = File('${root.path}/pubspec_overrides.yaml');
  final images = Directory('${site.path}/web/images/legacy');

  switch (mode) {
    case 'stub':
      if (overrides.existsSync()) overrides.deleteSync();
      if (images.existsSync()) images.deleteSync(recursive: true);
    case 'sqlite':
      final larderPath = Platform.environment['LARDER_PATH'];
      if (larderPath == null) {
        stderr.writeln(
          'LARDER=sqlite needs LARDER_PATH, the path to the private core repo relative to this repo root',
        );
        exit(2);
      }
      overrides.writeAsStringSync(
        '# Written by site/tool/build.dart for LARDER=sqlite. Gitignored.\n'
        'dependency_overrides:\n'
        '  larder_select:\n'
        '    path: $larderPath/packages/select\n',
      );
      final source = Directory('${root.path}/$larderPath/build/images/legacy');
      if (images.existsSync()) images.deleteSync(recursive: true);
      if (source.existsSync()) {
        images.createSync(recursive: true);
        await _copyTree(source, images);
        stdout.writeln('copied images from ${source.path}');
      } else {
        stdout.writeln('no legacy images at ${source.path}');
      }
    default:
      stderr.writeln('LARDER must be stub or sqlite, not $mode');
      exit(2);
  }

  stdout.writeln('core: $mode');
  await _run('dart', ['pub', 'get'], root.path);
  await _run('dart', ['run', 'jaspr_cli:jaspr', 'build'], site.path);
  stdout.writeln('built site/build/jaspr with the $mode core');
}

Future<void> _copyTree(Directory from, Directory to) async {
  await for (final entity in from.list(recursive: true)) {
    final relative = entity.path.substring(from.path.length + 1);
    if (entity is Directory) {
      Directory('${to.path}/$relative').createSync(recursive: true);
    } else if (entity is File) {
      File('${to.path}/$relative').parent.createSync(recursive: true);
      entity.copySync('${to.path}/$relative');
    }
  }
}

Future<void> _run(String cmd, List<String> args, String cwd) async {
  stdout.writeln('> $cmd ${args.join(' ')}  (in $cwd)');
  // jaspr_cli wants `which dart` to sit inside the SDK folder, which a
  // Homebrew symlink does not; the running SDK's own bin folder goes first.
  // JASPR_NO_COMPLETION keeps the CLI from writing shell completion files.
  final sdkBin = File(Platform.resolvedExecutable).parent.path;
  final env = {
    ...Platform.environment,
    'PATH': '$sdkBin:${Platform.environment['PATH'] ?? ''}',
    'JASPR_NO_COMPLETION': '1',
  };
  final p = await Process.start(
    cmd,
    args,
    workingDirectory: cwd,
    environment: env,
    mode: ProcessStartMode.inheritStdio,
  );
  final code = await p.exitCode;
  if (code != 0) exit(code);
}
