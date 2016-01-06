<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="2.0"  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#"
	xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dita="http://purl.org/dita/ns#"
	xmlns:schema="http://schema.org/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:colin="http://colin.maudry.com/"
	xmlns:doc="http://www.oxygenxml.com/ns/doc/xsl"
	xmlns:ot="http://www.idiominc.com/opentopic"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema#" exclude-result-prefixes="xs doc colin ot">
	<xsl:template match="*[contains(@class, ' bookmap/bookmap ')]/*[contains(@class,' bookmap/booktitle ')]">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="*[contains(@class,' bookmap/booklibrary ')] | 
		*[contains(@class,' bookmap/mainbooktitle ')] | 
		*[contains(@class,' bookmap/booktitlealt ')] ">
		<xsl:apply-templates select="." mode="colin:processElementAsProperty">
			<xsl:with-param name="objectType" as="xs:string" select="'literal'"/>
			<xsl:with-param name="hasLanguage" as="xs:boolean" select="true()"/>
		</xsl:apply-templates>
	</xsl:template>
	
	
</xsl:stylesheet>