<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    <sch:pattern>
        <sch:title>validate_paratext_resource_only_fields</sch:title>
        <sch:rule context="/DBLMetadata">
            <sch:assert test="string-length(identification/name) &gt; 0">Empty or missing identification/name</sch:assert>
            <sch:assert test="string-length(identification/abbreviation) &gt; 0">Empty or missing identification/abbreviation</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:title>validate_paratext_auto_supplied_fields</sch:title>
        <sch:rule context="/DBLMetadata">
            <sch:assert test="confidential = 'true'">Confidential is not set to true</sch:assert>            
            <sch:assert test="string-length(identification/systemId[@type='paratext']) &gt; 0">Empty or missing paratext systemId text</sch:assert>
            <sch:assert test="string-length(identification/systemId[@type='paratext']/@name) &gt; 0">Empty or missing paratext systemId name</sch:assert>            
            <sch:assert test="string-length(identification/systemId[@type='paratext']/@fullname) &gt; 0">Empty or missing paratext systemId fullname</sch:assert>      
            <sch:assert test="string-length(identification/systemId[@type='paratext']/@csetid) &gt; 0">Empty or missing paratext systemId fullname</sch:assert>      
            <sch:assert test="string-length(identification/bundleProducer) &gt; 0">Empty or missing identification/bundleProducer</sch:assert>      
            <sch:assert test="string-length(language/iso) &gt; 0">Empty or missing language/iso</sch:assert>      
            <sch:assert test="string-length(language/name) &gt; 0">Empty or missing language/name</sch:assert>
            <sch:assert test="string-length(language/ldml) &gt; 0">Empty or missing language/ldml</sch:assert>
            <sch:assert test="string-length(archiveStatus/archivistName) &gt; 0">Empty or missing archiveStatus/archivistName</sch:assert>      
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:title>Not GlobalAnthropologyNotes</sch:title>
        <sch:rule context="/DBLMetadata[identification/systemId[@type='paratext']/@projectType != 'GlobalAnthropologyNotes']">
            <sch:assert test="count(contents/bookList/books/book) &gt; 0">No book elements in contents</sch:assert>
            <sch:assert test="count(bookNames/book) &gt; 0">No book elements in bookNames</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>