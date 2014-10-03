<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:colin="http://colin.maudry.com/"
	xmlns:doc="http://www.oxygenxml.com/ns/doc/xsl" xmlns:s="http://www.w3.org/2005/sparql-results#" 
	exclude-result-prefixes="colin xs doc s">
	<xsl:template name="dataset">
		<xsl:param name="data"/>
		<!-- This template goes through each data set and make an HTML file. -->
		<xsl:apply-templates select="$data/s:results/s:result" mode="dataset"/>	
		
	</xsl:template>
	
	<xsl:template mode="dataset" match="s:result">
		<xsl:param name="template" tunnel="yes"/>
		<xsl:result-document method="xhtml" href="{$outputFolder}/{colin:uri2path('dataset',s:binding[@name='thing']/s:uri)}">
			<xsl:call-template name="datasetPage">
				<xsl:with-param name="objectInfo" select="." tunnel="yes"/>
			</xsl:call-template>
		</xsl:result-document>		
	</xsl:template>
	
	<xsl:template name="datasetPage">
		<xsl:param name="objectInfo" tunnel="yes"/>
		<xsl:param name="template" tunnel="yes"/>
		<xsl:apply-templates select="$template/*">
			<xsl:with-param name="data" as="element()" tunnel="yes">
				<xsl:call-template name="colin:getData">
					<xsl:with-param name="queryName">dataset</xsl:with-param>
					<xsl:with-param name="uri" select="$objectInfo/s:binding[@name='thing']/s:uri"></xsl:with-param>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="currentPageType" select="'dataset'" tunnel="yes"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>
