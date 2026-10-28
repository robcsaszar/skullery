# larder_select

The one seam where the site chooses its core. This package opens the stub (`openLarder()` returns a `StubLarder`, `legacyImagesDir()` returns null). The private repo has a package of the same name over the real core; the README at the repo root shows the gitignored override that swaps it in. It is not a workspace member on purpose: pub cannot override a workspace member, it can override a plain path dependency.

Run: nothing to run. Test: covered by the site tests over the stub.
