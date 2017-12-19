# Wish list for metadata schema 2.1.1

### Functioning braille support

*MVH*: This mainly involves finalising the content of the format section for this medium.

#### Support for liblouis tables in multiple languages

*MVH*: From Jake:
```
2. Where title page contains some English and some local language:
 
If local language uses a completely different script eg. Malayalam or Urdu then an English table can be included in the main table because there will be no cross-over – at least for the word characters. So only 1 table needed. In fact many of these tables already include an English table because they do use Roman punctuation characters.
 
If local language uses Roman script  and has some unique contractions eg. Luganda (which has a contraction for letters “nga” even in its generally uncontracted braille) then English table will need to be separate. It will need to be indicated on the title page template to use this table where relevant.
 
3. Literal braille:
I can only envisage this on the title page so it could be marked up on the title page template to use the literal table.
 
4. Odd original language words in the Scriptures:
I see there are USX character styles “wg” and “wh”. So these could indicate to the program to look for a greek or hebrew table if desired.
 
5. One extra case is where most of the bible is contracted (grade 2) but part is uncontracted (grade 1). 
 
So in the unlikely scenario of all of the above how about something like this, with all apart from “main” as optional:
 
<tables>
    <table src= “lg-ug-g2.utb” type= “main”>
        <name>Luganda Braille Grade 2</name>
    </table>
    <table src= “lg-ug-g1.utb” type= “main-uncontracted”> <!—Only necessary if “main” is contracted –>
        <name>Luganda Braille Grade 1</name>
    </table>
    <table src= “en-ueb-g2.ctb” type= “secondary”>
        <name>Unified English Braille Grade 2</name>
    </table>
    <table src= “unicode-braille.cti” type= “unicode-braille”>
        <name>Unicode braille characters table</name>
    </table>
    <table src= “ascii-braille.cti” type= “ascii-braille”>
        <name>ASCII braille characters table</name>
    </table>
    <table src= “gr-bb.ctb type= “greek”>
        <name>Septuagint and New Testament Greek Braille</name>
    </table>
    <table src= “he.ctb type= “hebrew”>
        <name>Biblical Hebrew Braille</name>
    </table>
</tables>
 
NB. Some table names are taken from Liblouis current list, others are made up but could exist.
It may be a bit overkill and you may prefer different attribute names and values but something like this should cover most of the bases.
```

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

*EDP*: @klassenjm how should we proceed on this to unblock Lois who is trying to upload to DBL a (transliteration) project that has already been uploaded? (https://thedigitalbiblelibrary.org/entry?id=19b20027201977c5)

1. I can remove (at least partially) my restriction in Paratext from uploading projects with a basedOn text.
2. We can prioritize fixing 1.5 and 2.1.1 to support basedOn elements to capture metadata for these types of uploads.

*JK*:
My current thoughts:

That we **not** support upload of the following as regular DBL entries (resource only uploads excepted):
* StudyBibleAdditions
* ConsultantNotes
* GlobalConsultantNotes
* GlobalAnthropologyNotes

It would be very nice if we could retain basedOn. What do we capture there? The PT project GUID? a name? If we could capture the GUID and see if that was already an entry in DBL - and then set up a relation in the DBL metadata -- would that be good? (I think so -- but I don't feel like I want to come across as though it's a requirement yet).

*EDP*: 
@klassenjm I know that Biblica and others were hoping we'd support Auxiliary, so they have a workflow that supports forking active projects before uploading it to DBL. I don't remember where that discussion landed given that PT Registry does not host those projects, except that perhaps the PT uploader could potentially borrow the needed metadata from basedOn (unless that just is not workable in all cases).

also fwiw, DBL already has GlobalAnthropologyNotes as resourceOnly. Certainly the PT uploader should have certain precautions about projects that typically get uploaded, but resourceOnly does allow non-typical projects. We aren't technically running the same schema validation for resourceOnly uploads, but at the same time we are using the same metadata structure for transporting metadata with resourceOnly uploads.

*JK*:
@ericpyle I changed my "current thoughts". Will look at updating the wishlist.

*EDP*:
@klassenjm what are your "current thoughts"?

**Re: basedOn**. 
> What do we capture there? The PT project GUID? a name?

Both, as you can see in the example snippet:
```
    <basedOn>
           <name>engWEB14</name>
            <id>9879dbb7cfe39e4d5d6f7f9dbd0c6414691a036e</id>
    </basedOn>
```

> If we could capture the GUID and see if that was already an entry in DBL - and then set up a relation in the DBL metadata -- would that be good? (I think so -- but I don't feel like I want to come across as though it's a requirement yet).

I had asked @mvahowe or you about this in the past re: relationships element, and was advised against that (can't remember the reason). Perhaps it's in the old trello card. It would be good to support some kind of actionable linkage on the DBL webpage, at least.

*JK*: I think it would be quite good to express the basedOn metadata also as a relationships/relation if the basedOn GUID is also a DBL entry. I agree about the desireability of having a presentation of these relationship associations in DBL. If there is a reason to not do this, please explain.

### Allow chapter 0 in \@role

*MVH*: This is in response to the discovery of 000.mp3 in some audio. We assume this is audio for an introduction. "1TH 0" is not currently allowed as a role, so the current options are to not put include that file in the publication at all or to include it with no role. "1TH 0" would be an admittedly ugly way to label introductions. (It wouldn't work well for USX containing multiple introductions, for example.)
