<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#"
	xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:nie="http://www.semanticdesktop.org/ontologies/2007/01/19/nie#"
	xmlns:nfo="http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dita="http://purl.org/dita/ns#"
	xmlns:schema="http://schema.org/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:colin="http://colin.maudry.com/"
	xmlns:doc="http://www.oxygenxml.com/ns/doc/xsl"
	xmlns:ot="http://www.idiominc.com/opentopic"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema#">
	
	<doc:doc>
		<doc:desc>The root template for maps.</doc:desc>
	</doc:doc>
	
	<!-- Map specific functions -->
	<xsl:function name="colin:getKeyUri">
		<xsl:param name="documentUri"/>
		<xsl:param name="keyname"/>
		<xsl:value-of select="concat($documentUri,'/keys/',$keyname)"/>
	</xsl:function>
	
	
	
	<xsl:template match="*[contains(@class,' map/map ')]">
		<xsl:param name="mapLanguage">
			<xsl:value-of select="@xml:lang"/>
		</xsl:param>
		<xsl:param name="mapId" select="if (@id!='') then @id else generate-id()"/>
		<xsl:param name="mapUri">
			<xsl:value-of select="colin:getInformationObjectUri(local-name(),@xml:lang,$mapId)"/>
		</xsl:param>
			
		<rdf:Description rdf:about="{$mapUri}">
			<xsl:call-template name="colin:getLanguageAtt">
				<xsl:with-param name="topicLanguage"/>
				<xsl:with-param name="mapLanguage" select="$mapLanguage" tunnel="yes"/>
			</xsl:call-template>
			<xsl:call-template name="colin:getRdfTypes">
				<xsl:with-param name="class" select="@class"/>
			</xsl:call-template>
			<dita:id>
				<xsl:value-of select="$mapId"/>
			</dita:id>
			
			<xsl:apply-templates>
				<xsl:with-param name="mapLanguage" select="$mapLanguage" tunnel="yes"/>
				<xsl:with-param name="mapUri" select="$mapUri" tunnel="yes"/>
			</xsl:apply-templates>			
		</rdf:Description>		
	</xsl:template>
		
	<xsl:template match="*[contains(@class, ' map/topicref ')]">
		<xsl:param name="mapUri" tunnel="yes"/>
		<dita:referenceObject>
			<rdf:Description rdf:about="{colin:getReferenceObjectUri($mapUri,@xtrc)}">
				<xsl:call-template name="colin:getRdfTypes">
					<xsl:with-param name="class" select="@class"/>
				</xsl:call-template>
				<xsl:apply-templates select=".[@href]/@keys"/>
				<xsl:apply-templates select="@keyref"/>
				<xsl:if test="not(@keys) and not(@keyref)">
					<xsl:apply-templates select="@href[not('')]"/>
				</xsl:if>
				<!-- For now, only extract keys if they are references 
							Only extract @href if no @keys-->
			</rdf:Description>
		</dita:referenceObject>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="@keys">
		<xsl:param name="mapUri" tunnel="yes"/>
		<xsl:variable name="base" select="translate(../@xtrf,'\','/')"/>
		<xsl:variable name="relative" select="../@href"></xsl:variable>
		<xsl:for-each select="tokenize(.,' ')">
			<dita:key>
				<dita:Key rdf:about="{colin:getKeyUri($mapUri,.)}">
					<dita:href rdf:resource="{resolve-uri($relative,$base)}"/>
				</dita:Key>
			</dita:key>
		</xsl:for-each>
	</xsl:template>
	<doc:doc>
		<doc:desc>Passthrough template for maps</doc:desc>
	</doc:doc>
	<xsl:template match="*[contains(@class, ' map/topicmeta ')]">
		<xsl:apply-templates/>
	</xsl:template>
</xsl:stylesheet>
