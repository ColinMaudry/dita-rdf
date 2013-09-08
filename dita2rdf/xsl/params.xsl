<?xml version="1.0" encoding="utf-8"?>
<!--
This stylesheet is part of the dita2rdf DITA Open toolkit plugin, available at https://github.com/ColinMaudry/dita-rdf  
This project project is driven by Colin Maudry and licensed under a CC BY-SA Unported 3 license.
-->
<xsl:stylesheet version="2.0"	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:colin="http://zebrana.net/"
	xmlns:doc="http://www.oxygenxml.com/ns/doc/xsl">

	<xsl:param name="profilingAttributes">audience,platform,product,otherprops,props,rev</xsl:param>
	<xsl:param name="resourcesBaseUri">http://data.example.com/id/</xsl:param>
	<xsl:param name="doctypesNamespaces" select="document('conf/doctypesNamespaces.xml')"></xsl:param>
	
	<!-- Located here to have lower precedence over the other imported templates -->
	<xsl:template match=" * | @* |node()"/>
</xsl:stylesheet>