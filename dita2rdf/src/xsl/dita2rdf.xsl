<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="colin doc xs" version="2.0" xmlns:colin="http://colin.maudry.com/" xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:dita="http://purl.org/dita/ns#" xmlns:doc="http://www.oxygenxml.com/ns/doc/xsl" xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:nfo="http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#" xmlns:nie="http://www.semanticdesktop.org/ontologies/2007/01/19/nie#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:schema="http://schema.org/"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="params.xsl"/>
	<xsl:import href="rdf/map2rdf.xsl"/>
	<xsl:import href="rdf/topic2rdf.xsl"/>

	<xsl:output encoding="UTF-8" indent="yes" media-type="application/rdf+xml" method="xml" omit-xml-declaration="no"/>

	<doc:doc>
		<doc:desc>Temporary maps and topics (output of copy-files)</doc:desc>
	</doc:doc>
	<xsl:template match="/">
		<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dita="http://purl.org/dita/ns#" xmlns:doc="http://www.oxygenxml.com/ns/doc/xsl" xmlns:foaf="http://xmlns.com/foaf/0.1/"
			xmlns:nfo="http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#" xmlns:nie="http://www.semanticdesktop.org/ontologies/2007/01/19/nie#"
			xmlns:ot="http://www.idiominc.com/opentopic" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
			xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#">
			<xsl:apply-templates/>
		</rdf:RDF>
	</xsl:template>
	<xsl:template match="/" mode="not-root-document">
		<xsl:apply-templates/>
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
			<xsl:variable name="classBaseUri" select="$config/config/domains/domain[@domainId=$domainId]/@baseUri"/>
			<xsl:variable name="elementName" select="substring-after(.,'/')"/>
			<xsl:variable name="className" select="concat(upper-case(substring($elementName, 1,1)), substring($elementName, 2))"/>
			<rdf:type rdf:resource="{concat($classBaseUri,$className)}"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="
		*[contains(@class, ' topic/topic ')]/*[contains(@class,' topic/title ')] |
		*[contains(@class, ' map/map ')]/*[contains(@class,' topic/title ')] |
		@title[../*[contains(@class,' map/map ')]]">
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
	<xsl:template match="@keyref"> </xsl:template>
	<xsl:template match="@href[../@format and not(../@format['dita' or 'ditamap'])]">
		<dita:href rdf:resource="{.}"/>
		<dita:format>
			<xsl:value-of select="../@format"/>
		</dita:format>
	</xsl:template>
	<xsl:template match="@href[contains(.,'.dita')] | @href[../@format['dita' or 'ditamap']]">
		<xsl:variable name="documentHref">
			<xsl:choose>
				<xsl:when test="contains(.,'#')">
					<xsl:value-of select="concat(substring-before(.,'#'),'#',substring-before(substring-after(.,'#'),'/'))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<dita:href>
			<xsl:apply-templates select="document($documentHref, /)/*"/>
		</dita:href>
	</xsl:template>
	<xsl:template match="@href[contains(.,'.xml') and not(../@format)]">
		<xsl:choose>
			<xsl:when test="document(., /)/*[@class][@domains]">
				<!-- Looks like DITA... -->
				<dita:href>
					<xsl:apply-templates select="document(., /)/*"/>
				</dita:href>
			</xsl:when>
			<xsl:otherwise>
				<dita:href rdf:resource="{.}"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<doc:doc>
		<doc:desc>Catch all template for reference objects (that have a non-empty @href). Topicref, image, xref, etc.</doc:desc>
	</doc:doc>
	<xsl:template match="*[@href and @href!='']">
		<xsl:param name="documentUri" tunnel="yes"/>
		<xsl:param name="debug" select="$debug"/>
		<xsl:if test="$debug='1'">
			<xsl:message>
				<xsl:value-of select="concat(@xtrf,'/',@xtrc)"/>
			</xsl:message>
		</xsl:if>
		<dita:referenceObject>
			<rdf:Description rdf:about="{colin:getReferenceObjectUri($documentUri,@xtrc)}">
				<xsl:call-template name="colin:getRdfTypes">
					<xsl:with-param name="class" select="@class"/>
				</xsl:call-template>
				<xsl:apply-templates select=".[@href]/@keys"/>
				<xsl:apply-templates select="@keyref"/>
				<xsl:if test="not(@keys) and not(@keyref)">
					<xsl:apply-templates select="@href[not('')]"/>
				</xsl:if>
				<!-- For now, only extract keys if they have references 
							Only extract @href if no @keys-->
			</rdf:Description>
		</dita:referenceObject>
		<!-- Nesting (e.g. of topicref) is not extracted. Not considered meaningful for the purpose of metadata querying. -->
		<xsl:apply-templates/>
	</xsl:template>
</xsl:stylesheet>
