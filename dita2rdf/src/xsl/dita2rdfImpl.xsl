<?xml version="1.0" encoding="utf-8"?>
<!--
 Copyright 2013, Colin Maudry
	
 This file is part of the DITA RDF plugin for the DITA Open toolkit.
 
    The DITA RDF plugin is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    
    The DITA RDF plugin is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    
    You should have received a copy of the GNU General Public License
    along with the DITA RDF plugin.  If not, see <http://www.gnu.org/licenses/>.
-->
<xsl:stylesheet version="2.0" xmlns:colin="http://colin.maudry.com/" xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:dita="http://purl.org/dita/ns#" xmlns:doc="http://www.oxygenxml.com/ns/doc/xsl"
	xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:nfo="http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#"
	xmlns:nie="http://www.semanticdesktop.org/ontologies/2007/01/19/nie#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:schema="http://schema.org/" xmlns:skos="http://www.w3.org/2004/02/skos/core#"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="params.xsl"/>
	<xsl:import href="rdf/map2rdf.xsl"/>
	<xsl:import href="rdf/topic2rdf.xsl"/>
	<!--<ditasf:extension id="dita.xsl.rdf" behavior="org.dita.dost.platform.ImportXSLAction" xmlns:ditasf="http://dita-ot.sourceforge.net"/>-->

	<xsl:output encoding="UTF-8" indent="yes" media-type="application/rdf+xml" method="xml" omit-xml-declaration="no"
		standalone="yes"/>

	<doc:doc>
		<doc:desc>Merged maps and topics (output of topicmerge.xsl)</doc:desc>
	</doc:doc>
	<xsl:template match="/">
		<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dita="http://purl.org/dita/ns#"
			xmlns:doc="http://www.oxygenxml.com/ns/doc/xsl" xmlns:foaf="http://xmlns.com/foaf/0.1/"
			xmlns:nfo="http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#"
			xmlns:nie="http://www.semanticdesktop.org/ontologies/2007/01/19/nie#" xmlns:ot="http://www.idiominc.com/opentopic"
			xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
			xmlns:skos="http://www.w3.org/2004/02/skos/core#"
			xmlns:xsd="http://www.w3.org/2001/XMLSchema#">
			<xsl:apply-templates/>
		</rdf:RDF>
	</xsl:template>

	<doc:doc>
		<doc:desc>Elements and attributes that are not specifically matched by a template are ignored.</doc:desc>
	</doc:doc>


	<!-- Function that processes profiling attributes 
	<xsl:function name="colin:getProfilingAttributes">
		
	</xsl:function>-->

	<xsl:function as="xs:anyURI" name="colin:getInformationObjectUri">
		<xsl:param name="resourceFamily"/>
		<xsl:param name="resourceLanguage"/>
		<xsl:param name="resourceId"/>
		<xsl:variable name="resourceBaseUri" select="$config/config/resourcesBaseUri/@uri"/>
		<xsl:variable name="languageCode">
			<xsl:if test="$resourceLanguage != ''">
				<xsl:value-of select="concat($resourceLanguage,'/')"/>
			</xsl:if>
		</xsl:variable>
		<xsl:value-of select="concat($resourceBaseUri,$resourceFamily,'/',$languageCode,$resourceId)"/>
	</xsl:function>

	<xsl:function as="xs:anyURI" name="colin:getReferenceObjectUri">
		<xsl:param name="documentUri"/>
		<xsl:param name="xtrc"/>
		<xsl:value-of select="concat($documentUri,'/',$xtrc)"/>
	</xsl:function>

	<xsl:template as="attribute(xml:lang)?" name="colin:getLanguageAtt">
		<xsl:param name="topicLanguage" tunnel="yes"/>
		<xsl:param name="mapLanguage" tunnel="yes"/>
		<xsl:choose>
			<xsl:when test="$topicLanguage !=''">
				<xsl:attribute name="xml:lang">
					<xsl:value-of select="$topicLanguage"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:when test="$mapLanguage !=''">
				<xsl:attribute name="xml:lang">
					<xsl:value-of select="$mapLanguage"/>
				</xsl:attribute>
			</xsl:when>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="colin:getRdfTypes">
		<xsl:param as="xs:string" name="class"/>
		<xsl:variable name="firstCharRemoved" select="substring($class,2)"/>
		<xsl:for-each select="tokenize(normalize-space($firstCharRemoved),' ')">
			<xsl:variable name="domainId" select="substring-before(.,'/')"/>
			<xsl:message>
				<xsl:value-of select="$domainId"/>
			</xsl:message>
			<xsl:variable name="classBaseUri" select="$config/config/domains/domain[@domainId=$domainId]/@baseUri"/>
			<xsl:variable name="elementName" select="substring-after(.,'/')"/>
			<xsl:variable name="className" select="concat(upper-case(substring($elementName, 1,1)),
				substring($elementName, 2))"/>
			<rdf:type rdf:resource="{concat($classBaseUri,$className)}"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="*[contains(@class,' topic/title ')] | @title[../*[contains(@class,' map/map ')]]">
		<dita:title>
			<xsl:call-template name="colin:getLanguageAtt"/>			
			<xsl:value-of select="."/>
		</dita:title>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/author ')]">
		<dita:author>
			<xsl:apply-templates/>
		</dita:author>
	</xsl:template>
	<doc:doc>
		<doc:desc>Template for @href that have a DITA file as target. Target metadata is retrieved.</doc:desc>
	</doc:doc>
	<xsl:template match="@ohref[../@format='dita' or ../@format='ditamap' or contains(.,'.dita')]">
		<xsl:variable name="topicId" select="../@id"/>
		<xsl:message>Href template</xsl:message>
		<dita:href>
			<xsl:apply-templates select="/*//*[@id = $topicId][contains(@class,' map/map ') or contains(@class,' topic/topic ')]"/>
		</dita:href>
	</xsl:template>
	<doc:doc>
		<doc:desc>Template for @href that have a non-DITA target. Target metadata is not retrieved.</doc:desc>
	</doc:doc>
	<xsl:template match="@ohref">
		<dita:href rdf:resource="{.}"/>
	</xsl:template>
</xsl:stylesheet>