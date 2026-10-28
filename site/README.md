# site

The Skullery site: every page is HTML at build time, built with Jaspr in static mode from the `Larder` read interface. No design yet: semantic HTML and one small stylesheet.

Run (from the repo root):

```
dart run site/tool/build.dart                                   # stub core, 5 invented recipes
LARDER=sqlite LARDER_PATH=<path to the private repo> dart run site/tool/build.dart   # real core; the root README has the path
```

The output is in site/build/jaspr. Serve it with any static server. Test: `dart test` in this folder (runs against the stub).
