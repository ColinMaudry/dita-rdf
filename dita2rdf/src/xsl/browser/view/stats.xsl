<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:colin="http://colin.maudry.com/"
	xmlns:doc="http://www.oxygenxml.com/ns/doc/xsl"
	xmlns:s="http://www.w3.org/2005/sparql-results#"
	exclude-result-prefixes="colin doc s">


<xsl:template name="stats">
	<xsl:param name="currentPageType" tunnel="yes"/>
	
	<xsl:choose>
		<xsl:when test="$currentPageType='map'">
			<xsl:call-template name="mapStats"/>
		</xsl:when>
	</xsl:choose>
	
</xsl:template>
	
<xsl:template name="mapStats">
	
	<div id="mapGraph">
		</div>
	
</xsl:template>

</xsl:stylesheet>