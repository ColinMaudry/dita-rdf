<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:colin="http://colin.maudry.com/"
	xmlns:doc="http://www.oxygenxml.com/ns/doc/xsl"
	xmlns:s="http://www.w3.org/2005/sparql-results#"
	exclude-result-prefixes="colin doc s">
	<xsl:import href="browser/queries.xsl"/>
	<xsl:import href="browser/allMaps.xsl"/>
	<xsl:import href="browser/allTopics.xsl"/>
	<xsl:import href="browser/view/context.xsl"/>
	<xsl:import href="browser/view/map.xsl"/>
	<xsl:import href="browser/view/topic.xsl"/>	
	<xsl:import href="browser/view/table.xsl"/>
	<xsl:import href="browser/view/stats.xsl"/>
	
	<xsl:param name="sparql"/>
	<xsl:param name="outputFolder"/>
	<xsl:param name="pluginDir"/>
	<!--<xsl:param name="$0" select="document(concat($pluginDir,'/html/browserTemplate.html'))"/>-->
	<xsl:param name="configpath">cfg:rdf/config.xml</xsl:param>
	<xsl:param name="config" select="document($configpath)"></xsl:param>
	<xsl:strip-space elements="*"/>
	<xsl:output method="xhtml" encoding="UTF-8"/>
	
	<xsl:template match="/">
		<xsl:variable name="contexts" as="element()">
			<xsl:call-template name="colin:getData">
				<xsl:with-param name="queryName" select="'contexts'"/>
				<xsl:with-param name="uri"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:apply-templates>
			<xsl:with-param name="data" select="$contexts" as="element()" tunnel="yes"/>
			<xsl:with-param name="currentPageType" select="'contexts'" tunnel="yes"/>			
		</xsl:apply-templates>
		<xsl:call-template name="context">
			<xsl:with-param name="template" select="/" tunnel="yes"/>
			<xsl:with-param name="data" select="$contexts" as="element()"/>
		</xsl:call-template>
		<xsl:call-template name="maps">
			<xsl:with-param name="template" select="/" tunnel="yes"/>
			<xsl:with-param name="data" as="element()">
				<xsl:call-template name="colin:getData">
					<xsl:with-param name="queryName" select="'maps'"/>
					<xsl:with-param name="uri"></xsl:with-param>
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="topics">
			<xsl:with-param name="template" select="/" tunnel="yes"/>
			<xsl:with-param name="data" as="element()">
				<xsl:call-template name="colin:getData">
					<xsl:with-param name="queryName" select="'topics'"/>
					<xsl:with-param name="uri"></xsl:with-param>
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="div[@id='sidebar']">
		<xsl:param name="data" tunnel="yes"/>
		<xsl:param name="currentPageType" tunnel="yes"/>
		<xsl:param name="objectInfo" tunnel="yes"/>
		<xsl:choose>
			<xsl:when test="$currentPageType='contexts'">
				<xsl:call-template name="colin:homeSidebar"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="inboundData">
					<xsl:call-template name="colin:getData">
						<xsl:with-param name="queryName" select="'inbound'"/>
						<xsl:with-param name="uri" select="$objectInfo/s:binding[@name='thing']/s:uri"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:call-template name="inboundTable">
					<xsl:with-param name="inboundData" select="$inboundData"></xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	
	<xsl:template match="div[@id='content']">
		<xsl:param name="currentPageType" tunnel="yes"/>
		<xsl:param name="data" tunnel="yes"/>
		<xsl:param name="objectInfo" tunnel="yes"/>
		<xsl:variable name="query">
			<xsl:value-of select="$queries/query[@name='contexts']"/>
		</xsl:variable>
		<xsl:variable name="title">
			<xsl:choose>
				<xsl:when test="$currentPageType='contexts'">Contexts</xsl:when>
				<xsl:otherwise>
					<span class="label label-default"><xsl:value-of select="colin:prettifyVariableName($currentPageType)"/></span>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$objectInfo/s:binding[@name='title']/s:literal"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<div>
			<xsl:apply-templates select="@*"/>
			<div class="well well-sm" id="datanav" style="position: fixed; width: 100%;">
				<h1><xsl:copy-of select="$title"/></h1>
				<a class="btn btn-primary" role="button" href="#links">Links</a>
				<a class="btn btn-primary" role="button" href="#stats">Stats</a>
			</div>
			<xsl:apply-templates select="$data" mode="table">
				<xsl:with-param name="location" select="'center'"/>
			</xsl:apply-templates>
			<xsl:call-template name="stats"/>
		</div>
	</xsl:template>
	
<!--	<xsl:template match="* | node()" mode="sidebar">
		<xsl:apply-templates mode="sidebar"/>
	</xsl:template>-->
	
	<xsl:template mode="sidebar" match="s:result">
		<xsl:param name="currentPageType" tunnel="yes"/>
		<xsl:variable name="path" select="colin:uri2path($currentPageType,s:binding[@name='thing']/s:uri)"/>
		<a href="{$path}" class="list-group-item"><xsl:value-of select="s:binding[@name='title']/s:literal"></xsl:value-of></a>
	</xsl:template>
	
	<xsl:function name="colin:uri2path">
		<xsl:param name="currentPageType"/>
		<xsl:param name="uri"/>
		<xsl:variable name="uriPath" select="substring-after($uri,$config/config/resourcesBaseUri/@uri)"/>
		<xsl:if test="$currentPageType='contexts'">
			<xsl:text>resources/</xsl:text>
		</xsl:if>
		<xsl:value-of select="concat(translate($uriPath,'/','_'),'.html')"/>
	</xsl:function>
	
	<xsl:function name="colin:prettifyVariableName">
		<xsl:param name="variable"/>
		<xsl:variable name="withSpaces" select="translate($variable,'_',' ')"/>
		<xsl:variable name="lowerCase" select=" lower-case($withSpaces)"/>
		<xsl:variable name="capitalizeFirstLetter" select="concat(upper-case(substring($lowerCase, 1,1)), substring($lowerCase, 2))"/>
		<xsl:value-of select="$capitalizeFirstLetter"/>
	</xsl:function>
	
	<xsl:template name="colin:homeSidebar">
		<div class="col-sm-3" id="sidebar" role="navigation">
			<a href="http://purl.org/dita/ditardf-project" class="list-group-item">DITA RDF project</a>
		</div>
	</xsl:template>
	
	<xsl:template match="@href[not(starts-with(.,'http'))] | @src[not(starts-with(.,'http'))]">
		<xsl:param name="currentPageType" tunnel="yes"/>
		<xsl:attribute name="{local-name()}">
			<xsl:if test="$currentPageType != 'contexts'">
				<xsl:text>../</xsl:text>
			</xsl:if>
			<xsl:value-of select="."/>
		</xsl:attribute>
	</xsl:template>
	
</xsl:stylesheet>
