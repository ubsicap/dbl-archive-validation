<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="sections">
  	<html lang="en">
      <head>
        <title>Lekythos Forms Demo</title>
        <!-- Required meta tags -->
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
        <!-- Latest compiled and minified CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous"/>
      </head>
      <body onload="tabToggle(0)">
        <style>
          .tab, .nav-button {
          padding: 3px;
          border: solid black 1px;
          margin: 2px;
          }
        </style>
        <form data-toggle="validator" role="form">
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
        </form>
        <!-- jQuery first, then Tether, then Bootstrap JS. -->
        <script src="https://code.jquery.com/jquery-3.1.1.slim.min.js" integrity="sha384-A7FZj7v+d/sdmMqp/nOQwliLvUsJfDHW+k9Omg/a/EheAdgtzNs3hpfag6Ed950n" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/1000hz-bootstrap-validator/0.11.9/validator.min.js"></script>
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
      </body>
    </html>
  </xsl:template>

  <xsl:template match="section">
  	<div id="{concat('section-',@name)}" class="section">
  		<h2><xsl:value-of select="prompt"/></h2>
      <xsl:for-each select="collection | field">
        <xsl:choose>
          <xsl:when test="local-name() = 'field'">
            <div class="form-group" id="{concat('field-',../@name,'-',@name)}">
              <label for="inputName" class="control-label">
                <xsl:value-of select="prompt"/>
              </label>
              <input type="text" id="{concat('input-',../@name,'-',@name)}" name="{concat(../@name,'-',@name)}" class="form-control" placeholder="" pattern="^[a-f0-9]{{16}}$" required=""/>
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