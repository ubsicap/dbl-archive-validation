<?xml version="1.0" encoding="UTF-8"?>
<!--
Copyright or  or Copr. INRIA contributor(s) : Nicolas Debeissat

nicolas.debeissat@gmail.com (http://debeissat.nicolas.free.fr/)

This software is a computer program whose purpose is to generically
generate web forms from a XML specification and, with that form,
being able to generate the XML respecting that specification.

This software is governed by the CeCILL license under French law and
abiding by the rules of distribution of free software.  You can  use, 
modify and/ or redistribute the software under the terms of the CeCILL
license as circulated by CEA, CNRS and INRIA at the following URL
"http://www.cecill.info". 

As a counterpart to the access to the source code and  rights to copy,
modify and redistribute granted by the license, users are provided only
with a limited warranty  and the software's author,  the holder of the
economic rights,  and the successive licensors  have only  limited
liability. 

In this respect, the user's attention is drawn to the risks associated
with loading,  using,  modifying and/or developing or reproducing the
software by the user in light of its specific status of free software,
that may mean  that it is complicated to manipulate,  and  that  also
therefore means  that it is reserved for developers  and  experienced
professionals having in-depth computer knowledge. Users are therefore
encouraged to load and test the software's suitability as regards their
requirements in conditions enabling the security of their systems and/or 
data to be ensured and,  more generally, to use and operate it in the 
same conditions as regards security. 

The fact that you are presently reading this means that you have had
knowledge of the CeCILL license and that you accept its terms.

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rng="http://relaxng.org/ns/structure/1.0"
    xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
    xmlns:nsp="namespace_declaration"
    version="1.0">
    
    <xsl:output method="text"/>
    <xsl:strip-space elements="*"/>
    <!-- url of  main schema, used when the start markup is in an included schema and
    	there are references to be found in the main schema which is not included -->
	<xsl:param name="mainSchemaHref"/>
	<!-- in order not to spend several hours transforming a huge schema, sets a limit -->
	<xsl:param name="maxRefs" select="'9'"/>
	
    <xsl:variable name="namespaces" select="//nsp:namespace"/>
    
    <xsl:template match="/">
        {
            <xsl:apply-templates select="rng:grammar"/>
        }
    </xsl:template>
    
    <xsl:template match="rng:grammar">
        <xsl:for-each select="$namespaces">
            <xsl:call-template name="namespaceDeclaration">
                <xsl:with-param name="prefix" select="current()/@prefix"/>
                <xsl:with-param name="uri" select="current()/@uri"/>
            </xsl:call-template>
        </xsl:for-each>
        <xsl:apply-templates select="rng:start|rng:include[not(../rng:start)]|rng:externalRef[not(../rng:start)]"/>
    </xsl:template>
    
    <!-- in order to send the namespaces and their prefix used in that form, add markups :
        <namespace prefix="fml" namespace="http://facetsml"/> at the beginning of the form -->
    
    <xsl:template name="namespaceDeclaration">
        <xsl:param name="prefix"/>
        <xsl:param name="uri"/>
    </xsl:template>
    
    <xsl:template match="rng:start">
        <xsl:apply-templates>
            <!-- initializes the pathInXml variable containing the xpath of each input -->
            <xsl:with-param name="pathInXml" select="''"/>
            <!-- initializes the pathInRef variable containing the refs passed through in order to manage cyclic references  -->
            <xsl:with-param name="refs" select="''"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <!-- with a <rng:ref> we need to look for its define -->
    
    <xsl:template match="rng:ref">
        <xsl:param name="pathInXml"/>
        <xsl:param name="refs"/>
        <xsl:param name="optional"/>
        <xsl:variable name="nodeName" select="@name"/>
        <xsl:variable name="newRefs" select="concat($refs, '/', $nodeName)"/>
        <xsl:variable name="boundedNodeName" select="concat('/', $nodeName, '/')"/>
        <xsl:variable name="endingNodeName" select="concat('/', $nodeName)"/>
        <xsl:variable name="ends-with" select="substring($refs, string-length($refs) - string-length($endingNodeName) + 1) = $endingNodeName"/>
        <!-- checks the limit is not exceeded -->
        <xsl:variable name="refsCount">
            <xsl:call-template name="count">
                <xsl:with-param name="char" select="'/'"/>
                <xsl:with-param name="string" select="$newRefs"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="$refsCount &lt; number($maxRefs)">
	        <xsl:choose>
	            <!-- cyclic reference : refs = /first/second/third/second/third and @name = second -->
	            <xsl:when test="contains(substring-after($refs, $endingNodeName), $boundedNodeName) or (contains($refs, $boundedNodeName) and $ends-with)">
	            </xsl:when>
	            <!-- cyclic reference : refs = /first/second/third and @name = second 
	                cyclic pointer is newRefs = /first/second/third/second and cyclic_place pointer is /first/second/third/second/third -->
	            <xsl:when test="contains($refs, $boundedNodeName) or $ends-with">
	                <xsl:variable name="cyclic_place" select="concat($newRefs, substring-after($refs, $endingNodeName))"/>
	                
	        			<xsl:call-template name="goToDefine">
	                    	<xsl:with-param name="pathInXml" select="$pathInXml"/>
	        			    <xsl:with-param name="refs" select="$newRefs"/>
                            <xsl:with-param name="optional" select="$optional"/>
		                    <xsl:with-param name="nodeName" select="$nodeName"/>
	    	            </xsl:call-template>
	        		
	        	</xsl:when>
	        	<xsl:otherwise>
	        		<xsl:call-template name="goToDefine">
						<xsl:with-param name="pathInXml" select="$pathInXml"/>
	        		    <xsl:with-param name="refs" select="$newRefs"/>
                        <xsl:with-param name="optional" select="$optional"/>
						<xsl:with-param name="nodeName" select="$nodeName"/>
	    	        </xsl:call-template>
	        	</xsl:otherwise>
	        </xsl:choose>
		</xsl:if>
	</xsl:template>   
    
    <xsl:template name="goToDefine">
    	<xsl:param name="pathInXml"/>
        <xsl:param name="refs"/>
        <xsl:param name="optional"/>
        <xsl:variable name="nodeName" select="@name"/>
        <xsl:choose>
            <xsl:when test="/rng:grammar//rng:define[@name = $nodeName]">
                <xsl:apply-templates select="/rng:grammar//rng:define[@name = $nodeName]">
                    <xsl:with-param name="pathInXml" select="$pathInXml"/>
                    <xsl:with-param name="refs" select="$refs"/>
                    <xsl:with-param name="optional" select="$optional"/>
                </xsl:apply-templates>
            </xsl:when>
			<!-- if not found, we first look for its define in the main schema -->
			<xsl:when test="$mainSchemaHref and document($mainSchemaHref)/rng:grammar//rng:define[@name = $nodeName]">
				<xsl:apply-templates select="document($mainSchemaHref)/rng:grammar//rng:define[@name = $nodeName]">
                    <xsl:with-param name="pathInXml" select="$pathInXml"/>
                    <xsl:with-param name="refs" select="$refs"/>
                    <xsl:with-param name="optional" select="$optional"/>
                </xsl:apply-templates>
			</xsl:when>
			<!-- then look in the schema included in the main schema if defined -->
			<xsl:when test="$mainSchemaHref">
				<xsl:apply-templates select="document($mainSchemaHref)/rng:grammar/rng:include|document($mainSchemaHref)/rng:grammar/rng:externalRef">
					<xsl:with-param name="pathInXml" select="$pathInXml"/>
					<xsl:with-param name="refs" select="$refs"/>
					<xsl:with-param name="nodeName" select="$nodeName"/>
                    <xsl:with-param name="optional" select="$optional"/>
				</xsl:apply-templates>
			</xsl:when>
            <!-- if main schema is not defined, we look for the define in schema included in current one -->
            <xsl:otherwise>
                <xsl:apply-templates select="/rng:grammar/rng:include|/rng:grammar/rng:externalRef">
                    <xsl:with-param name="pathInXml" select="$pathInXml"/>
                    <xsl:with-param name="refs" select="$refs"/>
                    <xsl:with-param name="nodeName" select="$nodeName"/>
                    <xsl:with-param name="optional" select="$optional"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- look for the nodeName definition in the schema included -->
    
    <xsl:template match="rng:include|rng:externalRef">
        <xsl:param name="pathInXml"/>
        <xsl:param name="refs"/><xsl:param name="optional"/>
        <xsl:param name="nodeName"/>
        <!-- need to add a history variable in order to avoid infinite loop if schemas include themselves and nodeName is not defined -->
        <xsl:param name="alreadyCheckedSchemas" select="''"/>
        <xsl:variable name="href" select="@href"/>
        <xsl:choose>
            <!-- check if that schema has not already been browsed, if yes, stop the browsing, maybe another branch was successful -->
            <xsl:when test="contains($alreadyCheckedSchemas, $href)"/>
			<!-- if we look for a start -->
            <xsl:when test="not($nodeName)">
                <xsl:apply-templates select="document($href)/rng:grammar/rng:start|document($href)/rng:grammar/rng:include[not(../rng:start)]|document($href)/rng:grammar/rng:externalRef[not(../rng:start)]">
                    <xsl:with-param name="pathInXml" select="$pathInXml"/>
                    <xsl:with-param name="refs" select="$refs"/>
                </xsl:apply-templates>
			</xsl:when>
            <xsl:when test="document($href)/rng:grammar//rng:define[@name = $nodeName]">
                <xsl:apply-templates select="document($href)/rng:grammar//rng:define[@name = $nodeName]">
                    <xsl:with-param name="pathInXml" select="$pathInXml"/>
                    <xsl:with-param name="refs" select="$refs"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <!-- if not found, we also look for its define in the schema included in the included schema-->
                <xsl:apply-templates select="document($href)/rng:grammar/rng:include|document($href)/rng:grammar/rng:externalRef">
                    <xsl:with-param name="pathInXml" select="$pathInXml"/>
                    <xsl:with-param name="refs" select="$refs"/>
                    <xsl:with-param name="nodeName" select="$nodeName"/>
                    <xsl:with-param name="alreadyCheckedSchemas" select="concat($alreadyCheckedSchemas, '/', $href)"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="rng:define|rng:interleave|rng:div|rng:group">
        <xsl:param name="pathInXml"/>
        <xsl:param name="refs"/>
        <xsl:param name="optional"/>
        <xsl:apply-templates>
            <xsl:with-param name="pathInXml" select="$pathInXml"/>
            <xsl:with-param name="refs" select="$refs"/>
            <xsl:with-param name="optional" select="$optional"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="rng:optional">
        <xsl:param name="pathInXml"/>
        <xsl:param name="refs"/><xsl:param name="optional"/>
            <xsl:apply-templates>
                <xsl:with-param name="pathInXml" select="$pathInXml"/>
                <xsl:with-param name="refs" select="$refs"/>
                <xsl:with-param name="optional" select="'true'"/>
            </xsl:apply-templates>
    </xsl:template>
    
    <!-- <rng:zeroOrMore> and <rng:oneOrMore> are treated the same, adding a [] to the pathInXml
        the children will manage with it (adding a [0] to their name in pathInXml) -->
    
    <xsl:template match="rng:oneOrMore">
        <xsl:param name="pathInXml"/>
        <xsl:param name="refs"/>
        <xsl:param name="optional"/>
        <xsl:call-template name="indent">
            <xsl:with-param name="pathInXml" select="$pathInXml"/>
        </xsl:call-template>
        <xsl:text>&#xa;</xsl:text><xsl:value-of select="$pathInXml"/>
            <!-- the easyest way to add a [0] on the children element in pathInXml is to put []
                on it now -->
        <xsl:if test="$optional">
            <xsl:text>&#xa;</xsl:text>"<xsl:value-of select="$pathInXml"/>", "", "", "", "optional"
        </xsl:if>
            <xsl:apply-templates>
                <xsl:with-param name="pathInXml" select="concat($pathInXml, '[]')"/>
                <xsl:with-param name="refs" select="$refs"/>
            </xsl:apply-templates>
        <xsl:value-of select="$pathInXml"/>
    </xsl:template>

    <xsl:template match="rng:zeroOrMore">
        <xsl:param name="pathInXml"/>
        <xsl:param name="refs"/><xsl:param name="optional"/>
            <!-- the easyest way to add a [0] on the children element in pathInXml is to put []
                on it now -->
            <xsl:apply-templates>
                <xsl:with-param name="pathInXml" select="concat($pathInXml, '[]')"/>
                <xsl:with-param name="refs" select="$refs"/>
                <xsl:with-param name="optional" select="'true'"/>
            </xsl:apply-templates>
    </xsl:template>
    
    <!-- with an <rng:element>, I continue on the children, adding the current element to
        the parameter pathInXml. The element name may have to be prefixed, depending
        on its namespace  -->
    
    <xsl:template match="rng:element">
        <xsl:param name="pathInXml"/>
        <xsl:param name="refs"/>
        <xsl:param name="optional"/>
        <xsl:variable name="elementName">
            <xsl:apply-templates select="@name|rng:name" mode="getName"/>
        </xsl:variable>
        <xsl:variable name="newPathInXml">
            <xsl:choose>
                <xsl:when test="contains($pathInXml, '[]')">
                    <!-- if pathInXml contains [], that means the following element (the current one) can be repeated
                        so the pathInXml with is now : /neuroML/cells[] must become /neuroML/cells/cell[0] -->
                    <xsl:value-of select="concat(substring-before($pathInXml, '[]'), '/', $elementName, '[1]')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($pathInXml, '/', $elementName)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$optional">
            <xsl:text>&#xa;</xsl:text>"<xsl:value-of select="$newPathInXml"/>", "", "", "", "optional"
        </xsl:if>
            <xsl:choose>
                <xsl:when test="rng:anyName">
                    <xsl:apply-templates select="rng:anyName">
                        <xsl:with-param name="pathInXml" select="$newPathInXml"/>
                        <xsl:with-param name="refs" select="$refs"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="*[not(self::rng:anyName)]">
                <xsl:with-param name="pathInXml" select="$newPathInXml"/>
                <xsl:with-param name="refs" select="$refs"/>
            </xsl:apply-templates>
    </xsl:template>
    
    <!-- with a markup rng:list, only supports that inside :
           <rng:zeroOrMore> or <rng:oneOrMore>
                <rng:choice>
                     <rng:value>...</rng:value>
                     <rng:value>...</rng:value>
                </rng:choice>
           create a list of checkboxes for each value -->
     
    <xsl:template match="rng:list">
        <xsl:param name="pathInXml"/>
        <xsl:param name="refs"/><xsl:param name="optional"/>
        <xsl:choose>
        	<!-- test that all the nodes are rng:zeroOrMore/rng:choice/rng:value -->
        	<xsl:when test="count(rng:*/rng:*/rng:*) = count(*[self::rng:zeroOrMore or self::rng:oneOrMore]/rng:choice/rng:value)">
        		<xsl:apply-templates select="*[self::rng:zeroOrMore or self::rng:oneOrMore]/rng:choice/rng:value" mode="list">
					<xsl:with-param name="pathInXml" select="$pathInXml"/>
		            <xsl:with-param name="refs" select="$refs"/>
		        </xsl:apply-templates>
        	</xsl:when>
        	<xsl:otherwise>
        		<xsl:apply-templates>
		            <xsl:with-param name="pathInXml" select="$pathInXml"/>
		            <xsl:with-param name="refs" select="$refs"/>
		        </xsl:apply-templates>
        	</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- create the checkbox for that value.
    I must call that template with the whole xpath in match attribute because otherwise the
    pathInXml variable is not transmitted with firefox XSLT processor (?!?) -->
    
    <xsl:template match="rng:value" mode="list">
        <xsl:param name="pathInXml"/>
        <xsl:param name="refs"/><xsl:param name="optional"/>
        <xsl:variable name="value" select="text()"/>
        <xsl:text>&#xa;</xsl:text>"{$pathInXml}/text()={$value}"
    </xsl:template>
    
    <!-- a choice element will create a dropdown list of choices (i.e. a <select> markup) :  -->
    
    <xsl:template match="rng:choice">
        <xsl:param name="pathInXml"/>
        <xsl:param name="refs"/>
        <xsl:param name="optional"/>
        <xsl:if test="$optional">
            <xsl:text>&#xa;</xsl:text>"<xsl:value-of select="$pathInXml"/>", "", "", "", "optional"
        </xsl:if>
        <xsl:choose>
            <!-- if choices are a list of value, then that <select> value will be a value in the XML, then I add a 
                flag sendselect="yes", it must be taken in account when building the XML -->
            <xsl:when test="rng:value">
                <xsl:text>&#xa;</xsl:text><xsl:text>"</xsl:text><xsl:value-of select="$pathInXml"/><xsl:text>" : [</xsl:text>
                    <!-- In order not to send values if nothing has been entered, the <select> has a blank value. 
                    When the form appears, that is that blank value which is selected -->
                    <xsl:apply-templates select="rng:value" mode="choice">
                        <xsl:with-param name="pathInXml" select="$pathInXml"/>
                        <xsl:with-param name="refs" select="$refs"/>
                    </xsl:apply-templates>
                <xsl:text>]</xsl:text>,
            </xsl:when>
            <!-- if it is not <rng:value>, it should be <rng:ref> of <rng:element> -->
            <xsl:otherwise>
                <xsl:call-template name="indent">
                    <xsl:with-param name="pathInXml" select="$pathInXml"/>
                </xsl:call-template>
                <xsl:text>&#xa;</xsl:text>"<xsl:value-of select="$pathInXml"/><xsl:text>" : [</xsl:text>
                    <xsl:apply-templates mode="choice">
                        <xsl:with-param name="pathInXml" select="$pathInXml"/>
                    </xsl:apply-templates>
                <xsl:text>],</xsl:text>
                <!-- the content of the <rng:ref> (i.e. the corresponding define) or <rng:element> choices 
                    are added as hidden <div> after the <select> -->
                <xsl:apply-templates mode="addHidden">
                    <xsl:with-param name="pathInXml" select="$pathInXml"/>
                    <xsl:with-param name="refs" select="$refs"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <!-- here we add the differents options to the <select> created above. Each <rng:ref> or <rng:element> name
        becomes an <option> -->
    
    <xsl:template match="rng:ref[@name]" mode="choice">
        <xsl:param name="pathInXml"/>
        <xsl:param name="nodeName" select="@name"/>
        <xsl:text>&#xa;</xsl:text>"<xsl:value-of select="$pathInXml"/>/<xsl:value-of select="$nodeName"/>" : "<xsl:value-of select="$nodeName"/>",
    </xsl:template>
    
    <xsl:template match="rng:element" mode="choice">
        <xsl:param name="pathInXml"/>
        <xsl:variable name="elementName">
            <xsl:apply-templates select="@name|rng:name" mode="getName"/>
        </xsl:variable>
        <xsl:text>&#xa;</xsl:text>"<xsl:value-of select="$pathInXml"/>/<xsl:value-of select="$elementName"/>" : "<xsl:value-of select="$elementName"/>",
    </xsl:template>
    
    <xsl:template match="rng:*" mode="choice">
        <xsl:param name="pathInXml"/>
        <xsl:variable name="optionName">
            <xsl:value-of select="concat(local-name(), ' ', position())"/>
        </xsl:variable>
        <xsl:text>&#xa;</xsl:text>"<xsl:value-of select="$pathInXml"/>" : "<xsl:value-of select="$optionName"/>",
    </xsl:template>
    
    <!-- then we add the content of the different <rng:ref> or <rng:element> as hidden <div> with a name attribute which
        is the name of the corresponding <rng:ref> or <rng:element> in order to link them -->
    
    <xsl:template match="rng:ref[@name]" mode="addHidden">
        <xsl:param name="pathInXml"/>
        <xsl:param name="refs"/>
        <xsl:param name="optional"/>
        <xsl:param name="nodeName" select="@name"/>
            <xsl:apply-templates select="current()">
                <xsl:with-param name="pathInXml" select="$pathInXml"/>
                <xsl:with-param name="refs" select="$refs"/>
                <xsl:with-param name="optional" select="$optional"/>
            </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="rng:element" mode="addHidden">
        <xsl:param name="pathInXml"/>
        <xsl:param name="refs"/><xsl:param name="optional"/>
        <xsl:variable name="elementName">
            <xsl:apply-templates select="@name|rng:name" mode="getName"/>
        </xsl:variable>
            <xsl:apply-templates select="current()">
                <xsl:with-param name="pathInXml" select="$pathInXml"/>
                <xsl:with-param name="refs" select="$refs"/>
            </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="rng:*" mode="addHidden">
        <xsl:param name="pathInXml"/>
        <xsl:param name="refs"/><xsl:param name="optional"/>
        <xsl:variable name="optionName">
            <xsl:value-of select="concat(local-name(), ' ', position())"/>
        </xsl:variable>
            <xsl:apply-templates select="current()">
                <xsl:with-param name="pathInXml" select="$pathInXml"/>
                <xsl:with-param name="refs" select="$refs"/>
            </xsl:apply-templates>
    </xsl:template>
    
    <!-- if the choices were <rng:value> that becomes options of the <select> created above -->
    
    <xsl:template match="rng:value" mode="choice">
        <xsl:param name="pathInXml"/>
        <xsl:param name="nodeName" select="text()"/>
        <xsl:text>"</xsl:text><xsl:value-of select="$nodeName"/><xsl:text>",</xsl:text>
    </xsl:template>
    
    <!-- with a <rng:attribute>, we wait for a <rng:data> which will become an input field -->
    <xsl:template match="text()"/>
    <xsl:template match="rng:attribute">
        <xsl:param name="pathInXml"/>
        <xsl:param name="refs"/>
        <xsl:param name="optional"/>
        <xsl:variable name="attributeName">
            <xsl:apply-templates select="@name|rng:name" mode="getAttributeName"/>
        </xsl:variable>
		<xsl:variable name="newPathInXml" select="concat($pathInXml, '/@', $attributeName)"/>
        <xsl:if test="$optional">
            <xsl:text>&#xa;</xsl:text>"<xsl:value-of select="$newPathInXml"/>", "", "", "", "optional"
        </xsl:if>
            <xsl:call-template name="indent">
                <xsl:with-param name="pathInXml" select="$pathInXml"/>
            </xsl:call-template>
            <xsl:choose>
                <xsl:when test="rng:anyName">
                    <xsl:apply-templates select="rng:anyName">
                        <xsl:with-param name="pathInXml" select="$newPathInXml"/>
                        <xsl:with-param name="refs" select="$refs"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#xa;</xsl:text>"<xsl:value-of select="$newPathInXml"/><xsl:text>" : </xsl:text>
                    <xsl:if test="rng:value">
                        <xsl:text>"</xsl:text><xsl:value-of select="rng:value"/><xsl:text>"</xsl:text>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
            <!-- may not have rng:data (docbook.rng) -->
            <xsl:choose>
                <xsl:when test="count(rng:*) = 0">
                    <xsl:call-template name="inputField">
                        <xsl:with-param name="pathInXml" select="$newPathInXml"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <!-- try to apply on every markups, may work. The input field must not be indented -->
                    <xsl:apply-templates select="*[not(self::rng:anyName)]">
                        <xsl:with-param name="pathInXml" select="$newPathInXml"/>
                        <xsl:with-param name="refs" select="$refs"/>
                        <xsl:with-param name="optional" select="$optional"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
    </xsl:template>
    
    <!-- a <rng:text> gives a big text input field with /text(), added to its xpath
        (which becomes the name of the input field) -->
    
    <xsl:template match="rng:text">
        <xsl:param name="pathInXml"/>
        <xsl:param name="optional"/>
        <xsl:if test="$optional">
            <xsl:text>&#xa;</xsl:text>"<xsl:value-of select="$pathInXml"/>", "", "", "", "optional"
        </xsl:if>
        <xsl:call-template name="inputField">
            <xsl:with-param name="pathInXml" select="$pathInXml"/>
            <xsl:with-param name="type" select="'text'"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- a <rng:data> finally calls for an input field, indented or no -->
    
    <xsl:template match="rng:data">
        <xsl:param name="pathInXml"/>
        <xsl:param name="optional" />
        <xsl:if test="$optional">
            <xsl:text>&#xa;</xsl:text>"<xsl:value-of select="$pathInXml"/>", "", "", "", "optional"
        </xsl:if>
        <xsl:call-template name="inputField">
            <xsl:with-param name="pathInXml" select="$pathInXml"/>
            <xsl:with-param name="type" select="@type"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- the <a:documentation> are just copied with all their content -->
    
    <xsl:template match="a:documentation">
        
        
    </xsl:template>
    
    <!-- When an input field is created, it will be two radio buttons (true/false) if data is boolean, a <textarea> if
        it was a <rng:text>, an <input type="file"> if it was a <rng:data type="anyURI"/>, 
        otherwise it will be an <input type="text"> 
        That inputField will be indented or no -->
    
    <xsl:template name="inputField">
        <xsl:param name="pathInXml"/>
        <xsl:param name="type"/>
        <xsl:variable name="pattern" select="rng:param[@name = 'pattern']"/>
        <xsl:variable name="minLength" select="rng:param[@name = 'minLength']"/>
        <xsl:variable name="maxLength" select="rng:param[@name = 'maxLength']"/>
        <xsl:choose>
            <xsl:when test="$type='text'">
                <xsl:text>&#xa;</xsl:text>"<xsl:value-of select="$pathInXml"/>/text()", "text"
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>&#xa;</xsl:text>"<xsl:value-of select="$pathInXml"/>", "<xsl:value-of select="$type"/>", {<xsl:if test="$pattern">"pattern": "<xsl:value-of select="$pattern"/>", </xsl:if><xsl:if test="$minLength">"minLength": "<xsl:value-of select="$minLength"/>", </xsl:if><xsl:if test="$maxLength">"maxLength": "<xsl:value-of select="$maxLength"/>"</xsl:if>}
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
    <!-- In order to indent, we split the pathInXml with the / separator and we call
        the function recursively until there is no separator left, the tab is composed of
        6 spaces (this space code is said to be the most cross-browser compatible) -->
    
    <xsl:template name="indent">
        <xsl:param name="pathInXml"/>
        <xsl:if test="contains($pathInXml, '/')">

        </xsl:if>
    </xsl:template>
	
    <xsl:template match="@name" mode="getName">
        <xsl:call-template name="addPrefix">
            <xsl:with-param name="namespace" select="/rng:grammar/@ns"/>
            <xsl:with-param name="nodeName" select="."/>
        </xsl:call-template>
    </xsl:template>
	
	<xsl:template match="rng:name" mode="getName">
		<xsl:call-template name="addPrefix">
			<xsl:with-param name="namespace" select="@ns"/>
			<xsl:with-param name="nodeName" select="text()"/>
		</xsl:call-template>
	</xsl:template>
	
	<!-- for attributes, if nodeName has no prefix then namespace is empty -->
	
	<xsl:template match="@name" mode="getAttributeName">
        <xsl:value-of select="."/>
    </xsl:template>
	
	<xsl:template match="rng:name" mode="getAttributeName">
		<xsl:value-of select="text()"/>
	</xsl:template>
	
    <xsl:template match="rng:anyName">
        <xsl:param name="pathInXml"/>
        <xsl:param name="refs"/><xsl:param name="optional"/>
        <xsl:call-template name="indent">
            <xsl:with-param name="pathInXml" select="$pathInXml"/>
        </xsl:call-template>
        Any Name :
    </xsl:template>
    
    <!-- If it doesn't already have a prefix, add the corresponding prefix to the element name.
        The passed parameter $namespace is the target namespace of the current schema (in case there are
        included schemas), so that is the namespace of the unprefixed elements.
        Then I get the corresponding prefix, browsing the global variable "namespaces", which is composed
        of the namespaces declared in the MAIN schema -->

    <xsl:template name="addPrefix">
        <xsl:param name="namespace"/>
        <xsl:param name="nodeName"/>
        <xsl:choose>
            <xsl:when test="contains($nodeName, ':')">
                <xsl:value-of select="$nodeName"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="prefix">
                    <xsl:call-template name="getPrefix">
                        <xsl:with-param name="namespace" select="$namespace"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$prefix != ''">
                        <xsl:value-of select="concat($prefix, ':', $nodeName)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$nodeName"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- I need this step to be able to check that the prefix returned is not empty
        especially when the namespace is the target namespace and it has not been specified
        as xmlns="someNamespace" -->

    <xsl:template name="getPrefix">
        <xsl:param name="namespace"/>
        <xsl:for-each select="$namespaces">
            <xsl:if test="current()/@uri = $namespace">
                <xsl:value-of select="current()/@prefix"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <!-- do not want to use exslt extension tokenize in order to be more compliant -->
    
    <xsl:template name="count">
        <xsl:param name="char"/>
        <xsl:param name="string"/>
        <xsl:param name="count" select="'0'"/>
        <xsl:choose>
            <xsl:when test="contains($string, $char)">
                <xsl:call-template name="count">
                    <xsl:with-param name="char" select="$char"/>
                    <xsl:with-param name="string" select="substring-after($string, $char)"/>
                    <xsl:with-param name="count" select="$count + 1"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$count"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
	
</xsl:stylesheet>
