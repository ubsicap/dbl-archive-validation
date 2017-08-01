<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="sections">
  	<html>
  		<head>
  			<title>Lekythos Forms Demo</title>
  		</head>
  		<body onload="tabToggle(0)">
        <style>
          .tab, .nav-button {
            padding: 3px;
            border: solid black 1px;
            margin: 2px;
          }
        </style>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script>
          <xsl:text>function tabToggle(n) {
            $("#sections").children('.section').each(function () {
              $(this).css("display", "none");
            });
            $("#sections").children('.section').eq(n).css("display", "block");
            $("#tabs").children('.tab').each(function () {
              $(this).css("font-weight", "normal");
            });
            $("#tabs").children('.tab').eq(n).css("font-weight", "bold");
          }</xsl:text>
        </script>
  		<div id="tabs">
  			<xsl:for-each select="section">
  				<span id="{concat('tab-', @name)}" class="tab" onclick="tabToggle({position()-1})">
  						<xsl:value-of select="@name"/>
  				</span>
  			</xsl:for-each>
  		</div>
  		<div id="sections">
	      	<xsl:apply-templates select="section"/>
	    </div>
      	</body>
    </html>
  </xsl:template>

  <xsl:template match="section">
  	<div id="{concat('section-',@name)}" class="section">
  		<h2><xsl:value-of select="prompt"/></h2>
      <xsl:for-each select="collection | field">
        <xsl:choose>
          <xsl:when test="local-name() = 'field'">
            <div id="{concat('field-',../@name,'-',@name)}">
              <span class="field-label">
                <xsl:value-of select="prompt"/>
              </span>
              <input type="text" id="{concat('input-',../@name,'-',@name)}" name="{concat(../@name,'-',@name)}"/>
            </div>
          </xsl:when>
          <xsl:when test="local-name() = 'collection'">
            <xsl:text>Collection goes here</xsl:text>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
      <div>
        <xsl:if test="position() &gt; 1">
          <span class="nav-button" onclick="tabToggle({position()-2})">Previous</span>
        </xsl:if>
        <xsl:if test="position() &lt; last()">
          <span class="nav-button" onclick="tabToggle({position()})">Next</span>
        </xsl:if>
      </div>
  	</div>
  </xsl:template>

  <xsl:template match="@*|node()">
      <xsl:apply-templates select="@*|node()"/>
  </xsl:template>

</xsl:stylesheet>