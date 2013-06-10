<?xml version="1.0" encoding="utf-8"?>
<!--
This stylesheet is part of the dita2rdf DITA Open toolkit plugin, available at https://github.com/ColinMaudry/dita-rdf  
This project project is driveb by Colin Maudry and licensed under a CC BY-SA Unported 3 license.
-->

<xsl:stylesheet version="2.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#"
	xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:nie="http://www.semanticdesktop.org/ontologies/2007/01/19/nie#"
	xmlns:nfo="http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#"
	xmlns:xs="http://www.w3.org/2001/XMLSchema#"
	xmlns:dita="http://purl.org/dita/ns#"
	xmlns:schema="http://schema.org/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:colin="http://zebrana.net/"
	xmlns:doc="http://www.oxygenxml.com/ns/doc/xsl">
	
	<doc:doc>
		<doc:desc>The top template for maps.</doc:desc>
	</doc:doc>
	<xsl:template match="*[contains(@class,' map/map ')]">
		<xsl:param name="mapTitle">
			<xsl:choose>
					<xsl:when test="/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')]">
						<xsl:value-of select="normalize-space(/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')])"/>
					</xsl:when>
					<xsl:when test="/*[contains(@class,' map/map ')]/@title">
						<xsl:value-of select="/*[contains(@class,' map/map ')]/@title"/>
					</xsl:when>
				</xsl:choose>
		</xsl:param>
		<xsl:param name="mapLanguage">
			<xsl:value-of select="@xml:lang"/>
		</xsl:param>
		<xsl:param name="mapAuthors">
			<xsl:value-of select="*[contains(@class,' map/map ')]//*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/author ')]"/>
		</xsl:param>
		<rdf:Description rdf:about="{colin:getURI($resourcesBaseUri,local-name(),@xml:lang,@id)}">
			<rdf:type rdf:resource="{colin:getElementType(@class,local-name())}"/>
			
			<!-- Map title -->
			<xsl:if test="$mapTitle != ''">
				<dita:title>
					<xsl:if test="@xml:lang != ''">
						<xsl:attribute name="xml:lang" select="$mapLanguage"/>
					</xsl:if>
					<xsl:value-of select="$mapTitle"/>
				</dita:title> 
			</xsl:if>
			<!-- Map author(s) -->
			
			
			
			
			
		</rdf:Description>		
	</xsl:template>
</xsl:stylesheet>