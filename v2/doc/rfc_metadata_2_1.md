@ericpyle @klassenjm @smorrison Here's my short list of what I changed to get all the existing entries to validate after conversion, plus a rather long list of other changes, with my initial thoughts on those changes. Please review and comment since we need to roll out  new schema before we re-import the existing entries.

# Changes made last week for migration #

* lenGe2Le1024String type

* csetId optional

* local in rightsHolder optional

* name/long can be 1024 chars (alternative is to truncate to existing 255 chars)

* copyrightFullStatement optional

* Handle mixed content in XHTML

* promoVersionInfo optional

# Thoughts on other suggested schema changes #

## ALL: Make optional: /agencies/rightsHolder: [abbr, url, local]

I think I'd keep abbr, but url could certainly be optional

## TEXT: update language/ldml to ([A-Za-z]{2,3}([-_][A-Za-z0-9]+){0,4})

Looser but still pretty tight, so should be ok

## TEXT: Require /identification/abbreviation

Yes - I'm surprised this isn't already the case.

## allow one and only one of each xhtml or plain in copyright full and short statements

No - Bryce and others specifically wanted both options.

## EXPRESSION: promotion/promoVersionInfo why required? (promotion content was optional in 1.5)

I made this optional yesterday.

## ALL: REMOVE /agencies/etenPartner

Ok

## TRANSLATION: type/audience why required? (was optional in 1.5)

We can do this.

## type/audience, add "Children" to translationLevelEnum

Ok

## ALL make archiveStatus [archivistName, dateArchived, dateUpdated] optional in metadata_upload.rng ?

The content of dateArchived and dateUpdated is "text". Making those elements optional would be more consistent... except that I can imagine upload scenarios where those elements will be populated, and in that case the uploader would need to remove the elements in order for the upload XML to validate. So I think the current solution is the less bad one. I also think that it's good to require an archivist's name.

## ALL make DBLMetadata/@revision optional in metadata_upload.rng ?

Ok

## TEXT: Require /identification/systemId/@type=paratext?

That would make uploading text bundles not produced by Paratext impossible.

## add new elements to text metadata 2.0 under <systemId type="paratext"> to capture alternative project types

Need more details

## ALL make atoms optional for bundle making validation

I think the current system of producing variant schema for the different use cases is better. Bad things may happen if third parties expect atoms and don't get them, or vice versa.


## New roleIds for variant material Psa151inPsa, LjeInBar, DagPartial?

Sure, if someone can give me a list and explain how they work.

## names/name id schema could be compatible with HTML4: ID and NAME tokens must begin with a letter ([A-Za-z]) and may be followed by any number of letters, digits ([0-9]), hyphens ("-"), underscores ("_"), colons (":"), and periods (".").

Colons are evil in at least some programming environments and, in XML, generally refer to namespace prefixes.

## In PT uploader, archivists can choose to include fonts with their text translations uploads. Obviously these will be listed in the manifest (no guarantee of a meaningful mimeType though?). Is the presence of these in the manifest enough? Just wanted to give you a heads up

I think it's enough. Re mimetypes, this is a small part of a generic problem in that many/most of the PT-specific suffixes do not map to any standard mimetype. (Last time I looked there wasn't a standard mimetype for fonts either.) We could add roles for things like "font". For both these things, someone would need to put in the time to work out which suffixes map to which mimetypes and which roles and, to be useful, the mimetype mapping needs to be published somewhere. (ie "application/usx" is only going to be useful if LCHs know that it exists and IPCs use it consistently.)

## make "name" attribute optional for sourceStructureContent?

Yes

## TEXT: add "Study / Help Material" to type/translationType (translationTypeEnum)

Sure, once we have a complete schema spec for that type of metadata in 2.0

## why promoVersionInfo/@contentType="xhtml" vs statementContent/ @type="xhtml"?

If you look at that question, you'l see that the word "content" appears exactly once in each XPath. We could use "type" in both places. Or we could change promoVersionInfo to something less quirky. But at this point I'm not sure it's worth making this breaking change.