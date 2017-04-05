<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://www.ascc.net/xml/schematron">
    <pattern name="Check top-level structure">
     <rule context="DBLMetadata">
         <assert test="count(identification) = 1">DBLMetadata element must contain exactly one identification section</assert>
         <assert test="count(type) = 1">DBLMetadata element must contain exactly one type section</assert>
         <assert test="count(relationships) &lt; 2">DBLMetadata element must contain zero or one relationships sections</assert>
         <assert test="count(agencies) = 1">DBLMetadata element must contain exactly one agencies section</assert>
         <assert test="count(language) = 1">DBLMetadata element must contain exactly one language section</assert>
         <assert test="count(country) = 1">DBLMetadata element must contain exactly one identification section</assert>
         <assert test="count(format) = 1">DBLMetadata element must contain exactly one country section</assert>
         <assert test="count(names) = 1">DBLMetadata element must contain exactly one format section</assert>
         <assert test="count(source) &lt; 2">DBLMetadata element must contain zero or one source sections</assert>
         <assert test="count(manifest) = 1">DBLMetadata element must contain exactly one names section</assert>
         <assert test="count(publications) = 1">DBLMetadata element must contain exactly one manifest section</assert>
         <assert test="count(promotion) = 1">DBLMetadata element must contain exactly one publications section</assert>
         <assert test="count(copyright) = 1">DBLMetadata element must contain exactly one promotion section</assert>
         <assert test="count(archiveStatus) = 1">DBLMetadata element must contain exactly one archiveStatus section</assert>
     </rule>   
    </pattern>
</schema>