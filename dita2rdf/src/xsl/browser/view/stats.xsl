<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:colin="http://colin.maudry.com/"
	xmlns:doc="http://www.oxygenxml.com/ns/doc/xsl"
	xmlns:s="http://www.w3.org/2005/sparql-results#"
	exclude-result-prefixes="colin doc s">

	
<!-- Reusable stats blocks -->
<xsl:template name="contextMapgraph">
	<xsl:param name="objectInfo" tunnel="yes"/>
	<xsl:variable name="contextUri"  select="$objectInfo/s:binding[@name='thing']/s:uri/text()"/>
	<h3 id="map-graph">Map graph visualization</h3>			
	<div id="contextMapgraph"  class="stat"
		data-sgvizler-chart-options="directed=true"
		data-sgvizler-endpoint="{$sparql}" 
		data-sgvizler-query="{colin:getQuery('file-relations-context',$contextUri)}"
		data-sgvizler-chart="sgvizler.visualization.DraculaGraph"
		style="width:100%; height:400px; border:1px solid grey; display: inline-block;"></div>
	
	
</xsl:template>
	
<xsl:template name="basicMetadataTable">
	<xsl:param name="uri"/>
	<h3 id="metadata">Basic metadata</h3>
	<div id="basic-metadata" class="stat"
		data-sgvizler-endpoint="{$sparql}"
		data-sgvizler-query="
		{colin:getQuery('basic-file-metadata',$uri)}" 
		data-sgvizler-chart="google.visualization.Table"
		style="width:100%; min-height:250px; border:1px solid grey; display: inline-block;"></div>
</xsl:template>

<xsl:template name="linkedElements">
	<xsl:param name="objectInfo" tunnel="yes"/>
	<xsl:variable name="contextUri"  select="$objectInfo/s:binding[@name='thing']/s:uri/text()"/>
	<h3 id="linked-elements">Linked elements</h3>
	<div id="linked-elements" class="stat"
		data-sgvizler-endpoint="{$sparql}"
		data-sgvizler-query="
		{colin:getQuery('linked-elements',$contextUri)}" 
		data-sgvizler-chart="google.visualization.Table"
		style="width:100%; height:250px; border:1px solid grey; display: inline-block;"></div>
</xsl:template>

</xsl:stylesheet>