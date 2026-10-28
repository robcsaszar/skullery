# The old site: theskullery

What the old Jekyll site at theskullery.net was, read from its repo on 2026-10-28. Facts only, as input for the design session. Paths are inside the old repo.

## Build and structure

- Jekyll with Kramdown, no plugins, built by `bundle exec jekyll build` into `_site`, hosted on Netlify. Basscss for utilities, one 2310-line `css/main.scss` with front matter so Jekyll compiles it.
- Collections: recipes (164 folders under `_recipes/<slug>/`, each with `<slug>.md` and `<slug>.jpg`), chef, meal, components. Category and tag pages are plain pages, not collections.
- Pagination on the home page: 20 recipes per page, newest first, at `/recipes/:num/`.
- Layouts: `default` (shell with an update notice), `default-recipe` (narrow shell), `recipe`, `categorypage`, `tagpage`, `mealpage`, `chefpage`; `page` and `post` unused.
- Includes: `head` (meta, OpenGraph, CSS, jQuery, manifest, analytics), `header`, `header-recipe` (logo only), `footer` (about text and links), `lazyload` (echo.js), `nutritional-information` (table, not included by the recipe layout), four `collect*` aggregation snippets that nothing references.

## Page types

| Page | Path | Layout | Shows |
|---|---|---|---|
| Home | `/` | default | paginated recipe grid, search box (simple-jekyll-search over `search.json`), "Browse random" (`random.json`), "Submit recipe" |
| Recipe | `/recipes/<slug>` | recipe | see below |
| Categories, Tags, Chefs, Meals | `/categories`, `/tags` (nav label "Cuisines"), `/chefs`, `/meals` | default-recipe | full recipe list grouped by that field |
| Category, Tag, Meal, Chef | `/category/<x>` (17), `/tag/<x>` (19), `/meal/<x>` (5), `/chef/<x>` (10, one is `test`) | categorypage, tagpage, mealpage, chefpage | the recipes with that value, alphabetical, with the other values of the same kind |
| About | `/about` | default | text and an image |
| Favorites | `/favorites` | default | the saved recipes, from localStorage (`js/favorites.js`), with export, import and clear |
| Submit | `/submit` | default | a Netlify form |
| Insta | `/insta` | default-recipe | Instagram story maker (html2canvas) |
| Privacy | `/privacy` | default-recipe | static text |
| 404 | `/404` | default-recipe | a Giphy image and a home link |
| Offline | `offline.html` | none | unlinked PWA template |

Also: `recipes.json`, `search.json`, `random.json` (Liquid-generated), `manifest.json` (standalone, start_url `/?source=pwa`), `sw.js` (unregisters itself and clears caches; its registration is commented out), `robots.txt` (disallows Twitterbot only). No sitemap, no RSS or Atom feed.

## The recipe page

Order from top to bottom:

1. Image (lazy loaded) with the image credit as a camera icon with a tooltip, and the favorites button (only when the recipe has both an image and an image credit).
2. Title (h1), then the one-line description from the markdown body.
3. Meta row: categories, tags, chef, time, meal, each as a badge linking to its page.
4. Two columns: ingredients (with the servings input inside the heading) and directions. Then Notes, only when the front matter has `notes`.
5. Clap button ("Clap if you liked this recipe!"): changes its text to "Thank you!", stores nothing.
6. Share row: Facebook, Instagram story (html2canvas renders an off-screen capture area to a PNG download), Twitter, Reddit, Pinterest (page URL and image URL), copy URL (clipboard.js, `window.prompt` fallback on Safari).
7. Related: up to four recipes sharing at least two tags, computed in Liquid.
8. Credit modal, only when `credit` is set: "Credit where credit is due." / "Thank you for being here, check out more recipes on the website where we found this one." / "Go to original recipe".

Features in JavaScript (`js/`): `dynamicingredients.js`, `shoppinglist.js`, `shareurl.js`, `favoriting.js`, `clapshout.js`, `instagramstory.js`, plus `html2canvas.js`, remote applause-button and clipboard.js 1.5.10 from CDNs.

- Scaling: `#servings-count` input, `data-base-servings` from the front matter (default 1, step 0.5). Each ingredient `li` carries `data-quantity`, `data-unit`, `data-text`. On change, scale = servings / base; each `li`'s `<p>` is rewritten with the scaled amount (common fractions as unicode entities, otherwise three decimals) + unit + text. Ingredients without a quantity stay as they are.
- Checklist: a checkbox appended to every ingredient `li`; click toggles checked/unchecked classes and scrolls by the item height. Nothing is stored; state is lost on reload.
- Copy ingredients: collects the text of unchecked ingredients, hides `<em>` notes while reading, writes to a hidden `#output`, `document.execCommand('copy')`; the button text becomes "Copied!". Only unchecked items are copied. The button sits directly inside the `<ul>`.
- Favorites: localStorage key is the full HTML anchor string of the recipe card (`<a class="page--listitem" href=...>` + SVG + `<h1>`), value `favorite`. The favorites page lists all keys, exports `btoa(JSON.stringify(localStorage))`, imports and clears. The tooltip says "saved as cookies".
- Print, wake lock: none.

Structured data: microdata only, no JSON-LD. `itemscope itemtype="http://schema.org/Recipe"` with name, image, description, recipeIngredient (inside recipeIngredientGroup), recipeInstructions with HowToSection and HowToStep (on `li`, untyped). Missing: recipeYield, totalTime, author, recipeCategory, keywords, nutrition.

Meta (`head.html`, all pages): site-wide description, `og:type website`, absolute `og:url`, `og:title "theSkullery | {title}"`, site-wide `og:description`, site-wide `og:image /assets/theSkullery_tile.png` (never the recipe photo). `twitter:*` tags use `property=` rather than `name=`.

Markup issues seen: a `<dt>` closed with `</li>` (recipe.html line 168); the copy button inside a `<ul>`; the credit link takes the last value of `page.credit`; `head.html` preloads `assets/fonts/inter.css` with `as="font"`.

## Design tokens

All tokens are CSS custom properties on `:root` in `css/main.scss` (lines 3 to 79). No SCSS variables, no mixins, no dark mode.

Colours:

- `--mainColor #e83151` (brand red), with 7 steps from `--mainColor-darkest #730d1e` to `--mainColor-lightest #f7bac4`. Used for `::selection` and accents.
- `--greenAccent #216869` (range `#061313` to `#7fd5d7`): the chef badge.
- `--blueAccent #18469a` (range `#030a16` to `#91b1ee`).
- `--yellowAccent #e6cc56` (range `#62520f` to `#faf4dc`).
- `--warning #ff9f1a` (range `#804a00` to `#ffdfb3`): the tag badge.
- `--danger #f64741` (range `#970c07` to `#fdd5d3`): the category badge (text danger-darkest on danger-lightest).
- `--success #4dba45` (range `#1f4a1c` to `#b8d7d8`).
- Greys: `--grey-darkest #1a1a1a`, `--grey-darker #333333`, `--grey-dark #4d4d4d`, `--grey #666666`, `--grey-light #808080`, `--grey-lighter #a8a8a8`, `--grey-lightest #e8e8e8`; `--black #000000`, `--white #ffffff`.
- `--background #efeeee` (page background).
- Sticky note: `--stickynoteColor-light #f3f1d6`, `--stickynoteColor-dark #efecc7` (gradient).
- Social: `--facebook #4267b2`, `--twitter #1da1f2`, `--reddit #ff4301`, `--pinterest #e60023`.
- Hardcoded outside the tokens: `#007fff`, `#222`, `#fff`, `#e83151` (the `.skullery` class).

Fonts:

- Family: Inter, Helvetica, sans-serif (body and headings). Monospace in two places.
- Self-hosted Inter in `assets/fonts/inter.css`: woff2 and woff, weights 100 to 900 with italics, plus the variable font files. No Google Fonts.
- Weights in use: 100, 300, 500 (badges, buttons), 700.
- Body 1rem, line-height 1.5; headings line-height 1.1. h1 2.25rem, h2 2rem, h3 1.5rem, h4 1.3rem. Small text 0.875rem, 0.8rem, 0.75rem (badges), 0.7rem. Basscss scale 2 / 1.5 / 1.25 / 1 / .875 / .75rem.

Spacing, shape, elevation:

- Container max-width 64em; utilities `.max-width-2` 40em, `.max-width-3` 52em, `.max-width-4` 64em; also 75em, 60rem and a 750px card max-width.
- Spacing from Basscss utilities (`px2`, `mx-auto`, `sm-col-6`), not tokenised. Badges padding `.25em .4em`.
- Radius: 5px default (images, cards, buttons), .25rem badges, 2px chips, 4px, 50px pills.
- Shadows: `0 2px 3px 0 rgba(0,0,0,.075)` (cards, images), an inset variant, `0 1em 2em -.5em rgba(0,0,0,.35)`, `2px 15px 5px rgba(0,0,0,.40)`.
- Transitions: .15s ease-in-out on badges.
- Images: width 100%, max-height 300px, object-fit cover, radius 5px.

Breakpoints (raw values, no variables): max-width 300px, 40em (640px), 30rem (480px), 600px, 768px, 1000px; min-width 64em (1024px).

Reusable classes: `.recipe--category`, `.recipe--tag`, `.recipe--chef`, `.recipe--meal` (one badge pattern), `.cta--main`, `.cta--secondary`, `.page--listitem`, `.squigglyURL--main`, `.squigglyURL--black`, `.skullery`, `.no-line-height`.

## Content conventions

Front matter of `_recipes/<slug>/<slug>.md`:

- `layout: recipe`, `permalink: recipes/<slug>` (matches the folder; some files have trailing spaces).
- `title`: quoted display title. `image`: `<slug>.jpg`, one per recipe, in the same folder. `imagecredit`: always `"unsplash.com"`, rendered as the camera icon tooltip, no link. `credit`: on one recipe only, a URL to the original, rendered as the credit modal.
- `date`: ISO date, all in 2020. `categories`: space-separated from the inline list (appetizer baking dressing drink grill healthyish marinade oven pickling quick raw salad sandwich sauce snack soup). `tags`: space-separated from the inline list (asian beef bread burger christmas duck french fruit indian italian mexican nuts pasta pork poultry rice seafood thanksgiving vegetarian). `meal`: one of breakfast brunch dessert main side. `chef`: a lowercase first name (robert for about 140, jarrod, razvan, roksana, adam, diana, michael, ross). `time`: under 60mins, under 120mins, over 120mins, with typos. `servings`: a number, the base for scaling (1 for 134 recipes).
- `notes`: optional list of plain-prose tips, rendered under "Notes". `ingredients` and `directions`: lists.
- Two files carry a template-style comment on every key with the allowed values.

Ingredient lines: `<amount>| <rest>`, the pipe followed by a space, the amount a bare number with decimals (0.25, 1.5), e.g. `45|ml extra-virgin olive oil, plus more for drizzling` and `800|g can whole peeled tomatoes, crushed *see note*`. A unit glued to the pipe (`45|ml`) is read as the unit by the parse. Lines without an amount are plain text (`kosher salt and freshly ground black pepper`). Asterisks wrap side notes (`*see note*`, `*optional*`), rendered as emphasis and stripped by the copy feature. Group headers are list items ending in a colon (`for the pork:`, `for garnish:`); one file has an unindented header line. All 1852 ingredient lines use one pipe; the three-part form the layout supports is unused.

Directions: imperative, present tense, one step per list item, one to six lines, times and temperatures inline (°C, "about 6 minutes"), inline `*...*` notes (`Bake until golden brown. *aprox 20-25 mins*`), sub-sections as items ending in a colon (`Blind-Baking:`, `Serving:`). Example: `Heat olive oil in a large, deep skillet ... until shimmering.`

Body text: the markdown after the front matter is the one-line description under the title. Playful and short: "Crispy Mexican-Style Pulled Pork. More beautiful words were never spoken.", "Bread Bananza.". The knife emoji 🔪 ends it in 20 of 164 files; some use another emoji; many are empty.

Images: one `<slug>.jpg` per folder, 180 to 310 KB, from unsplash.com. Three `.jpg` files hold PNG or WebP data. The image URL is built from the page URL plus the file name.
