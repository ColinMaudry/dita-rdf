<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:colin="http://colin.maudry.com/"
	xmlns:doc="http://www.oxygenxml.com/ns/doc/xsl"
	xmlns:s="http://www.w3.org/2005/sparql-results#"
	exclude-result-prefixes="colin doc s">
	<xsl:template mode="table" match="s:sparql">
		<xsl:param name="head" select="s:head" as="node()"/>
		<xsl:param name="location"/>
		<table class="table browsable sortable">
			<caption><span class="badge pull-right"><xsl:value-of select="count(s:results/s:result[count(s:binding)=count($head/s:variable)])"/></span></caption>
			<thead>
				<tr>
					<xsl:for-each select="$head/s:variable/@name">
						<xsl:if test=".!='thing'">
							<xsl:variable name="name" as="text()">
								<xsl:value-of select="."/>
								</xsl:variable>
							<th><xsl:value-of select="colin:prettifyVariableName($name)"/></th>
							</xsl:if>
						</xsl:for-each>				
				</tr>
			</thead>
			<xsl:apply-templates select="s:results" mode="table">
				<xsl:with-param name="head" select="$head" tunnel="yes"/>
			</xsl:apply-templates>
		</table>		
	</xsl:template>
	<xsl:template match="s:results" mode="table">
		<tbody>
			<xsl:apply-templates select="s:result" mode="table"/>
		</tbody>
	</xsl:template>
	<xsl:template mode="table" match="s:result">
		<xsl:param name="head" tunnel="yes"/>
		<xsl:param name="currentPageType" tunnel="yes"/>
		<xsl:variable name="result" select="."/>
		<xsl:variable name="path" select="colin:uri2path($currentPageType,s:binding[@name='thing']/s:uri)"/>
			<tr>
			<xsl:if test="s:binding[@name='types']">
				<xsl:attribute name="class" select="lower-case(replace(s:binding[@name='types']/s:literal/text(),',',''))"/>
			</xsl:if>	
			<xsl:for-each select="$head/s:variable">
				<!-- I must turn the @name attribute into a text() node to make a comparison -->
				<xsl:variable name="columnName">
					<xsl:value-of select="./@name"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$columnName='thing'"/>
					<!-- If the binding that matches the header is empty for this result, output an empty cell. -->
					<xsl:when test="not($result/s:binding[@name=$columnName])">
						<td> </td>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$result/s:binding[@name=$columnName]" mode="table">
							<xsl:with-param name="path" select="$path"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
				</xsl:for-each>			
			</tr>
	</xsl:template>
	<xsl:template match="s:result[s:binding[contains(@name,'title')]/s:literal/text()='' and s:binding[contains(@name,'id')]/s:literal/text()='']"/>
	<xsl:template match="s:binding" mode="table" priority="-1">
		<xsl:param name="path"/>
		<td class="{@name}"><a href="{$path}"><xsl:value-of select="."/></a></td>		
	</xsl:template>
	<xsl:template mode="table" match="s:binding[s:literal/@datatype='http://www.w3.org/2001/XMLSchema#dateTime']">
		<xsl:param name="path"/>
		<td class="{@name}"><a href="{$path}"><xsl:value-of select="format-dateTime(s:literal,'[M01]/[D01]/[Y0001]  [H01]:[m01]')"/></a></td>
	</xsl:template>	
	
	<xsl:template name="inboundTable">
		<xsl:param name="inboundData"/>
		<div class="col-sm-3 panel panel-default placeholder"></div>
		<div class="col-sm-3 panel panel-default inbound" role="navigation">
			<div class="panel-heading">Inbound links</div>
			<xsl:apply-templates select="$inboundData" mode="table"/>
		</div>
	</xsl:template>	
	

</xsl:stylesheet>