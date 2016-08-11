# Principles of v2.0 metadata schema

## One schema for all bundle types

This is important as we move from two distinct bundle types towards
many bundle types to be handled by generic tools.

## A bundle can be a source and/or one or more expressions of a translation

This distinction is intended to let us handle different types of
bundle in a generic way. A *source* is considered to contain a
relatively raw version of a translation in a form that could
potentially be used to produce many different works. An *expression*
is one such work, intended to produce one specific publication. In practice:

* A _text_ bundle is always a source (since it contains the
  translation's USX files) and is generally also an expression (since
  it contains one or more canons and, in 2.0, optional front and
  backmatter), but it is possible to imagine a text bundle containing
  just a collection of unordered USX files that would not be an expression.

* An _audio_ bundle is an expression when it is has been produced by
  reading a related text bundle, and a source (and probably also an
  expression) when no written form of the translation exists.

* A _print_ bundle contains exactly one expression.

The reworked `type` element includes two related booleans:

* _isSource_ (Is the bundle a source)

* _isExpression_ (Does the bundle contain at least one expression)

## Bundles without written content require less language metadata

So, eg, `ScriptDirection` is irrelevant to the content of audio Bibles
(although, arguably, not for associated, i18nized metadata). The
reworked `type` element includes a boolean, _hasCharacters_, which is
set for bundles containing written text (currently the bundle types
`text` and `print`).

## Bundle-type-specific metadata is in the format section

This section is likely to be quite different for each bundle
type. Note that mime-type information has been removed from this
section since it is provided for every `manifest` resource.

## The names section provides labels

These may be used in more than one place in a publication. At some
point we expect a list of "well-known" name ids to emerge, for
labelling common aspects of a Bible.

## The manifest section documents the content of the bundle

The `container` / `resource` structure looks like a nested directory
structure, but is actually simply a syntactic convenience - it is also
possible to omit all `container` elements and to provide
fully-qualified uris for each `resource`, S3-style. That
fully-qualified uri must be unique within the bundle, but the
unqualified uri of a `resource` within `container`s might well not be
unique.

## The publications section describes a particular work

This section therefore includes

* Metadata, some of which may be identical to the corresponding bundle metadata.

* An optional `canonicalBooks` section that documents the biblical
  content of the work, as this may be hard to deduce for, eg, a print
  bundle with a single PDF source.

* A `structure` section that contains an ordered list of published
  content, with optional nested `division`s for, eg, groups of
  books. Each `division` and `content` element refers to a name from
  the `names` section. Each `content` element also refers to a file or
  file fragment in the `manifest`.
