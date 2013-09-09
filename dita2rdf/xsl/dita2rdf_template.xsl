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
<xsl:stylesheet version="2.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#"
	xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:nie="http://www.semanticdesktop.org/ontologies/2007/01/19/nie#"
	xmlns:nfo="http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
	xmlns:dita="http://purl.org/dita/ns#"
	xmlns:schema="http://schema.org/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:colin="http://zebrana.net/"
	xmlns:doc="http://www.oxygenxml.com/ns/doc/xsl">
	<xsl:import href="dita2rdfImpl.xsl"/>
<ditasf:extension id="dita.xsl.rdf" behavior="org.dita.dost.platform.ImportXSLAction" xmlns:ditasf="http://dita-ot.sourceforge.net"/>
	<xsl:output method="xml" encoding="utf-8" indent="no" />
	
</xsl:stylesheet>