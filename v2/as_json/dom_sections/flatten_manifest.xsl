<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output indent="yes"/>

  <xsl:template match="manifest">
    <manifest>
      <xsl:text>&#xA;</xsl:text>
      <xsl:call-template name="flatten_manifest">
        <xsl:with-param name="tree" select="resource | container"/>
      </xsl:call-template>
    </manifest>
  </xsl:template>
  
  <xsl:template name="flatten_manifest">
    <xsl:param name="tree"/>
    <xsl:param name="prefix" select="''"/>
    <xsl:for-each select="$tree">
      <xsl:choose>
        <xsl:when test="local-name(.) = 'resource'">
          <xsl:copy>
            <xsl:copy-of select="@*[local-name() != 'uri']"/>
            <xsl:attribute name="uri"><xsl:value-of select="concat($prefix, @uri)"/></xsl:attribute>
          </xsl:copy>
          <xsl:text>&#xA;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="flatten_manifest">
            <xsl:with-param name="tree" select="resource | container"/>
            <xsl:with-param name="prefix" select="concat($prefix, @uri, '/')"></xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>