<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
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
    <sch:pattern>
        <sch:rule context="canonicalContent/book">
            <sch:let name="bookCode" value="@code"/>
            <sch:assert test="count(preceding-sibling::*[@code = $bookCode]) = 0">
                <sch:value-of select="count(preceding-sibling::*[@code = $bookCode])"/> previous occurence(s) of book code '<sch:value-of select="@code"/>' in canonicalContent
            </sch:assert>
       </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="manifest/resource[starts-with(@uri, 'source/')][/DBLMetadata/type/medium/text() = 'text']">
            <sch:let name="uri" value="@uri"/>
            <sch:assert test="/DBLMetadata/source//content[@src=$uri]">
                No source content corresponds to manifest resource '<sch:value-of select="$uri"/>'
            </sch:assert>
       </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="source/structure//content">
            <sch:let name="src" value="@src"/>
            <sch:assert test="/DBLMetadata/manifest/resource[@uri=$src]">
                No manifest resource correponds to source content src '<sch:value-of select="$src"/>'
            </sch:assert>
       </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="publication/structure//content">
            <sch:let name="src" value="@src"/>
            <sch:assert test="/DBLMetadata/manifest/resource[@uri=$src]">
                No manifest resource correponds to publication content src '<sch:value-of select="$src"/>'
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="copyright/*">
            <sch:let name="statement" value="."/>
            <sch:assert test="count($statement/statementContent[@type='xhtml']) &lt;= 1">
                Multiple XHTML statementContent in copyright
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="copyright/*">
            <sch:let name="statement" value="."/>
            <sch:assert test="count($statement/statementContent[@type='plain']) &lt;= 1">
                Multiple plain statementContent in copyright
            </sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>