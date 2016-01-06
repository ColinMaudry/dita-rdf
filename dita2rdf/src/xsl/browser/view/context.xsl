<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:colin="http://colin.maudry.com/"
	xmlns:doc="http://www.oxygenxml.com/ns/doc/xsl" xmlns:s="http://www.w3.org/2005/sparql-results#" 
	exclude-result-prefixes="colin xs doc s">
	<xsl:template name="context">
		<xsl:param name="data"/>
		<!-- This template goes through each data set and make an HTML file. -->
		<xsl:apply-templates select="$data/s:results/s:result" mode="context"/>	
		
	</xsl:template>
	
	<xsl:template mode="context" match="s:result">
		<xsl:param name="template" tunnel="yes"/>
		<xsl:result-document method="xhtml" href="{$outputFolder}/{colin:uri2path('context',s:binding[@name='thing']/s:uri)}">
			<xsl:call-template name="contextPage">
				<xsl:with-param name="objectInfo" select="." tunnel="yes"/>
			</xsl:call-template>
		</xsl:result-document>		
	</xsl:template>
	
	<xsl:template name="contextPage">
		<xsl:param name="objectInfo" tunnel="yes"/>
		<xsl:param name="template" tunnel="yes"/>
		<xsl:apply-templates select="$template/*">
			<xsl:with-param name="data" as="element()" tunnel="yes">
				<xsl:call-template name="colin:getData">
					<xsl:with-param name="queryName">context</xsl:with-param>
					<xsl:with-param name="uri" select="$objectInfo/s:binding[@name='thing']/s:uri"></xsl:with-param>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="currentPageType" select="'context'" tunnel="yes"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template name="contextContent">
		<xsl:param name="data" tunnel="yes"/>
		<xsl:param name="objectInfo" tunnel="yes"/>
		<xsl:param name="title"/>
		<xsl:variable name="dataKeys">
			<xsl:call-template name="colin:getData">
				<xsl:with-param name="queryName">context-keys</xsl:with-param>
				<xsl:with-param name="uri" select="$objectInfo/s:binding[@name='thing']/s:uri"/>
			</xsl:call-template>
		</xsl:variable>
		
		<div class="well well-sm" id="datanav" style="position: fixed; width: 100%;">
			<h1><xsl:copy-of select="$title"/></h1>
			<a class="btn btn-primary" role="button" href="#links">Links</a>
			<a class="btn btn-primary" role="button" href="#stats">Stats</a>
		</div>
		<h3>Links</h3>
		<xsl:apply-templates select="$data" mode="table">
			<xsl:with-param name="location" select="'center'"/>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="$dataKeys" mode="table">
			<xsl:with-param name="location" select="'center'"/>
		</xsl:apply-templates>
		
		<xsl:call-template name="contextMapgraph"/>
		
		<xsl:call-template name="linkedElements"/>
	</xsl:template>
</xsl:stylesheet>


