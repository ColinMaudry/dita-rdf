<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
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
	
	<!-- Map specific functions -->
	<xsl:function name="colin:getKeyUri">
		<xsl:param name="documentUri"/>
		<xsl:param name="keyname"/>
		<xsl:value-of select="concat($documentUri,'/keys/',$keyname)"/>
	</xsl:function>
	
	<!-- For now, only keydef that defines an href are supported (not key-keywords) -->
	<xsl:template match="@keys[../@href]">
		<xsl:param name="documentUri" tunnel="yes"/>
		<xsl:param name="currentUri" tunnel="yes"/>
		<xsl:variable name="keynode" select=".."/>
		<xsl:variable name="targetDocument">
			<xsl:choose>
				<xsl:when test="../@href[contains(.,'.dita')] | ../@href[../@format='dita' or ../@format='ditamap'] | ../@href[contains(.,'.xml') and not(../@format)]">
					<!-- I won't be able to use document() in the for each because I won't be in the context of a document node. I consequently need to store the XML tree of the target file in a variable, to process it afterward. -->
					<xsl:copy-of select="document(colin:cleanDitaHref(../@href,$currentUri))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text></xsl:text>					
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each select="tokenize(., ' ')">
					<dita:key>
						<dita:Key rdf:about="{colin:getKeyUri($documentUri,.)}">
							<dita:keyname><xsl:value-of select="."/></dita:keyname>
							<xsl:apply-templates select="$keynode/@href">
								<xsl:with-param name="targetDocument" select="$targetDocument"/>
							</xsl:apply-templates>
						</dita:Key>
					</dita:key>
		</xsl:for-each>
	</xsl:template>
	<!-- Keywords as variables using keydef -->
	<!-- If a keydef has both @href and a keyword, the keyword has priority -->
	<xsl:template match="@keys[../*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/keywords ')]/*[contains(@class,' topic/keyword ')]]" priority="2">
		<xsl:param name="documentUri" tunnel="yes"/>
		<xsl:variable name="keynode" select=".."/>
		<xsl:for-each select="tokenize(., ' ')">
			<dita:key>
				<dita:Key rdf:about="{colin:getKeyUri($documentUri,.)}">
					<dita:keyname><xsl:value-of select="."/></dita:keyname>
					<xsl:apply-templates select="$keynode/*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/keywords ')]/*[contains(@class,' topic/keyword ')]"/>
				</dita:Key>
			</dita:key>
		</xsl:for-each>
	</xsl:template>	
	<xsl:template match="*[contains(@class, ' map/topicref ')][not(@href) and not(@keys) and not(*[contains(@class, ' map/topicmeta ')])]">
		<xsl:apply-templates/>
	</xsl:template>
	<!--<xsl:template match="*[contains(@class, ' map/topicref ')][@keys]">
		<xsl:element name="{concat('dita:',local-name())}">
			<xsl:apply-templates select="@keys"/>
		</xsl:element>
	</xsl:template>-->
	<doc:doc>
		<doc:desc>Passthrough template for maps</doc:desc>
	</doc:doc>
	<xsl:template match="*[contains(@class, ' map/topicmeta ')]">
		<xsl:apply-templates/>
	</xsl:template>
	<!-- For now, metadata cascading is limited to language -->
	<xsl:template match="*[contains(@class, ' map/topicref ')]/*[contains(@class, ' map/topicmeta ')]" priority="2"/>
</xsl:stylesheet>
