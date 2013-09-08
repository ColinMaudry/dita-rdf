<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#"
	xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:nie="http://www.semanticdesktop.org/ontologies/2007/01/19/nie#"
	xmlns:nfo="http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#"
	xmlns:xs="http://www.w3.org/2001/XMLSchema#"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:dita="http://purl.org/dita/ns#"
	xmlns:schema="http://schema.org/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:colin="http://zebrana.net/"
	xmlns:doc="http://www.oxygenxml.com/ns/doc/xsl">
	<!--
This stylesheet is part of the dita2rdf DITA Open toolkit plugin, available at https://github.com/ColinMaudry/dita-rdf  
This project project is driven by Colin Maudry and licensed under a CC BY-SA Unported 3 license.
-->
	
	<xsl:import href="rdf/map2rdf.xsl"/>
	<xsl:import href="rdf/topic2rdf.xsl"/>
	<xsl:import href="params.xsl"/>
	<dita:extension id="dita.xsl.rdf" behavior="org.dita.dost.platform.ImportXSLAction" xmlns:dita="http://dita-ot.sourceforge.net"/>
	<xsl:param name="rdfBaseURI">http://www.w3.org/1999/02/22-rdf-syntax-ns#</xsl:param>
	<xsl:param name="rdfsBaseURI">http://www.w3.org/2000/01/rdf-schema#</xsl:param>
	<xsl:param name="skosBaseURI">http://www.w3.org/2004/02/skos/core#</xsl:param>
	<xsl:param name="foafBaseURI">http://xmlns.com/foaf/0.1/</xsl:param>
	<xsl:param name="dctermsBaseURI">http://purl.org/dc/terms/</xsl:param>
	<xsl:param name="nieBaseURI">http://www.semanticdesktop.org/ontologies/2007/01/19/nie#</xsl:param>
	<xsl:param name="nfoBaseURI">http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#</xsl:param>
	<xsl:param name="xsBaseURI">http://www.w3.org/2001/XMLSchema#</xsl:param>
	<xsl:param name="ditaBaseURI">http://purl.org/dita/ns#</xsl:param>
	<xsl:param name="schemaBaseURI">http://schema.org/</xsl:param>
	
	
	
	<xsl:output method="xml" indent="no" omit-xml-declaration="no" standalone="no" media-type="application/rdf+xml"/>
	
	<doc:doc>
		<doc:desc>Merged maps and topics (output of topicmerge.xsl)</doc:desc>
	</doc:doc>
	<xsl:template match="/">
		<rdf:RDF xmlns:rdf="{$rdfBaseURI}"
			xmlns:rdfs="{$rdfsBaseURI}"
			xmlns:skos="{$skosBaseURI}"
			xmlns:foaf="{$foafBaseURI}"
			xmlns:dcterms="{$dctermsBaseURI}"
			xmlns:nie="{$nieBaseURI}"
			xmlns:nfo="{$nfoBaseURI}"
			xmlns:xs="{$xsBaseURI}"
			xmlns:dita="{$ditaBaseURI}"
			xmlns:schema="{$schemaBaseURI}">
			<xsl:apply-templates/>
		</rdf:RDF>
	</xsl:template>
	
	<doc:doc>
		<doc:desc>Elements and attributes that are not specifically matched by a template are ignored.</doc:desc>
	</doc:doc>
	<xsl:template match="* | @* | node()"/>
	
	<!-- Function that processes profiling attributes 
	<xsl:function name="colin:getProfilingAttributes">
		
	</xsl:function>-->	
	
	<xsl:function name="colin:getInformationObjectUri">
		<xsl:param name="resourceBaseUri"/>
		<xsl:param name="resourceFamily"/>
		<xsl:param name="resourceLanguage"/>
		<xsl:param name="resourceId"/>
		<xsl:variable name="languageCode">
			<xsl:if test="$resourceLanguage != ''">
				<xsl:value-of select="concat($resourceLanguage,'/')"/>
			</xsl:if>
		</xsl:variable>
		<xsl:value-of select="concat($resourceBaseUri,$resourceFamily,'/',$languageCode,$resourceId)"/>
	</xsl:function>

	<xsl:function name="colin:getElementType">
		<xsl:param name="class"/>
		<xsl:param name="elementName"/>
		<xsl:variable name="className" select="concat(upper-case(substring($elementName,1,1)),
			substring($elementName, 2))"/>
	<!--		<xsl:choose>
		<xsl:when test="contains($userSpecializations/s,$class)">
				<xsl:value-of select="xsd:anyURI(concat($specializationsBaseURI,$className))"/>
			</xsl:when>
			<xsl:otherwise>-->
				<xsl:value-of select="xsd:anyURI(concat($ditaBaseURI,$className))"/>
	<!--		</xsl:otherwise>
		</xsl:choose>-->
	</xsl:function>
	
</xsl:stylesheet>