﻿# jQAPI JATS adaptation project

## Current status and strategy

- I do not have time to do this the "right" way, meaning to migrate the jqapi code
  such that the same code base can be used with either the original jQuery JSON files
  or with the JATS Tag Library HTML files.
- I created Git tag "cp1" to mark where I abandoned the idea of doing it the right way,
  in case I ever have time or the skill to go back and refactor.

### Strategy

* Goal:  use the exact same code base to serve either the original jqapi documentation
  set (docset) or the JATS tag library.
* But not at the same time - you have to first run the appropriate steps to
  initialize the documentation set files, which should land in the *docs* folder.
* The default behavior will be to serve the original jqapi docset, and should work the
  same as the original code, in every respect.

- Use the development server (`thor dev:start`) for dev/testing - keep this functional at all stages
- Don't change anything that doesn't need to be changed in the original code, esp. for
  aesthetic reasons.
- Use an environment variable or command-line parameters to switch to the jats
  docset
- "docs:download" and "docs:generate" shouldn't be implemented in *this* project for
  the JATS documentation.  They should be implemented outside.  Then, to serve it,
  create a softlink from *docs* to that external directory.
- I need to be faithful to the original JATS documentation's structure, so that means there
  will need to be a couple of major improvements to the jqapi code.  In particular:
    - Headings in the navigation panel are also pages
    - How deeply are they nested?
    - Subheadings mixed in with pages (rather than putting them first)


### Work

- Other significant code changes in my old dtdanalyzer branch
    - tasks/deploy.thor
    - tasks/documentation.thor

- Major improvements:
    - Allow interspersing of sub-cats and entries
    - Allow pages to be loaded for categories and sub-cats

- To do:
    - Change "docs-jats" to "docs" everywhere, since we'll
      be using the same directory docs regardless of the docset
    - Figure out (ask Sebastian or Dr. Hazins) the proper way to pass in the
      docset parameter from thor to the jqapi.rb config file.
    - Replace the favicon
    - When you dynamically load a new entry, the jqapi code changes the page
      title, adding the "- jQAPI" suffix.  This needs to be customizable.
      (See entry.js.coffee, lines 18-19)


## dtdanalyzer branch

This is the original work I did on this project, before restarting it in October.
I think I have redone all the important work from this branch, now, so this should
forever remain a dead-end branch.

- ~/git/Klortho/jqapi-dtdanalyzer has the code where I last left off
- Here are the changes I made in the dtdanalyzer branch:
  https://github.com/Klortho/jqapi/compare/919ad7bade18e4...8e533982
* It is deployed to [http://chrisbaloney.com/jqapi-jats/](http://chrisbaloney.com/jqapi-jats/).
    * The Table of Contents is working
    * Still need to adapt the documentation page contents.


## See also

* [GitHub Klortho/JatsTagLibrary](https://github.com/Klortho/JatsTagLibrary) -
  This will be the source of the *content* for the documentation.




## Running the dev server

The original command for this, `thor dev:start`, still works the same, and brings up
the jqapi documentation on port 9292.

If you add the `-d jats` (or `--docset jats`) parameter, then it will bring up the JATS
documentation instead.  Implementation is a bit hacky right now:

* *tasks/development.thor* - added the `method_option`, and use that to invoke rackup
  with a config file other than the default *config.ru*.  When `docset` is "jats", the
  config file *jats.ru* is used.
* *jats.ru* - this is the same as *config.ru*, but sets a global variable `$docset`,
  that's used by the *jqapi.rb* config file.
* *jqapi.rb* - reads the global variable `$docset`, and changes some of the URL
  rules accordingly.


# Change summary

These are summaries of the major changes that I made in the *jats* branch.

- Add JATS navigation panel, loaded from docs-jats/toc.html
    - In the original jquery content set, the navigation panel, in the left-hand
      pane, is loaded from docs/index.json
    - In the JATS content set, I'll load it from docs-jats/toc.html, served from
      the URL docs/toc.html.
    - This is implemented in app/assets/javascripts/categories.js.coffee.
    - In order for that JS to distinguish between the two, we have to communicate to the
      JS code that the docset for this uses HTML, not JSON.
      I added the @data-docset-type attribute into the index.html page, as follows:
        <body data-docset-type='html'>

- Entries are loaded from html files, not json.
    - This is also controlled by the body@data-docset-type attribute
    - Implemented in entry.js.coffee.


# Records from old dtdanalyzer branch

## Old list of major changes

## Changes to commands & procedures

* To generate the jQuery documentation static files, you used to enter
  `thor deploy:generate`.  Now, enter `thor deploy:generate --docset=jq`


## Changes to source code

* Moved some stuff from `app` into jq:
    * app/assets/javascripts/entry.js.coffee → jq/assets/javascripts/entry.js.coffee
    * app/assets/javascripts/header.js.coffee → jq/assets/javascripts/header.js.coffee

* Changed the files in `app` to serve static HTML files.  These will be the
  default, "example" set of documentation.


## Old to do

These are old to-do items, from before I restarted the project with the *jats* branch.
I'm not sure if they still apply or not:

* CSS issues
    * Need to verify that styles defined in, for example, jq/assets/stylesheets, will
      override any in app/assets/stylesheets
    * Note that the structure and classnames are all very jquery-doc-specific, but I
      think I shouldn't change them much.  Instead try to fit JATS docs to this
      structure.
* Bug:  in JATS, search doesn't work on element names (because of the angle-brackets?)
* Get the breadcrumbs to work - this will probably mean parsing the HTML into JSON for the main
  page.
* Get the "Original on jats..." link to work on each page.
