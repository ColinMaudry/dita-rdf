<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="colin doc xs" version="2.0" xmlns:colin="http://colin.maudry.com/" xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:dita="http://purl.org/dita/ns#" xmlns:doc="http://www.oxygenxml.com/ns/doc/xsl" xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:nfo="http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#" xmlns:nie="http://www.semanticdesktop.org/ontologies/2007/01/19/nie#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:schema="http://schema.org/"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="params.xsl"/>
	<xsl:import href="rdf/map2rdf.xsl"/>
	<xsl:import href="rdf/topic2rdf.xsl"/>

	<xsl:output encoding="UTF-8" indent="yes" media-type="application/rdf+xml" method="xml" omit-xml-declaration="no"/>

	<doc:doc>
		<doc:desc>Temporary maps and topics (output of copy-files)</doc:desc>
	</doc:doc>
	<xsl:template match="/">
		<xsl:param name="currentUri" select="document-uri(/)"/>
		<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dita="http://purl.org/dita/ns#" xmlns:doc="http://www.oxygenxml.com/ns/doc/xsl" xmlns:foaf="http://xmlns.com/foaf/0.1/"
			xmlns:nfo="http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#" xmlns:nie="http://www.semanticdesktop.org/ontologies/2007/01/19/nie#"
			xmlns:ot="http://www.idiominc.com/opentopic" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
			xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#">
			<xsl:apply-templates>
				<xsl:with-param name="currentUri" select="$currentUri" tunnel="yes"/>
			</xsl:apply-templates>
		</rdf:RDF>
	</xsl:template>

	<xsl:template match="*[contains(@class,' map/map ')] | *[contains(@class,' topic/topic ')]">
		<xsl:param name="language" tunnel="yes"/>
		<xsl:param name="currentUri" tunnel="yes"/>
		
		<xsl:param name="docLanguage">
			<xsl:choose>
				<xsl:when test="@xml:lang!=''">
					<xsl:value-of select="@xml:lang"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$language"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:param>
		<xsl:param name="id" select="if (@id!='') then @id else generate-id()"/>
		<xsl:param name="documentUri">
		<xsl:value-of select="colin:getInformationObjectUri(local-name(),@xml:lang,$id)"/>
		</xsl:param>
		<xsl:if test="$debug='1'">
			<xsl:message>
				<xsl:value-of select="concat('Current URL: ',@xtrf,'/',@xtrc)"/>
				<xsl:value-of select="concat('Current URI: ',$currentUri)"/>
			</xsl:message>
		</xsl:if>
		<rdf:Description rdf:about="{$documentUri}">
			<xsl:if test="$docLanguage !=''">
				<dita:lang>
					<xsl:value-of select="$docLanguage"/>
				</dita:lang>
			</xsl:if>
			<xsl:call-template name="colin:getRdfTypes">
				<xsl:with-param name="class" select="@class"/>
			</xsl:call-template>
			<dita:id>
				<xsl:value-of select="$id"/>
			</dita:id>
			<dita:xtrf>
				<xsl:value-of select="@xtrf"/>
			</dita:xtrf>
			<xsl:if test="@title!=''">
				<dita:title>
					<xsl:if test="$docLanguage !=''">
						<xsl:attribute name="xml:lang" select="$docLanguage"/>
					</xsl:if>
					<xsl:value-of select="@title"/>
				</dita:title>
			</xsl:if>
			<xsl:apply-templates>
				<!-- The language and the documentUri parameters are tunneled to all further templates until the value is overriden by the next document. -->
				<xsl:with-param name="language" select="$docLanguage" tunnel="yes"/>
				<xsl:with-param name="documentUri" select="$documentUri" tunnel="yes"/>
			</xsl:apply-templates>
		</rdf:Description>
	</xsl:template>

	<xsl:function as="xs:anyURI" name="colin:getInformationObjectUri">
		<xsl:param name="resourceFamily"/>
		<xsl:param name="resourceLanguage"/>
		<xsl:param name="resourceId"/>
		<xsl:variable name="resourceBaseUri" select="$config/config/resourcesBaseUri/@uri"/>
		<xsl:variable name="languageCode">
			<xsl:if test="$resourceLanguage != ''">
				<xsl:value-of select="concat($resourceLanguage,'/')"/>
			</xsl:if>
		</xsl:variable>
		<xsl:value-of select="concat($resourceBaseUri,$resourceFamily,'/',$languageCode,$resourceId)"/>
	</xsl:function>

	<xsl:function as="xs:anyURI" name="colin:getInternalObjectUri">
		<xsl:param name="documentUri"/>
		<xsl:param name="xtrc"/>
		<xsl:value-of select="concat($documentUri,'/',$xtrc)"/>
	</xsl:function>
	
	<xsl:function as="xs:anyURI" name="colin:cleanDitaHref">
		<xsl:param name="ditaHref"/>
		<xsl:param name="currentUri"/>
		<xsl:variable name="cleanHref">
		<xsl:choose>
			<xsl:when test="contains($ditaHref,'#')">
				<xsl:value-of select="substring-before($ditaHref,'#')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$ditaHref"/>
			</xsl:otherwise>
		</xsl:choose>
		</xsl:variable>
		<xsl:variable name="baseUri">
			<xsl:choose>
				<xsl:when test="contains($currentUri,':/')">
					<xsl:value-of select="$currentUri"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('file:/',translate($currentUri,'\','/'))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="resolve-uri($cleanHref,$baseUri)"/>
	</xsl:function>

	<xsl:template name="colin:getRdfTypes">
		<xsl:param as="xs:string" name="class"/>
		<xsl:variable name="firstCharRemoved" select="substring($class,2)"/>
		<xsl:for-each select="tokenize(normalize-space($firstCharRemoved),' ')">
			<xsl:variable name="domainId" select="substring-before(.,'/')"/>
			<xsl:variable name="classBaseUri" select="$config/config/domains/domain[@domainId=$domainId]/@baseUri"/>
			<xsl:variable name="elementName" select="substring-after(.,'/')"/>
			<xsl:variable name="className" select="concat(upper-case(substring($elementName, 1,1)), substring($elementName, 2))"/>
			<rdf:type rdf:resource="{concat($classBaseUri,$className)}"/>
		</xsl:for-each>
	</xsl:template>

	<!-- The beauty of the tunnels: whenever @xml:lang is found, the $language param is set or reset and passed to the next templates. -->
	<xsl:template match="@xml:lang[.!='']">
		<xsl:param name="language"/>
		<xsl:apply-templates>
			<xsl:with-param name="language" select="." tunnel="yes"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template name="colin:getLanguageAtt">
		<xsl:param name="language" tunnel="yes"/>
		<xsl:if test="$language !=''">
			<xsl:attribute name="xml:lang" select="$language"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="   *[contains(@class, ' topic/topic ')]/*[contains(@class,' topic/title ')] |   *[contains(@class, ' map/map ')]/*[contains(@class,' topic/title ')] ">
		<dita:title>
			<xsl:call-template name="colin:getLanguageAtt"/>
			<xsl:apply-templates mode="get-text"/>
		</dita:title>
	</xsl:template>

	<xsl:template match="  *[contains(@class,' topic/shortdesc ')] |   *[contains(@class, ' topic/abstract ')]/*[contains(@class,' topic/shortdesc ')]">
		<dita:shortdesc>
			<xsl:call-template name="colin:getLanguageAtt"/>
			<xsl:apply-templates mode="get-text"/>
		</dita:shortdesc>
	</xsl:template>
		<xsl:template match="*[contains(@class, ' topic/author ')]">
		<dita:author>
			<xsl:apply-templates mode="get-text"/>
		</dita:author>
	</xsl:template>
	
	
	<xsl:template match="*[contains(@class, ' topic/permissions ')][@view!='']">
		<dita:permissions>
			<xsl:value-of select="@view"/>
		</dita:permissions>
	</xsl:template>
	

	<xsl:template match="*[contains(@class, ' topic/source ')]">
		<dita:source>
			<xsl:apply-templates mode="get-text"/>
		</dita:source>
	</xsl:template>


	<xsl:template match="@keyref | @conkeyref">
		<xsl:param name="documentUri" tunnel="yes"/>
		<!-- I deliberately omit the @href value, even if I have it available. The purpose is to represent the topic metadata regardless of the context map (scope). -->
		<xsl:variable name="keyname" select="if (contains(., '/')) then substring-before(.,'/') else ."/>
		<xsl:element name="{concat('dita:', local-name())}">
			<dita:Key rdf:about="{colin:getKeyUri($documentUri,.)}">
				<dita:keyname>
					<xsl:value-of select="$keyname"/>
				</dita:keyname>
			</dita:Key>
		</xsl:element>
	</xsl:template>
	<xsl:template match="@href[../@format and not(../@format='dita' or ../@format='ditamap')]">
		<dita:href rdf:resource="{.}"/>
		<dita:format>
			<xsl:value-of select="../@format"/>
		</dita:format>
	</xsl:template>
	
	<xsl:template match="@href[contains(.,'.dita')] | @href[../@format='dita' or ../@format='ditamap'] | @conref">
		<xsl:param name="keynode"/>
		<xsl:param name="targetDocument"/>
		<xsl:param name="currentUri" tunnel="yes"/>
		<xsl:param name="previousReference" tunnel="yes"/>
		<xsl:if test="$debug='1'">
			<xsl:message>
				<xsl:value-of select="concat('Current URI: ',$currentUri)"/>
			</xsl:message>
		</xsl:if>
		<!-- can be dita:href or dita:conref -->
		<xsl:element name="{concat('dita:', local-name())}">
			<!-- Only parse the next document if the current document is part of the documentation set.
			See https://github.com/ColinMaudry/dita-rdf/issues/42 -->
			<xsl:choose>
				<xsl:when test="contains($previousReference,' map/topicref ') or $previousReference=''">
					<xsl:variable name="resolvedCurrentUri" select="colin:cleanDitaHref(.,$currentUri)"/>
					<xsl:choose>
						<xsl:when test="$targetDocument!=''">
							<xsl:apply-templates select="$targetDocument/*">
								<xsl:with-param as="attribute(class)?" name="previousReference" select="../@class" tunnel="yes"/>
								<xsl:with-param name="currentUri" select="$resolvedCurrentUri" tunnel="yes"/>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="document($resolvedCurrentUri, /)/*">
								<xsl:with-param as="attribute(class)?" name="previousReference" select="../@class" tunnel="yes"/>
								<xsl:with-param name="currentUri" tunnel="yes" select="$resolvedCurrentUri"/>
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>											
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="rdf:resource" select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template match="@href[contains(.,'.xml') and not(../@format)]">
		<xsl:param name="previousReference" tunnel="yes"/>
		<!-- Only parse the next document if the current document is part of the documnentation set.
			See https://github.com/ColinMaudry/dita-rdf/issues/42 -->
		<xsl:choose>
			<xsl:when test="document(., /)/*[@class][@domains]">
				<dita:href>
					<xsl:choose>
						<xsl:when test="contains($previousReference,' map/topicref ') or $previousReference=''">
							<xsl:apply-templates select="document(., /)/*">
								<xsl:with-param as="attribute()" name="previousReference" select="../@class" tunnel="yes"/>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<dita:href rdf:resource="{.}"/>
						</xsl:otherwise>
					</xsl:choose>
				</dita:href>
			</xsl:when>
			<xsl:otherwise>
				<dita:href rdf:resource="{.}"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<doc:doc>
		<doc:desc>Catch all template for reference objects (that have a non-empty @href). Topicref, image, xref, etc.</doc:desc>
	</doc:doc>
	<!-- When an element (e.g. source or author) have both text() and @href, the priority goes to the @href and text() is ignored.
	If you use @href, don't forget to also add a @format attribute!-->
	<xsl:template match="   *[@href and @href!=''] |   *[@keyref and @keyref!=''] |   *[@conkeyref and @conkeyref!=''] |   *[@conref and @conref!='']" priority="2">
		<xsl:param name="documentUri" tunnel="yes"/>
		<xsl:param name="currentUri" tunnel="yes"/>
		<xsl:if test="$debug='1'">
			<xsl:message xml:space="default"><xsl:value-of select="concat(@xtrf,'/',@xtrc)"/>[<xsl:value-of select="@href | @conref | @conkeyref | @keyref"/>]</xsl:message>
		</xsl:if>
		<xsl:element name="{concat('dita:',local-name())}">
			<rdf:Description rdf:about="{colin:getInternalObjectUri($documentUri,@xtrc)}">
				<xsl:call-template name="colin:getRdfTypes">
					<xsl:with-param name="class" select="@class"/>
				</xsl:call-template>
				<xsl:apply-templates select=".[@href]/@keys"/>
				<xsl:apply-templates select="@keyref"/>
 				<xsl:apply-templates select="@conref">
 				</xsl:apply-templates>
				<xsl:apply-templates select="@conkeyref"/>
				<xsl:if test="not(@keys) and not(@keyref) and not(@conref) and not(@conkeyref)">
					<xsl:apply-templates select="@href[not('')]"/>
				</xsl:if>
				<!-- For now, only extract keys if they have references 
							Only extract @href if no @keys-->
			</rdf:Description>
		</xsl:element>
		<!-- Nesting (e.g. of topicref) is not extracted. Not considered meaningful for the purpose of metadata querying. -->
		<xsl:apply-templates/>
	</xsl:template>

	<!-- Audience -->
	<xsl:template match="*[contains(@class, ' topic/audience')]">
		<xsl:param name="documentUri" tunnel="yes"/>
		<dita:audience>
			<dita:Audience rdf:about="{colin:getInternalObjectUri($documentUri,@xtrc)}">
				<xsl:apply-templates select="@*"/>
			</dita:Audience>
		</dita:audience>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/audience ')]/@type[not(../@othertype) and not('')]">
		<dita:audienceType>
			<xsl:value-of select="."/>
		</dita:audienceType>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/audience ')]/@othertype[not('') and ../@type['other']]">
		<dita:audienceType>
			<xsl:value-of select="."/>
		</dita:audienceType>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/audience ')]/@job[not(../@otherjob) and not('')]">
		<dita:job>
			<xsl:value-of select="."/>
		</dita:job>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/audience ')]/@otherjob[not('') and ../@job['other']]">
		<dita:job>
			<xsl:value-of select="."/>
		</dita:job>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/audience ')]/@experiencelevel[not('')]">
		<dita:experiencelevel>
			<xsl:value-of select="."/>
		</dita:experiencelevel>
	</xsl:template>

	<!-- Prodinfo -->
	<!-- If prodname is empty, or if its resolved via the scope, prodinfo is skipped (for now) -->
	<xsl:template match="*[contains(@class, ' topic/prodinfo ')][*[contains(@class, ' topic/prodname ')]/text()]">
		<xsl:param name="productUri" select="concat($config/config/productsBaseUri/@uri,prodname)"/>
		<xsl:apply-templates mode="create-prodinfo" select="*[contains(@class, ' topic/vrmlist ')]">
			<xsl:with-param name="productUri" select="$productUri"/>
		</xsl:apply-templates>

	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/vrmlist ')]/*[contains(@class, ' topic/vrm ')]" mode="create-prodinfo">
		<xsl:param name="productUri"/>
		<xsl:variable name="version" select="if (@version!='') then @version else 0"/>
		<xsl:variable name="release" select="if (@release!='') then @release else 0"/>
		<xsl:variable name="modification" select="if (@modification!='') then @modification else 0"/>
		<xsl:variable name="versionNumber" select="concat($version,'.',$release,'.',$modification)"/>
		<xsl:variable name="productUriFull" select="concat($productUri,$config/config/productVersionSeparator,$versionNumber)"/>
		<dita:prodinfo>
			<rdf:Description rdf:about="{$productUriFull}">
			<xsl:call-template name="colin:getRdfTypes">
				<xsl:with-param name="class" select="../../@class"/>
			</xsl:call-template>
			<dita:vrmVersion>
				<xsl:value-of select="$version"/>
			</dita:vrmVersion>
			<dita:vrmRelease>
				<xsl:value-of select="$release"/>
			</dita:vrmRelease>
			<dita:vrmModification>
				<xsl:value-of select="$modification"/>
			</dita:vrmModification>
			<xsl:apply-templates select="../../*"/>
			</rdf:Description>
		</dita:prodinfo>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/prodname ')][text()]">
		<dita:prodname>
			<xsl:value-of select="text()"/>
		</dita:prodname>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/component ')][text()]">
		<dita:component>
			<xsl:value-of select="text()"/>
		</dita:component>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/brand ')][text()]">
		<dita:brand>
			<xsl:value-of select="text()"/>
		</dita:brand>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/feature ')][text()]">
		<dita:featnum>
			<xsl:value-of select="text()"/>
		</dita:featnum>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/platform ')][text()]">
		<dita:platform>
			<xsl:value-of select="text()"/>
		</dita:platform>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/prognum ')][text()]">
		<dita:prognum>
			<xsl:value-of select="text()"/>
		</dita:prognum>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/platform ')][text()]">
		<dita:series>
			<xsl:value-of select="text()"/>
		</dita:series>
	</xsl:template>

	<!-- Keywords -->
	<xsl:template match="*[contains(@class, ' topic/keywords ')]">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/keyword ')][not(@keyref)]">
		<dita:keyword>
			<xsl:call-template name="colin:getLanguageAtt"/>
			<xsl:apply-templates mode="get-text"/>
		</dita:keyword>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/category ')]">
		<dita:category>
			<xsl:call-template name="colin:getLanguageAtt"/>
			<xsl:apply-templates mode="get-text"/>
		</dita:category>
	</xsl:template>
</xsl:stylesheet>
