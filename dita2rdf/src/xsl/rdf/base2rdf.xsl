<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="2.0"  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
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
	xmlns:xsd="http://www.w3.org/2001/XMLSchema#" exclude-result-prefixes="xs doc colin">
	
	<xsl:template match="*[contains(@class,' map/map ')] | *[contains(@class,' topic/topic ')][not(parent::*[contains(@class,' topic/topic ')])]" name="colin:document">
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
			<xsl:value-of select="colin:getInformationObjectUri(local-name(),$docLanguage,$id)"/>
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
	<xsl:template match="   *[contains(@class, ' topic/topic ')]/*[contains(@class,' topic/title ')] |   *[contains(@class, ' map/map ')]/*[contains(@class,' topic/title ')] ">
		<xsl:apply-templates select="." mode="colin:processElementAsProperty">
			<xsl:with-param name="objectType" as="xs:string" select="'literal'"/>
			<xsl:with-param name="hasLanguage" as="xs:boolean" select="true()"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="  *[contains(@class,' topic/shortdesc ')] | *[contains(@class, ' topic/abstract ')]/*[contains(@class,' topic/shortdesc ')]">
		<xsl:apply-templates select="." mode="colin:processElementAsProperty">
			<xsl:with-param name="objectType" as="xs:string" select="'literal'"/>
			<xsl:with-param name="hasLanguage" as="xs:boolean" select="true()"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="
		*[contains(@class, ' topic/author ')] |
		*[contains(@class, ' topic/source ')]">
		<xsl:apply-templates select="." mode="colin:processElementAsProperty">
			<xsl:with-param name="objectType" as="xs:string" select="'literal'"/>
			<xsl:with-param name="hasLanguage" as="xs:boolean" select="false()"/>
		</xsl:apply-templates>
	</xsl:template>
	
	
	<xsl:template match="*[contains(@class, ' topic/permissions ')][@view!='']">
		<dita:permissions>
			<xsl:value-of select="@view"/>
		</dita:permissions>
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
	
	<xsl:template match="@href[contains(.,'.dita')] | @href[../@format='dita' or ../@format='ditamap']" name="colin:ditaHref">
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
			
			<xsl:variable name="resolvedCurrentUri" select="colin:cleanDitaHref(.,$currentUri)"/>
			<xsl:choose>
				<!-- Only parse the next document if the current document is part of the documentation set.
			See https://github.com/ColinMaudry/dita-rdf/issues/42 -->
				<xsl:when test="contains($previousReference,' map/topicref ') or $previousReference=''">
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
					<xsl:call-template name="colin:justGetTheUri">
						<xsl:with-param name="resolvedCurrentUri" select="$resolvedCurrentUri"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<!-- Since conref only targets one element, processing all the target document is overkill -->
	<xsl:template match="@conref">
		<xsl:param name="currentUri" tunnel="yes"/>
		<dita:conref>
			<xsl:call-template name="colin:justGetTheUri">
				<xsl:with-param name="resolvedCurrentUri" select="colin:cleanDitaHref(.,$currentUri)"/>
			</xsl:call-template>
		</dita:conref>
	</xsl:template>
	
	<xsl:template match="@href[contains(.,'.xml') and not(../@format)]">
		<xsl:choose>
			<xsl:when test="document(., /)/*[@class and @domains]">
				<xsl:call-template name="colin:ditaHref"/>
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
	<xsl:template match="
		*[contains(@class, ' topic/prodname ')][text()] |
		*[contains(@class, ' topic/component ')][text()] |
		*[contains(@class, ' topic/feature ')][text()] |
		*[contains(@class, ' topic/prognum ')][text()] |
		*[contains(@class, ' topic/platform ')][text()] |
		*[contains(@class, ' topic/series ')][text()] |
		*[contains(@class, ' topic/brand ')][text()]">
		<xsl:apply-templates select="." mode="colin:processElementAsProperty">
			<xsl:with-param name="objectType" as="text()">literal</xsl:with-param>
			<xsl:with-param name="hasLanguage" as="xs:boolean" select="false()"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- Critdates -->
	<!-- It's a bit weird that @golive and @expiry can be added to <created> and <modified>. I'm not sure of the semantics, but well... -->
	<xsl:template match="*[contains(@class, ' topic/critdates ')]">
		<xsl:apply-templates select="*/@*"/>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/created ')]/@date[normalize-space()]">
		<dcterms:created rdf:datatype="http://purl.org/dc/terms/W3CDTF"><xsl:value-of select="."/></dcterms:created>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/created ')]/@expiry[normalize-space()]">
		<dita:createdExpiry rdf:datatype="http://purl.org/dc/terms/W3CDTF"><xsl:value-of select="."/></dita:createdExpiry>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/created ')]/@golive[normalize-space()]">
		<dita:createdGolive rdf:datatype="http://purl.org/dc/terms/W3CDTF"><xsl:value-of select="."/></dita:createdGolive>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/revised ')]/@modified[normalize-space()]">
		<dcterms:modified rdf:datatype="http://purl.org/dc/terms/W3CDTF"><xsl:value-of select="."/></dcterms:modified>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/revised ')]/@expiry[normalize-space()]">
		<dita:modifiedExpiry rdf:datatype="http://purl.org/dc/terms/W3CDTF"><xsl:value-of select="."/></dita:modifiedExpiry>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/revised ')]/@golive[normalize-space()]">
		<dita:modifiedGolive rdf:datatype="http://purl.org/dc/terms/W3CDTF"><xsl:value-of select="."/></dita:modifiedGolive>
	</xsl:template>
	
	<!-- Keyword, category -->
	<xsl:template match="*[contains(@class, ' topic/keywords ')]">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="
		*[contains(@class, ' topic/keyword ')][not(@keyref)] |
		*[contains(@class, ' topic/category ')][not(@keyref)]">
		<xsl:apply-templates select="." mode="colin:processElementAsProperty">
			<xsl:with-param name="objectType" as="xs:string" select="'resource'"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="
		*[contains(@class, ' topic/keyword ')][not(@keyref)]/text() |
		*[contains(@class, ' topic/category ')][not(@keyref)]/text()">
		<rdfs:label><xsl:value-of select="normalize-space(.)"/></rdfs:label>
	</xsl:template>
	
</xsl:stylesheet>