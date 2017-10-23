# Changes to consider for future metadata schema

## Add new elements to text metadata 2.0 under to capture alternative project types

## TEXT: add "Study / Help Material" to type/translationType (translationTypeEnum)

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

<systemId type="paratext"> <projectType>Auxiliary</projectType> <basedOn><name>engWEB14</name> <id>9879dbb7cfe39e4d5d6f7f9dbd0c6414691a036e</id></basedOn> </systemId>

Where optional can be Standard|Daughter|StudyBible|StudyBibleAdditions|BackTranslation|Auxiliary|TransliterationManual|TransliterationWithEncoder|ConsultantNotes|GlobalConsultantNotes|GlobalAnthropologyNotes

Where optional has required (lenGe2String) and required (ptId)
```
