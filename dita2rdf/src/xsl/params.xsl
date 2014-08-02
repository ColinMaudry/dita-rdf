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
<xsl:stylesheet version="2.0"	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:colin="http://zebrana.net/"
	xmlns:doc="http://www.oxygenxml.com/ns/doc/xsl">

	<xsl:param name="profilingAttributes">audience,platform,product,otherprops,props,rev</xsl:param>
	<xsl:param name="resourcesBaseUri">http://data.example.com/id/</xsl:param>
	<xsl:param name="doctypesNamespaces" select="document('conf/doctypesNamespaces.xml')"></xsl:param>
	
	<!-- Located here to have lower precedence over the other imported templates -->
	<xsl:template match=" * | @* "/>
	<xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template>

</xsl:stylesheet>