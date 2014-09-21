<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="colin doc xs" version="2.0" xmlns:colin="http://colin.maudry.com/" xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:dita="http://purl.org/dita/ns#" xmlns:doc="http://www.oxygenxml.com/ns/doc/xsl" xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:nfo="http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#" xmlns:nie="http://www.semanticdesktop.org/ontologies/2007/01/19/nie#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:schema="http://schema.org/"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dcat="http://www.w3.org/ns/dcat#">
	<xsl:template name="colin:datasetMetadata">
		<xsl:param name="xtrf"/>
		<xsl:param name="rootLang"/>
		<xsl:param name="rootId"/>
		<xsl:param name="rootTitle"/>
			
		<dcat:Dataset rdf:about="{$config/config/resourcesBaseUri/@uri}dataset/{$rootLang}{$rootId}">
			<dcterms:issued rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime"><xsl:value-of select="current-dateTime()"/></dcterms:issued>
			<dcterms:description><xsl:value-of select="$xtrf"/></dcterms:description>
			<xsl:if test="$rootTitle!=''">
				<dcterms:title>
					<xsl:if test="$rootLang!=''">
						<xsl:attribute name="xml:lang" select="substring-before($rootLang,'/')"/>
					</xsl:if>
					<xsl:value-of select="$rootTitle"/>
				</dcterms:title>
				<rdfs:label>
					<xsl:if test="$rootLang!=''">
						<xsl:attribute name="xml:lang" select="substring-before($rootLang,'/')"/>
					</xsl:if>
					<xsl:value-of select="$rootTitle"/>
				</rdfs:label>
			</xsl:if>
		</dcat:Dataset>
	</xsl:template>
</xsl:stylesheet>