<!-- modified from http://stackoverflow.com/a/4747858 -->
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output omit-xml-declaration="yes" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:variable name="vApos">'</xsl:variable>

    <xsl:template match="*[@* or not(*)] ">
        <xsl:if test="not(*)">
            <xsl:apply-templates select="ancestor-or-self::*" mode="path"/>
            <xsl:text>&#xA;</xsl:text>
        </xsl:if>
        <xsl:apply-templates select="@*|*"/>
    </xsl:template>

    <xsl:template match="*" mode="path">
        <xsl:value-of select="concat('/',name())"/>
        <xsl:variable name="vnumSiblings" select=
             "count(../*[name()=name(current())])"/>
        <xsl:if test="$vnumSiblings > 1">
            <xsl:value-of select="'[]'"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:apply-templates select="../ancestor-or-self::*" mode="path"/>
        <xsl:value-of select="concat('/@',name())"/>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
    <!-- suppress default copying of text to output -->
    <xsl:template match="text()"/>
</xsl:stylesheet>