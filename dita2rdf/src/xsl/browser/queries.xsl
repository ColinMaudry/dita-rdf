<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#"
	xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
	xmlns:dita="http://purl.org/dita/ns#"
	xmlns:schema="http://schema.org/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:colin="http://colin.maudry.com/"
	xmlns:doc="http://www.oxygenxml.com/ns/doc/xsl"
	exclude-result-prefixes="colin xs doc">
	<xsl:param name="sparql"/> 
	<xsl:param name="sparqlRoot">
		<xsl:value-of select="$sparql"/>
		<xsl:text>?query=</xsl:text>
	</xsl:param>

<xsl:param name="queries" as="node()">
		<queries>
			<query name="contexts" replace="no">
				PREFIX  dcat: &lt;http://www.w3.org/ns/dcat#>
				PREFIX  dita: &lt;http://purl.org/dita/ns#>
				PREFIX  dcterms: &lt;http://purl.org/dc/terms/>
				
				SELECT ?thing ?title ?extraction_time ?description
				WHERE
				{ GRAPH ?graph
				{
				?thing &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type> dcat:Dataset .
				?thing dcterms:issued ?extraction_time .
				?thing dcterms:title ?title .
				?thing dcterms:description ?description
				}
				}
				ORDER BY ?extraction_time
			</query>
			<query name="context" replace="yes">
				PREFIX  dcat: &lt;http://www.w3.org/ns/dcat#>
		PREFIX  dita: &lt;http://purl.org/dita/ns#>
		PREFIX  dcterms: &lt;http://purl.org/dc/terms/>
		
		SELECT ?thing ?title ?id ?location
		WHERE
		{ GRAPH ?graph
		{
		?uri a dcat:Dataset .
		?thing &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type> dita:Map .
		optional {?thing dita:title ?title .}
		?thing dita:id ?id .
		?thing dita:xtrf ?location
		
		}
		}ORDER BY ?title
			</query>
			<query name="maps" replace="no">
				PREFIX  dcat: &lt;http://www.w3.org/ns/dcat#>
				PREFIX  dita: &lt;http://purl.org/dita/ns#>
				PREFIX  dcterms: &lt;http://purl.org/dc/terms/>
				
				SELECT ?thing ?title ?id ?location
				WHERE
				{ GRAPH ?graph
				{
				?thing &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type> dita:Map .
				optional {?thing dita:title ?title .}
				?thing dita:id ?id .
				?thing dita:xtrf ?location
				}
				}ORDER BY ?thing
			</query>
			<query name="map" replace="yes">
				PREFIX  dcat: &lt;http://www.w3.org/ns/dcat#>
				PREFIX  dita: &lt;http://purl.org/dita/ns#>
				PREFIX  dcterms: &lt;http://purl.org/dc/terms/>
				
				SELECT ?thing ?title ?id (GROUP_CONCAT(DISTINCT ?typeLabel ; separator=", ") AS ?types) ?location
				WHERE
				{ GRAPH ?graph
				{
				?uri a dita:Map ;
						?topicref ?Topicref .
				?Topicref a dita:Topicref ;
						dita:href ?thing .
				?thing &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type> ?typeUri .
				optional {?thing dita:title ?title .}
				?thing dita:id ?id .
				?thing dita:xtrf ?location .				
				}
				graph &lt;http://purl.org/dita/ns> {
					?typeUri rdfs:label ?typeLabel .
					filter(?typeLabel!='Doctype')
				}
				}GROUP BY ?thing ?title ?id ?location
			</query>
			<query name="topics" replace="no">
				PREFIX  dcat: &lt;http://www.w3.org/ns/dcat#>
				PREFIX  dita: &lt;http://purl.org/dita/ns#>
				PREFIX  dcterms: &lt;http://purl.org/dc/terms/>
				
				SELECT ?thing ?title ?id ?location
				WHERE
				{ GRAPH ?graph
				{
				?thing &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type> dita:Topic .
				optional {?thing dita:title ?title .}
				?thing dita:id ?id .
				?thing dita:xtrf ?location
				}
				}ORDER BY ?thing
			</query>
			<query name="topic" replace="yes">
				PREFIX  rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#>
				PREFIX  dcat: &lt;http://www.w3.org/ns/dcat#>
				PREFIX  dita: &lt;http://purl.org/dita/ns#>
				PREFIX  dcterms: &lt;http://purl.org/dc/terms/>
				
				SELECT  ?thing (GROUP_CONCAT(DISTINCT ?typeLabel; SEPARATOR=', ') AS ?types) ?title ?id
				WHERE
				{ GRAPH ?graph
				{   { ?uri dita:xref ?refobject .
				?refobject a dita:Xref
				}
				UNION
				{ ?uri dita:link ?refobject .
				?refobject a dita:Link
				}
				?refobject a ?typeUri
				{ ?refobject dita:format "html" .
				?refobject dita:href ?title .}
				UNION
				{ ?refobject dita:href ?thing .
				?thing a dita:Doctype .
				?thing dita:id ?id .}
				
				OPTIONAL
				{ ?thing dita:title ?title }
				}
				GRAPH &lt;http://purl.org/dita/ns>
				{ ?typeUri rdfs:label ?typeLabel }
				}
				GROUP BY ?thing ?title ?id
			</query>
			<query name="inbound" replace="yes">
				PREFIX  rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#>
				PREFIX  dcat: &lt;http://www.w3.org/ns/dcat#>
				PREFIX  dita: &lt;http://purl.org/dita/ns#>
				PREFIX  dcterms: &lt;http://purl.org/dc/terms/>
				
				SELECT DISTINCT  ?thing ?title (GROUP_CONCAT(DISTINCT ?typeLabel; SEPARATOR=', ') AS ?types) ?relation
				WHERE
				{ GRAPH ?graph
				{ ?refObject dita:href ?uri .
				?thing ?rel ?refObject .
				?thing &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type> dita:Doctype .
				?thing &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type> ?typeUri
				OPTIONAL
				{ ?thing dita:title ?title }
				}
				GRAPH &lt;http://purl.org/dita/ns>
				{ ?rel rdfs:subPropertyOf dita:referenceObject .
				?rel rdfs:label ?relation .
				?typeUri rdfs:label ?typeLabel
				}
				}
					
				GROUP BY ?thing ?title ?relation
			</query>
			<query name="context-keys" replace="yes">
				PREFIX  rdfs:&lt;http://www.w3.org/2000/01/rdf-schema#>
				PREFIX  dcat: &lt;http://www.w3.org/ns/dcat#>
				PREFIX  dita: &lt;http://purl.org/dita/ns#>
				PREFIX  dcterms: &lt;http://purl.org/dc/terms/>
				
				SELECT DISTINCT  ?key_name ?key_value ?map_title ?map_id
				WHERE
				{ GRAPH ?graph
				{
				
				?uri a dcat:Dataset ;
				dcterms:title ?context_title .
				
				?thing a dita:Key ;
				dita:keyname ?key_name .
				{?thing dita:href ?key_value .} UNION
				{?thing dita:keyword ?keyword .
				?keyword rdfs:label ?key_value .}
				
				?keydefObject dita:key ?thing ;
				a dita:Topicref .
				?map a dita:Map ;
				?keydef ?keydefObject ;
				dita:title ?map_title ;
				dita:id ?map_id .
				
		
				}
				GRAPH &lt;http://purl.org/dita/ns>
				{ ?keydef rdfs:subPropertyOf dita:topicref .
				}
				}
			</query>
			<query name="file-relations-context" replace="yes">
				PREFIX dita: &lt;http://purl.org/dita/ns#>
				PREFIX dcat: &lt;http://www.w3.org/ns/dcat#>	
				#I add hash signs so that blocks are not hyperlinks in visualizations
					SELECT (concat('#',str(?source)) as ?sourceUri) ?sourceLabel (concat('#',str(?target)) as ?targetUri) ?targetLabel ?relationLabel
					WHERE { 
					GRAPH &lt;http://purl.org/dita/ns> {
						?relation rdfs:subPropertyOf dita:referenceObject ;
						rdfs:label ?relationLabel .
						?RelationClass rdfs:subClassOf dita:ReferenceObject .
						}
						GRAPH ?graph {
							?uri a dcat:Dataset .
							?source ?relation ?relationObject  .
							?relationObject dita:href ?target ;
							a ?RelationClass .
							
							?source dita:title ?sourceLabel .  
							?target dita:title ?targetLabel .   
							}
							
							}
							
			</query>
			<query name="basic-file-metadata" replace="yes">
				PREFIX dita: &lt;http://purl.org/dita/ns#>
				PREFIX dcat: &lt;http://www.w3.org/ns/dcat#>
					
				#This query can be used to create a visual graph of the document, and their relations
				
				SELECT ?property ?value where {
				graph &lt;http://purl.org/dita/ns> {
					?prop rdfs:label ?property .
					filter not exists {?prop rdfs:subPropertyOf dita:referenceObject .}
					}
					graph ?graph {
					?uri ?prop ?value 
					}
					}
			</query>
			<query name="linked-elements" replace="yes">
				PREFIX dita: &lt;http://purl.org/dita/ns#>
				PREFIX dcat: &lt;http://www.w3.org/ns/dcat#>
							
				select ?targetElementId ?element_type ?text ?topic_or_map_title (count(?sourceElement) as ?number_of_references) {
				graph ?graph	{
					?uri a dcat:Dataset .
					{?sourceElement dita:conref ?targetElement .} union 
					{?sourceElement dita:xref ?targetElement }
					?targetElement dita:text ?text ;
					rdfs:label ?element_type ;
					dita:id ?targetElementId .
					?topicOrMap dita:element ?targetElement ;
					dita:title ?topic_or_map_title .
					} 
					
					}
					GROUP BY ?targetElementId ?topic_or_map_title ?element_type ?text
					ORDER BY DESC(?number_of_references)
					LIMIT 30
			</query>
		</queries>
	</xsl:param>
	
	<xsl:template name="colin:getData">
		<xsl:param name="uri"/>
		<xsl:param name="queryName"/>
		<xsl:variable name="queryText" select="encode-for-uri(colin:getQuery($queryName,$uri))"/>		
		<xsl:variable name="queryUrl" select="concat($sparqlRoot,$queryText,'&amp;output=xml')"></xsl:variable>
		<xsl:message select="concat('Query ',$queryName,': ',replace(colin:getQuery($queryName,$uri),'&#xA;',' '))"></xsl:message>
		<xsl:copy-of select="document($queryUrl)/*"/>
	</xsl:template>
	
	<xsl:function name="colin:getQuery">
		<xsl:param name="queryName"/>
		<xsl:param name="uri"/>
		<xsl:variable name="query" select="$queries//query[@name=$queryName]"/>
		<xsl:choose>
			<xsl:when test="$query/@replace='yes'">
				<xsl:value-of select="replace($query/text(),'\?uri',concat('&lt;',$uri,'>'))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$query/text()"/>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:function>

	<xsl:template match="node() | @* " xml:space="default">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
