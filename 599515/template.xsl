<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                version="2.0">
    
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
    
    <!-- Root template -->
    <xsl:template match="/">
        <html>
            <head>
                <title>La Rassegna Settimanale</title>
                <link rel="stylesheet" href="styles.css"/>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/2.11.8/umd/popper.min.js"></script>
                <script src="script.js" defer="defer"></script>
            </head>
            <body>

    <header class="main-header">
        <div class="header-content">
            <h1 class="main-title">
                <xsl:value-of select="//tei:titleStmt/tei:title[@type='main']"/>
            </h1>
            <h2 class="sub-title">
                <xsl:value-of select="//tei:titleStmt/tei:title[@type='sub']"/>
            </h2>
        </div>
    </header>

    <div class="sidebar" id="metadataSidebar">
        <div class="sidebar-header">
            <h3>Metadata &amp; Glossary</h3>
            <button class="close-sidebar" onclick="toggleMetadataSidebar()">×</button>
        </div>

        <div class="metadata-content">
            <h4>TEI Header Information</h4>
            <div class="tei-header-details">
                <xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:fileDesc" mode="metadata"/>
                <xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:encodingDesc" mode="metadata"/>
                <xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:profileDesc" mode="metadata"/>
                <xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:revisionDesc" mode="metadata"/>
            </div>

            <div class="glossary-content">
                <h4>Glossary</h4>
                <xsl:apply-templates select="/tei:TEI/tei:back/tei:div[@type='appendix']" mode="metadata"/>
            </div>
        </div>
    </div>

    <main>
        <div class="entity-controls">
            <div class="control-label">Highlight Entities:</div>
            <button class="entity-button" data-entity="person">People</button>
            <button class="entity-button" data-entity="place">Places</button>
            <button class="entity-button" data-entity="org">Organizations</button>
            <button class="entity-button" data-entity="term">Terms</button>
            <button class="entity-button" data-entity="date">Dates</button>
            <button class="entity-button" data-entity="quote">Quotes</button>
            <button class="entity-button" data-entity="foreign">Foreign Language</button>
            <button class="metadata-button" onclick="toggleMetadataSidebar()">Metadata &amp; Glossary</button>
        </div>

        <xsl:apply-templates select="//tei:div[@type='page']"/>
    </main>

    <button class="back-to-top">↑</button>

</body>
        </html>
    </xsl:template>

    <!-- Page template -->
    <xsl:template match="tei:div[@type='page']">
        <xsl:variable name="page-number" select="@n"/>
        <xsl:variable name="surface" select="//tei:surface[tei:graphic[contains(@url, concat('p', $page-number))]]"/>
        
        <div class="page-container" id="page-{$page-number}">
            <!-- Image column -->
            <div class="image-column">
                <div class="image-container">
                    <img src="{$surface/tei:graphic/@url}" 
                         width="{$surface/tei:graphic/@width}" 
                         height="{$surface/tei:graphic/@height}"
                         alt="Page {$page-number}"/>
                    <svg class="zone-overlay" 
                         viewBox="0 0 {$surface/tei:graphic/@width} {$surface/tei:graphic/@height}">
                        <xsl:apply-templates select="$surface/tei:zone"/>
                    </svg>
                </div>
            </div>
            
            <!-- Text columns -->
            <div class="text-columns">
                <xsl:apply-templates select="tei:div[@type='column']"/>
            </div>
        </div>
    </xsl:template>

    <!-- Zone template -->
    <xsl:template match="tei:zone">
        <polygon class="highlight-zone" 
                id="zone-{@xml:id}"
                points="{@points}"/>
    </xsl:template>

    <!-- Column template -->
    <xsl:template match="tei:div[@type='column']">
        <div class="text-column column-{@n}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- Header elements -->
<xsl:template match="tei:head">
    <div class="header">
        <xsl:apply-templates/>
    </div>
</xsl:template>

<xsl:template match="tei:title">
    <div class="text-line title {string(@type)}" id="{@xml:id}" data-zone="{substring-after(@facs, '#')}">
        <xsl:apply-templates/>
    </div>
</xsl:template>

    <!-- Author and byline -->
    <xsl:template match="tei:author">
        <div class="entity person-name" data-entity="person" data-ref="{@ref}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:byline">
        <div class="byline">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- Person names -->
    <xsl:template match="tei:persName">
        <span class="entity person-name" data-entity="person" data-ref="{@ref}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- Place names -->
    <xsl:template match="tei:placeName">
        <span class="entity place-name" data-entity="place" data-type="{@type}" data-ref="{@ref}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- Organization names -->
    <xsl:template match="tei:orgName">
        <span class="entity org-name" data-entity="org" data-ref="{@ref}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- Dates -->
    <xsl:template match="tei:date">
        <span class="entity date" data-entity="date" data-when="{@when}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- Terms -->
    <xsl:template match="tei:term">
        <span class="entity term" data-entity="term" data-type="{@type}" data-subtype="{@subtype}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- Quotes -->
    <xsl:template match="tei:quote">
    <span class="entity quote" data-entity="quote">
        <xsl:apply-templates/>
    </span>
</xsl:template>

    <!-- Notes -->
    <xsl:template match="tei:note">
        <div class="note {string(@place)}" id="{@xml:id}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- Lists -->
    <xsl:template match="tei:list">
        <xsl:choose>
            <xsl:when test="@type='ordered'">
                <ol class="list ordered">
                    <xsl:apply-templates/>
                </ol>
            </xsl:when>
            <xsl:otherwise>
                <ul class="list">
                    <xsl:apply-templates/>
                </ul>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:item">
        <li class="list-item">
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <!-- Paragraphs with line breaks -->
    <xsl:template match="tei:p">
        <p class="paragraph">
            <xsl:for-each select="./tei:lb">
                <div class="text-line" id="line-{@xml:id}" data-zone="{substring-after(@facs, '#')}">
                    <xsl:if test="@n">
                        <span class="line-number"><xsl:value-of select="@n"/>.</span>
                    </xsl:if>
                    <xsl:apply-templates select="following-sibling::node()[generate-id(following-sibling::tei:lb[1]) = generate-id(current()/following-sibling::tei:lb[1])]"/>
                </div>
            </xsl:for-each>
        </p>
    </xsl:template>

    <!-- Line break -->
    <xsl:template match="tei:lb">
        <!-- Handled in paragraph template -->
    </xsl:template>

    <!-- Foreign text -->
    <xsl:template match="tei:foreign">
        <span class="foreign-text" lang="{@xml:lang}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <!-- This template matches any element with xml:lang attribute -->
<xsl:template match="*[@xml:lang and @xml:lang!='it']">
    <span class="entity foreign" data-entity="foreign" data-lang="{@xml:lang}">
        <xsl:apply-templates select="@*[not(local-name()='lang')]"/>
        <xsl:apply-templates/>
    </span>
</xsl:template>

<!-- Add priority to existing templates to prevent conflicts -->
<xsl:template match="tei:term[@xml:lang and @xml:lang!='it']" priority="2">
    <span class="entity foreign" data-entity="foreign" data-lang="{@xml:lang}">
        <span class="entity term" data-entity="term" data-type="{@type}" data-subtype="{@subtype}">
            <xsl:apply-templates/>
        </span>
    </span>
</xsl:template>

<xsl:template match="tei:title[@xml:lang and @xml:lang!='it']" priority="2">
    <span class="entity foreign" data-entity="foreign" data-lang="{@xml:lang}">
        <xsl:apply-templates/>
    </span>
</xsl:template>

    <!-- Emphasis -->
    <xsl:template match="tei:hi[@rend='italic']">
        <em>
            <xsl:apply-templates/>
        </em>
    </xsl:template>

    <!-- Default template for text nodes -->
    <xsl:template match="text()">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="tei:fileDesc" mode="metadata">
    <div class="metadata-section file-desc">
        <h3>File Description</h3>

        <div class="metadata-filedesc-subsection titleStmt">
            <h4>Title Statement</h4>
            <xsl:apply-templates select="tei:titleStmt" mode="metadata"/>
        </div>

        <div class="metadata-filedesc-subsection editionStmt">
            <h4>Edition Statement</h4>
            <xsl:apply-templates select="tei:editionStmt" mode="metadata"/>
        </div>

        <div class="metadata-filedesc-subsection publicationStmt">
            <h4>Publication Statement</h4>
            <xsl:apply-templates select="tei:publicationStmt" mode="metadata"/>
        </div>

        <div class="metadata-filedesc-subsection notesStmt">
            <h4>Notes Statement</h4>
            <xsl:apply-templates select="tei:notesStmt" mode="metadata"/>
        </div>

        <div class="metadata-filedesc-subsection sourceDesc">
            <h4>Source Description</h4>
            <xsl:apply-templates select="tei:sourceDesc" mode="metadata"/>
        </div>

    </div>
</xsl:template>

    <xsl:template match="tei:titleStmt" mode="metadata">
        <div class="metadata-subsection title-stmt">
            <h4>Title Statement</h4>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:title" mode="metadata">
        <p class="metadata-title" data-type="{@type}">
            <xsl:value-of select="."/>
        </p>
    </xsl:template>

    <xsl:template match="tei:editionStmt" mode="metadata">
        <div class="metadata-subsection edition-stmt">
            <h4>Edition Statement</h4>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:publicationStmt" mode="metadata">
        <div class="metadata-subsection publication-stmt">
            <h4>Publication Statement</h4>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:notesStmt" mode="metadata">
        <div class="metadata-subsection notes-stmt">
            <h4>Notes Statement</h4>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:note" mode="metadata">
        <div class="metadata-note" data-type="{@type}">
            <xsl:value-of select="."/>
        </div>
    </xsl:template>

    <xsl:template match="tei:sourceDesc" mode="metadata">
        <div class="metadata-section source-desc">
            <h3>Source Description</h3>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:encodingDesc" mode="metadata">
    <div class="metadata-section encoding-desc">
        <h3>Encoding Description</h3>

        <div class="metadata-subsection classDecl">
            <h4>Classification Declaration</h4>
            <xsl:apply-templates select="tei:classDecl" mode="metadata"/>
        </div>

    </div>
</xsl:template>

    <xsl:template match="tei:classDecl" mode="metadata">
    <div class="metadata-classdecl-content">
        <xsl:apply-templates select="tei:taxonomy" mode="metadata"/>
    </div>
</xsl:template>

    <xsl:template match="tei:taxonomy" mode="metadata">
    <div class="metadata-taxonomy">
        <h5>Taxonomy</h5>
        <xsl:apply-templates select="tei:category" mode="metadata"/>
    </div>
</xsl:template>

    <xsl:template match="tei:category" mode="metadata">
    <div class="metadata-category">
        <h6>
            <xsl:value-of select="tei:title"/>
        </h6>
        <xsl:apply-templates select="tei:catDesc" mode="metadata"/>
    </div>
</xsl:template>


    <xsl:template match="tei:catDesc" mode="metadata">
        <p class="metadata-catDesc">
            <xsl:value-of select="."/>
        </p>
    </xsl:template>


    <xsl:template match="tei:profileDesc" mode="metadata">
        <div class="metadata-section profile-desc">
            <h3>Profile Description</h3>

            <div class="metadata-subsection langUsage">
                <h4>Language Usage</h4>
                <xsl:apply-templates select="tei:langUsage" mode="metadata"/>
            </div>

            <div class="metadata-subsection textClass">
                <h4>Text Classification</h4>
                <xsl:apply-templates select="tei:textClass" mode="metadata"/>
            </div>

            <div class="metadata-list-container">  <h4>Persons</h4>  <xsl:apply-templates select="tei:listPerson" mode="metadata"/>
            </div>

            <div class="metadata-list-container">  <h4>Organizations</h4>  <xsl:apply-templates select="tei:listOrg" mode="metadata"/>
            </div>

            <div class="metadata-list-container">  <h4>Places</h4>  <xsl:apply-templates select="tei:listPlace" mode="metadata"/>
            </div>

        </div>
    </xsl:template>

    <xsl:template match="tei:langUsage" mode="metadata">
        <div class="metadata-subsection lang-usage">
            <h4>Language Usage</h4>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:language" mode="metadata">
        <p class="metadata-language" data-ident="{@ident}">
            Language: <xsl:value-of select="."/> (<xsl:value-of select="@ident"/>)
        </p>
    </xsl:template>

    <xsl:template match="tei:textClass" mode="metadata">
        <div class="metadata-subsection text-class">
            <h4>Text Class</h4>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:channel" mode="metadata">
        <p class="metadata-channel" data-mode="{@mode}">
            Channel: <xsl:value-of select="."/> (Mode: <xsl:value-of select="@mode"/>)
        </p>
    </xsl:template>

    <xsl:template match="tei:listPerson" mode="metadata">
    <div class="metadata-subsection list-person">
        <h4>List of Persons</h4>
        <xsl:apply-templates select="tei:person" mode="metadata"/>
    </div>
</xsl:template>

    <xsl:template match="tei:person" mode="metadata">
        <div class="metadata-person" data-xml-id="{@xml:id}">
            <h5>Person: <xsl:value-of select="./tei:persName/*[1]"/> <xsl:value-of select="./tei:persName/tei:surname"/></h5>
             <xsl:apply-templates select="tei:persName"/>
             <xsl:apply-templates select="tei:occupation"/>
             <xsl:apply-templates select="tei:note"/>
             <xsl:apply-templates select="tei:birth"/>
             <xsl:apply-templates select="tei:death"/>
        </div>
    </xsl:template>
    <xsl:template match="tei:persName" mode="metadata">
        <p class="metadata-persName">
            Name: <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="tei:occupation" mode="metadata">
        <p class="metadata-occupation">
            Occupation: <xsl:value-of select="."/>
        </p>
    </xsl:template>

     <xsl:template match="tei:note" mode="metadata">
        <p class="metadata-note-person">
            Note: <xsl:value-of select="."/>
        </p>
    </xsl:template>

    <xsl:template match="tei:birth" mode="metadata">
        <p class="metadata-birth">
            Birth: <xsl:value-of select="@when"/>
        </p>
    </xsl:template>

    <xsl:template match="tei:death" mode="metadata">
        <p class="metadata-death">
            Death: <xsl:value-of select="@when"/>
        </p>
    </xsl:template>


    <xsl:template match="tei:listOrg" mode="metadata">
    <div class="metadata-subsection list-org">
        <h4>List of Organizations</h4>
        <xsl:apply-templates select="tei:org" mode="metadata"/>
    </div>
</xsl:template>

    <xsl:template match="tei:org" mode="metadata">
        <div class="metadata-org" data-xml-id="{@xml:id}">
            <h5>Organization: <xsl:value-of select="tei:orgName"/></h5>
            <xsl:apply-templates select="tei:orgName"/>
            <xsl:apply-templates select="tei:desc"/>
        </div>
    </xsl:template>

    <xsl:template match="tei:orgName" mode="metadata">
        <p class="metadata-orgName">
            Name: <xsl:value-of select="."/>
        </p>
    </xsl:template>

    <xsl:template match="tei:desc" mode="metadata">
        <p class="metadata-desc">
            Description: <xsl:value-of select="."/>
        </p>
    </xsl:template>


    <xsl:template match="tei:listPlace" mode="metadata">
    <div class="metadata-subsection list-place">
        <h4>List of Places</h4>
        <xsl:apply-templates select="tei:place" mode="metadata"/>
    </div>
</xsl:template>

    <xsl:template match="tei:place" mode="metadata">
        <div class="metadata-place" data-xml-id="{@xml:id}">
            <h5>Place: <xsl:value-of select="tei:placeName"/></h5>
            <xsl:apply-templates select="tei:placeName"/>
            <xsl:apply-templates select="tei:desc"/>
            <xsl:apply-templates select="tei:region"/>
            <xsl:apply-templates select="tei:country"/>
            <xsl:apply-templates select="tei:bloc"/>
        </div>
    </xsl:template>

    <xsl:template match="tei:placeName" mode="metadata">
        <p class="metadata-placeName">
            Name: <xsl:value-of select="."/>
        </p>
    </xsl:template>

    <xsl:template match="tei:region" mode="metadata">
        <p class="metadata-region">
            Region: <xsl:value-of select="."/> (<xsl:value-of select="@key"/>)
        </p>
    </xsl:template>

    <xsl:template match="tei:country" mode="metadata">
        <p class="metadata-country">
            Country: <xsl:value-of select="."/> (<xsl:value-of select="@key"/>)
        </p>
    </xsl:template>

    <xsl:template match="tei:bloc" mode="metadata">
        <p class="metadata-bloc">
            Bloc: <xsl:value-of select="."/> (<xsl:value-of select="@key"/>)
        </p>
    </xsl:template>


    <xsl:template match="tei:revisionDesc" mode="metadata">
        <div class="metadata-section revision-desc">
            <h3>Revision Description</h3>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:change" mode="metadata">
        <div class="metadata-change" data-when="{@when}" data-who="{@who}">
            <h5>Change: <xsl:value-of select="@when"/> - Who: <xsl:value-of select="@who"/></h5>
            <p><xsl:value-of select="."/></p>
        </div>
    </xsl:template>


    <xsl:template match="tei:div[@type='appendix']" mode="metadata">
        <div class="glossary">
            <h3>Glossary</h3>
            <xsl:apply-templates select="tei:list[@type='gloss']"/>
        </div>
    </xsl:template>

    <xsl:template match="tei:list[@type='gloss']" mode="metadata">
        <dl class="glossary-list">
            <xsl:apply-templates select="tei:item"/>
        </dl>
    </xsl:template>

    <xsl:template match="tei:item" mode="metadata">
        <div class="glossary-item" data-xml-id="{@xml:id}">
            <dt class="glossary-term">
                <xsl:apply-templates select="tei:term"/>
            </dt>
            <dd class="glossary-definition" mode="metadata">
                <xsl:apply-templates select="tei:gloss"/>
            </dd>
        </div>
    </xsl:template>

    <xsl:template match="tei:term" mode="metadata">
        <span class="glossary-term-text" data-xml-lang="{@xml:lang}">
            <xsl:value-of select="."/>
             <xsl:if test="@xml:lang">
                (<xsl:value-of select="@xml:lang"/>)
            </xsl:if>
        </span>
    </xsl:template>

    <xsl:template match="tei:gloss" mode="metadata">
        <p class="glossary-definition-text">
            <xsl:value-of select="."/>
        </p>
    </xsl:template>


</xsl:stylesheet>