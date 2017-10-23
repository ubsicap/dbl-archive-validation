<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <sch:pattern>
        <sch:rule context="DBLMetadata">
            <sch:assert test="@version = '2.1'">Expected version 2.1 but found '<sch:value-of select="@version"/>'</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="names/name">
            <sch:let name="nameId" value="@id"/>
            <sch:assert test="count(preceding-sibling::*[@id = $nameId]) = 0">
                <sch:value-of select="count(/DBLMetadata/names/name[@id = $nameId])"/> names/name elements have the same id '<sch:value-of select="@id"/>'
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="publications/publication/structure//division[@name]">
            <sch:let name="divisionName" value="@name"/>
            <sch:assert test="/DBLMetadata/names/name[@id=$divisionName]">
                Division name '<sch:value-of select="$divisionName"/>' is not defined in the names section
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="publications/publication/structure//content[@name]">
            <sch:let name="contentName" value="@name"/>
            <sch:assert test="/DBLMetadata/names/name[@id=$contentName]">
                Content name '<sch:value-of select="$contentName"/>' is not defined in the names section
            </sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>