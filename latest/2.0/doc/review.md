# Review of proposed 2.0 Metadata schema

## Overall structure

* Move some of the root element attributes into the `type` element,
  specifically `@type` (which becomes a `mediumType` element) and
  `@typeVersion` (which becomes a `schemaVersion` element or maybe
  `xsi:schemaLocation`). This leaves `id` and `revision` as
  attributes, which are the two key pieces of information needed to
  identify the bundle within DBL.

* Move the `confidential` boolean into the `type` element (becomes
  `isConfidential`).

* Move progress information into `manifest`.

* In general, elements should either be present with useful content or
  absent. In other words, the schema should proscribe empty elements
  (eg for `ldml`) and the various `xLocal` elements should only be
  present if their content is different to the related `x` element and
  genuinely localized. This means that document consumers know when
  localization has happened and can decide how to proceed when
  localization has not happened (eg use the non-localized text, skip
  the bundle, process the bundle but flag the need to localize...)

* The schema should not impose unnecessary order constraints on
  elements, but my suggestion for a canonical order is
  `identification`, `type`, `relationships`, `agencies`, `language`,
  `country`, `format`, `manifest`, `names`, `publications`,
  `copyright`, `promotion`, `archiveStatus`. (From a processing
  perspective, I would prefer `identification` follow `type` and
  `relationships`, but I think being able to eyeball the names of the
  bundle at the top of the document is a good feature too.)

* In many cases the allowed value is "any string of two or more
  characters". It would be good to tighten up the schema wherever
  possible, eg to disallow space-only strings, to disallow leading and
  trailing spaces, and maybe to limit the range of characters in some
  cases.

## identification

* `nameLocal`, `abbreviationLocal` and `descriptionLocal` (not
  currently defined) should be optional and present only if genuine
  localization has occured.

## type

* Can we provide a list of permitted values for `translationType`?

* Changed `audioType` to `dramatization` to disambiguate.

* Move DBLMetadata/@type here as `mediumType`.

* Move DBLMetadata/@typeVersion here as `schemaVersion`.

* Move `confidential` here as `isConfidential`.

* Currently `translationType` and `audience` are only allowed and
  always requited for sources. Do either of these make sense for, eg,
  a POD bundle, given that the information is presumably in the
  related text bundle?

## relationships

* Should definitely be required where `isSource` is false, but can a
  source (eg most text bundles) have `relationships`? I think the
  answer depends on whether relations can denote something other than
  "is derived from".

## agencies

Nothing new here.

## language

* I suggest that the minimum information here for expressions should
  be `iso` and maybe `name`.

* See comments above about `nameLocal`.

* `ldml` could be required if it's useful and easy to provide.

* I don't know what a `rod` is but it seems to be missing frequently.

* Can we provide a list of permitted values for 'script'?

## country

* Add optional `nameLocal` for the sake of consistency?

## format

* This section is entirely media-dependent. I removed MIME information
  since this appears on a file-by-file basis in the manifest.

### text format

* I added a `versedParagraphs` boolean since this has been a pain
  point for YouVersion.

### audio format

* I would prefer to remove the 'empty' option from the child elements
  and make those child elements optional.

### print format

* I don't understand the purpose of `pod` since I thought that was
  exactly what a print bundle was intended to define. If not, what are
  the other use cases?

* Right now `height` and `width` must be in mm. What other options
  should we allow? If there are no other options, can we remove the
  units from the values to make parsing easier?

* I allowed CMYK, RGB and Monochrome as `color` models? Is that the
  correct list?

* What @type of `font` should be allowed? (I noticed that the example
  document says "OpenType" but that the fonts in the source were
  TrueType. WOFF would be another candidate.)

## manifest

* The current proposal is for the manifest root to be the "releases"
  directory of the uploaded bundle. The source zip and metadata.xml
  would be at the same level as "releases" and would therefore not
  appear in the manifest. This means that the manifest will work
  unaltered for downloads (which do not include the source but, unlike
  uploads, do include a separate metadata.xml file.

* `division` is not required.

* Right now, @size, @checksum and @mimeType are all optional. We can
  require any or all of them, but this may limit uploading options if,
  eg, checksums are not available from the remote storage location. In
  the case of MIME types, there are sometimes multiple possible values
  for a given file suffix and, in other cases, apparently including
  fonts, there is no official MIME type at all.

## names

## publications

## copyright

## promotion

## archiveStatus