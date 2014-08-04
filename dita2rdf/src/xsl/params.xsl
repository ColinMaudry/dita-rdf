<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:colin="http://colin.maudry.com/"
	xmlns:doc="http://www.oxygenxml.com/ns/doc/xsl">
	
	<xsl:param name="configpath">cfg:rdf/config.xml</xsl:param>
	<xsl:param name="config" select="document($configpath)"></xsl:param>
	
	<!-- Located here to have lower precedence over the other imported templates -->
	<xsl:template match=" * | @* | node() | processing-instruction()"/>

</xsl:stylesheet>
