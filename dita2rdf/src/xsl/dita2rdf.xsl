<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="colin doc xs" version="2.0" xmlns:colin="http://colin.maudry.com/" xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:dita="http://purl.org/dita/ns#" xmlns:doc="http://www.oxygenxml.com/ns/doc/xsl" xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:schema="http://schema.org/"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
	<xsl:import href="params.xsl"/>
	<xsl:import href="rdf/datasetMetadata.xsl"/>
	<xsl:import href="rdf/base2rdf.xsl"/>
	<xsl:import href="rdf/map2rdf.xsl"/>
	<xsl:import href="rdf/topic2rdf.xsl"/>
	<xsl:import href="rdf/bookmap2rdf.xsl"/>
	
	<xsl:output encoding="UTF-8" indent="yes" media-type="application/rdf+xml" method="xml" omit-xml-declaration="no"/>
	<xsl:strip-space elements="*"/>
	<xsl:param name="work.dir.url"/>

 
	<doc:doc>
		<doc:desc>Temporary maps and topics (output of copy-files)</doc:desc>
	</doc:doc>
	<xsl:template match="/">
		<xsl:param name="currentUri" select="document-uri(/)"/>
		<xsl:variable name="rootId">
			<xsl:call-template name="colin:getRootId">
				<xsl:with-param name="rootElement" select="/*" as="node()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="rootLangForPath">
			<xsl:if test="/*/@xml:lang!=''">
				<xsl:value-of select="concat(/*/@xml:lang,'/')"/>
			</xsl:if>
		</xsl:variable>
		<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dita="http://purl.org/dita/ns#" xmlns:doc="http://www.oxygenxml.com/ns/doc/xsl" xmlns:foaf="http://xmlns.com/foaf/0.1/"
			xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
			xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xml:base="http://purl.org/dita/ns#">
			<xsl:apply-templates>
				<xsl:with-param name="currentUri" select="$currentUri" tunnel="yes"/>
			</xsl:apply-templates>
			<xsl:result-document method="xml" href="{$work.dir.url}docmeta.xml">
				<doc>
					<id>
						<xsl:value-of select="$rootId"/>
					</id>
					<lang>
						<xsl:value-of select="$rootLangForPath"/>
					</lang>
				</doc>
			</xsl:result-document>
			<xsl:call-template name="colin:datasetMetadata">
				<xsl:with-param name="xtrf" select="/*/@xtrf" as="xs:anyURI"/>
				<xsl:with-param name="rootId" select="$rootId"/>
				<xsl:with-param name="rootLang" select="$rootLangForPath"/>
				<xsl:with-param name="rootTitle">
					<xsl:choose>
						<xsl:when test="/*/*[contains(@class,' topic/title ')]//text()">
							<xsl:value-of select="/*/*[contains(@class,' topic/title ')]"/>
						</xsl:when>
						<xsl:when test="/*/@title!=''">
							<xsl:value-of select="/*/@title"/>
					</xsl:when>
						<xsl:when test="/*/*[contains(@class,' bookmap/booktitle ')]/*[contains(@class,' bookmap/mainbooktitle ')]//text()">
							<xsl:value-of select="/*/*[contains(@class,' bookmap/booktitle ')]/*[contains(@class,' bookmap/mainbooktitle ')]"/>
						</xsl:when>
						<xsl:otherwise/>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>
		</rdf:RDF>
	</xsl:template>	

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

	<xsl:function as="xs:anyURI" name="colin:getInternalObjectUri">
		<xsl:param name="documentUri"/>
		<xsl:param name="xtrc"/>
		<xsl:param name="id"/>
		<xsl:variable name="localIdentifier" select="if ($id!='') then $id else $xtrc"/>
		<xsl:value-of select="concat($documentUri,'#',$localIdentifier)"/>
	</xsl:function>
	
	<xsl:function as="xs:anyURI" name="colin:cleanDitaHref">
		<xsl:param name="ditaHref"/>
		<xsl:param name="currentUri"/>
		<xsl:variable name="cleanHref">
		<xsl:choose>
			<xsl:when test="contains($ditaHref,'#')">
				<xsl:value-of select="substring-before($ditaHref,'#')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$ditaHref"/>
			</xsl:otherwise>
		</xsl:choose>
		</xsl:variable>
		<xsl:variable name="baseUri">
			<xsl:choose>
				<xsl:when test="contains($currentUri,':/')">
					<xsl:value-of select="$currentUri"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('file:/',translate($currentUri,'\','/'))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="resolve-uri($cleanHref,$baseUri)"/>
	</xsl:function>

	<xsl:function name="colin:getDomainId">
		<!-- Thanks Jeni Tennison: http://www.biglist.com/lists/xsl-list/archives/200111/msg00460.html -->
		<xsl:param as="xs:string" name="class"/>
		<xsl:variable name="noTrailingSpace" select="normalize-space($class)"/>
		<xsl:choose>
			<xsl:when test="contains($noTrailingSpace, ' ')">
				<xsl:value-of select="colin:getDomainId(substring-after($noTrailingSpace, ' '))"></xsl:value-of>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring-before($noTrailingSpace,'/')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<xsl:template name="colin:getRdfTypes">
		<xsl:param as="attribute(class)" name="class"/>
		<xsl:variable name="firstCharRemoved" select="substring($class,2)"/>
		<xsl:for-each select="tokenize(normalize-space($firstCharRemoved),' ')">
			<xsl:variable name="domainId" select="substring-before(.,'/')"/>
			<xsl:variable name="classBaseUri" select="$config/config/domains/domain[@domainId=$domainId]/@baseUri"/>
			<xsl:variable name="elementName" select="substring-after(.,'/')"/>
			<xsl:variable name="className" select="concat(upper-case(substring($elementName, 1,1)), substring($elementName, 2))"/>
			<rdf:type rdf:resource="{concat($classBaseUri,$className)}"/>
		</xsl:for-each>
		<xsl:if test="contains($class,' topic/topic ') or contains($class,' map/map ') ">
			<rdf:type rdf:resource="http://purl.org/dita/ns#Doctype"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="colin:processElementAsProperty">
		<!-- If the domain ID is not registered in config.xml, the property has NO namespace/baseUri. I don't want that for standard DITA domains, you don't want that for your specializations' domains. -->
		<xsl:param name="documentUri" tunnel="yes"/>
		<xsl:param name="objectType" as="xs:string"/>
		<xsl:param name="hasLanguage" as="xs:boolean?"/>
		<xsl:param name="genericProperty" as="xs:boolean?"/>
		<xsl:variable name="class" as="attribute(class)" select="@class"/>
		<xsl:variable name="domainId" as="xs:string" select="colin:getDomainId(string($class))"/>
		<xsl:variable name="namespace" select="if ($genericProperty = true()) then $config/config/domains/domain[@domainId='topic']/@baseUri else $config/config/domains/domain[@domainId=$domainId]/@baseUri"/>
		<xsl:variable name="elementName" select="if ($genericProperty = true()) then 'element' else local-name()"/>
		<xsl:element name="{$elementName}" namespace="{$namespace}">
			<xsl:choose>
				<xsl:when test="$objectType = 'resource'">
					<rdf:Description>
						<xsl:attribute name="rdf:about" select="colin:getInternalObjectUri($documentUri,@xtrc,@id)"/>
						<xsl:apply-templates select="@id"/>
						<xsl:call-template name="colin:getRdfTypes">
							<xsl:with-param name="class" select="@class"/>
						</xsl:call-template>
						<xsl:call-template name="colin:ditaText"/>
					</rdf:Description>
				</xsl:when>
				<xsl:when test="$objectType = 'literal'">
					<xsl:if test=".//text()">
						<xsl:if test="$hasLanguage = true()">
							<xsl:call-template name="colin:getLanguageAtt"/>
						</xsl:if>
						<xsl:value-of select="normalize-space(.)"/>
					</xsl:if>
				</xsl:when>
			</xsl:choose>
		</xsl:element>
		<!-- This apply-templates might lead to surprises :) -->
		<xsl:apply-templates select="*"/>
	</xsl:template>
	
	<!-- The beauty of the tunnels: whenever @xml:lang is found, the $language param is set or reset and passed to the next templates. -->
	<xsl:template match="@xml:lang[.!='']">
		<xsl:param name="language"/>
		<xsl:apply-templates>
			<xsl:with-param name="language" select="." tunnel="yes"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template name="colin:getLanguageAtt">
		<xsl:param name="language" tunnel="yes"/>
		<xsl:if test="$language !=''">
			<xsl:attribute name="xml:lang" select="$language"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="colin:getRootId">
		<xsl:param name="rootElement" as="node()"/>
		<xsl:value-of select="if ($rootElement/@id!='') then $rootElement/@id else generate-id($rootElement)"/>
	</xsl:template>
	
	<xsl:template name="colin:justGetTheUri">
		<xsl:param name="resolvedCurrentUri"/>
		<xsl:param name="language" tunnel="yes"/>
		<xsl:variable name="targetDocumentRoot" select="document($resolvedCurrentUri)/*" as="node()"/>
		<xsl:variable name="targetDocumentLang">
			<xsl:choose>
				<xsl:when test="$targetDocumentRoot/@xml:lang!=''">
					<xsl:value-of select="$targetDocumentRoot/@xml:lang"/>
				</xsl:when>
				<xsl:otherwise>
<!-- You'd better have @xml:lang set in your files...
			If you xref to a topic that has a different language, it will inherit the language from the xref. 
			For instance, from an 'fr-FR' topic to an 'en-UK' topic, if the 'en-UK' doesn't have @xml:lang, it gets the URI of an 'fr-FR' topic.-->
					<xsl:value-of select="$language"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:attribute name="rdf:resource" select="colin:getInformationObjectUri($targetDocumentRoot/local-name(),$targetDocumentLang,$targetDocumentRoot/@id)"/>
	</xsl:template>
</xsl:stylesheet>
