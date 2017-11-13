# Wish list for metadata schema 2.1.1

### Functioning braille support

*MVH*: This mainly involves finalising the content of the format section for this medium.

### Add optional @publicationId to relation element (for braille)

*MVH*: This is needed because braille is generated directly from the related text, and the software that does this needs to know which publication running order to use. If it's optional it shouldn't break anything. It could be useful for audio too if different publications in the text have different USX for the same book.

### Consider support for ISBNs and other external Ids

*MVH*: This is another requirement for braille, sometimes at a per-Bible level, often on a per-volume basis (ie 43 ISBNs in one metadata document). Apparently Indian Bible Society also has its own Id system that must appear on publications. We can no doubt come up with a convention to do this via the names section, but maybe ISBNs are something we should handle natively for expressions? We could treat global ones as another systemId. If we wanted to allow multiple ids per document we would need to add attributes or child elements to the division element. (@isbn would work if that's the only id we support, but adding attributes doesn't scale well. The alternative is to allow zero or more child "divisionId" elements, which does scale, but which may break publication processing that expects everything in the structure section to be a division or a content element. On the other hand, this is unlikely to occur very often in text or audio, so, in practice, it may not break much at all.)

### Add new elements to text metadata 2.0 under to capture alternative project types

*MVH*: I think this is the same as...

### TEXT: add "Study / Help Material" to type/translationType (translationTypeEnum)

*EDP* (?):
```
Paratext supports the following project types. I can see value in storing metadata for the project type. in DBL, and being able to search for and identify specific types.

Standard Translation
Back Translation
Daughter Translation
Transliteration (manual)
Transliteration (generated)
Study Bible
Study Bible Additions
Auxiliary
Consultant Notes

<systemId type="paratext">
    <projectType>Auxiliary</projectType>
    <basedOn>
           <name>engWEB14</name>
            <id>9879dbb7cfe39e4d5d6f7f9dbd0c6414691a036e</id>
    </basedOn>
</systemId>
```
Where optional `<projectType>` can be `Standard|Daughter|StudyBible|StudyBibleAdditions|BackTranslation|Auxiliary|TransliterationManual|TransliterationWithEncoder|ConsultantNotes|GlobalConsultantNotes|GlobalAnthropologyNotes`

Where optional `<basedOn>` has required `<name>` (lenGe2String) and required `<id>` (ptId)`

In text metadata.rng 1.5 (for xslt 1.5 > 2.1 and 2.1 > 1.5):
```
<systemId type="paratext"  
projectType="Auxiliary" 
basedOnName="engWEB14"
basedOnId="9879dbb7cfe39e4d5d6f7f9dbd0c6414691a036e"></systemId>
```
*MVH*: I think some XML examples may have been lost through multiple copy and paste between systems. I also wonder if it's useful to denormalize the name of the basedOn text in this way because the names of entries are not stable and, in any case, engWEB14 doesn't look like an identification/name.

### Allow chapter 0 in \@role

*MVH*: This is in response to the discovery of 000.mp3 in some audio. We assume this is audio for an introduction. "1TH 0" is not currently allowed as a role, so the current options are to not put include that file in the publication at all or to include it with no role. "1TH 0" would be an admittedly ugly way to label introductions. (It wouldn't work well for USX containing multiple introductions, for example.)
