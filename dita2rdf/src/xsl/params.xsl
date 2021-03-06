<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#"
	xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
	xmlns:dita="http://purl.org/dita/ns#"
	xmlns:schema="http://schema.org/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:colin="http://colin.maudry.com/"
	xmlns:doc="http://www.oxygenxml.com/ns/doc/xsl"
	exclude-result-prefixes="colin xs doc">
	
	<xsl:param name="configpath">cfg:rdf/config.xml</xsl:param>
	<xsl:param name="config" select="document($configpath)"></xsl:param>
	<xsl:param name="debug"/>
	
	<!-- Located here to have lower priority over the other imported templates -->
	<xsl:template match=" * | @* | processing-instruction()" xml:space="default"/>
	<xsl:template match="text()" xml:space="default">
		<xsl:value-of select="."/>
	</xsl:template>

</xsl:stylesheet>
