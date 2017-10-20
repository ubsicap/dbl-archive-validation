# Changes to make in Metadata 2.1

1. Make DBLMetadata/@revision optional in metadata_upload.rng

1. Require /identification/abbreviation for text expressions

1. Make csetId optional for Paratext systemIds

1. Make type/audience and type/translationType optional for text

1. Add "Children" to translationLevel enum

1. Make url and local in rightsHolder optional

1. Remove agencies/etenPartner

1. update language/ldml to ([A-Za-z]{2,3}([-_][A-Za-z0-9]+){0,4})

1. Add 1-255 length string type and use for names/name/abbr

1. Add 1-1024 length string type and use for names/name/long

1. Make "name" attribute optional for sourceStructureContent?

1. Require a publication for expressions

1. Handle mixed XHTML content better

1. Make copyright/fullStatement optional

1. Tighten up schema to avoid multiple copyright statements in same format

1. Make promoVersionInfo optional

1. Check dateArchived and dateUploader are optional in metadata_upload.rng
