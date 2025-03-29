<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                version="2.0"
                exclude-result-prefixes="tei">
    
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
    
    <!-- Chiavi ottimizzate per la ricerca -->
    <xsl:key name="glossary-entry" match="tei:listPerson/tei:person | tei:listOrg/tei:org | tei:listPlace/tei:place" use="@xml:id"/>
    <xsl:key name="page-by-id" match="tei:surface" use="@xml:id"/>
    <xsl:key name="zone-by-id" match="tei:zone" use="@xml:id"/>
    <xsl:key name="columns-by-page" match="tei:cb" use="generate-id(preceding::tei:pb[1])"/>

    <!-- Root template -->
    <xsl:template match="/">
        <html>
            <head>
                <meta charset="UTF-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                <title><xsl:value-of select="//tei:titleStmt/tei:title[@type='main']"/></title>
                <link rel="stylesheet" href="styles.css"/>
                <script src="script.js"></script>
            </head>
            <body>
                <!-- Header  -->
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

                <!-- Main  -->
                <main>
                    <!-- Metadata section a tendina -->
                    <h2>Informazioni sui testi e la codifica</h2>
                    <div class="teiheader">
                        <!-- Sezione Desc del file -->
                        <div class="tendina">
                            <h2>Descrizione del file</h2>
                            <div class="pannello">
                                <xsl:if test="//tei:fileDesc/tei:titleStmt">
                                    <h3>Titolo e autori</h3>
                                    <p><strong>Titolo: </strong><xsl:value-of select="//tei:fileDesc/tei:titleStmt/tei:title[@type='main']"/></p>
                                    <xsl:if test="//tei:fileDesc/tei:titleStmt/tei:title[@type='sub']">
                                        <p><strong>Sottotitolo: </strong><xsl:value-of select="//tei:fileDesc/tei:titleStmt/tei:title[@type='sub']"/></p>
                                    </xsl:if>
                                    <xsl:if test="//tei:fileDesc/tei:titleStmt/tei:author">
                                        <p><strong>Autori: </strong>
                                            <xsl:for-each select="//tei:fileDesc/tei:titleStmt/tei:author">
                                                <xsl:value-of select="."/>
                                                <xsl:if test="position() != last()">, </xsl:if>
                                            </xsl:for-each>
                                        </p>
                                    </xsl:if>
                                    <xsl:if test="//tei:fileDesc/tei:titleStmt/tei:editor">
                                        <p><strong>Editore: </strong><xsl:value-of select="//tei:fileDesc/tei:titleStmt/tei:editor"/></p>
                                    </xsl:if>
                                    <xsl:if test="//tei:fileDesc/tei:titleStmt/tei:respStmt">
                                        <p><strong>Responsabilità: </strong>
                                            <xsl:for-each select="//tei:fileDesc/tei:titleStmt/tei:respStmt">
                                                <xsl:value-of select="tei:resp"/><xsl:text> </xsl:text><xsl:value-of select="tei:name"/>
                                                <xsl:if test="position() != last()">; </xsl:if>
                                            </xsl:for-each>
                                        </p>
                                    </xsl:if>
                                </xsl:if>
                                
                                <xsl:if test="//tei:fileDesc/tei:editionStmt">
                                    <h3>Edizione</h3>
                                    <xsl:if test="//tei:fileDesc/tei:editionStmt/tei:edition">
                                        <p><strong>Data: </strong>Edizione del <xsl:value-of select="//tei:fileDesc/tei:editionStmt/tei:edition"/></p>
                                    </xsl:if>
                                    <xsl:if test="//tei:fileDesc/tei:editionStmt/tei:respStmt">
                                        <p><strong>Coordinazione: </strong><xsl:value-of select="//tei:fileDesc/tei:editionStmt/tei:respStmt/tei:name"/></p>
                                    </xsl:if>
                                </xsl:if>
                                
                                <xsl:if test="//tei:fileDesc/tei:publicationStmt">
                                    <h3>Pubblicazione</h3>
                                    <xsl:if test="//tei:fileDesc/tei:publicationStmt/tei:publisher">
                                        <p><strong>Pubblicante: </strong><xsl:value-of select="//tei:fileDesc/tei:publicationStmt/tei:publisher"/></p>
                                    </xsl:if>
                                    <xsl:if test="//tei:fileDesc/tei:publicationStmt/tei:date">
                                        <p><strong>Data: </strong><xsl:value-of select="//tei:fileDesc/tei:publicationStmt/tei:date"/></p>
                                    </xsl:if>
                                    <xsl:if test="//tei:fileDesc/tei:publicationStmt/tei:availability">
                                        <p><strong>Disponibilità: </strong><xsl:value-of select="//tei:fileDesc/tei:publicationStmt/tei:availability"/></p>
                                    </xsl:if>
                                </xsl:if>
                                
                                
<xsl:if test="//tei:fileDesc/tei:sourceDesc">
    <h3>Descrizione della fonte</h3>
    <div class="source-description">
        <!-- Template specifico per msDesc -->
        <xsl:if test="//tei:fileDesc/tei:sourceDesc/tei:msDesc">
            <div class="ms-description">
                <h4>Informazioni sul manoscritto</h4>
                <xsl:for-each select="//tei:fileDesc/tei:sourceDesc/tei:msDesc/*">
                    <xsl:choose>
                        <xsl:when test="self::tei:msIdentifier">
                            <div class="ms-identifier">
                                <p><strong>Identificativo:</strong> 
                                    <xsl:if test="tei:settlement"><xsl:value-of select="tei:settlement"/>, </xsl:if>
                                    <xsl:if test="tei:repository"><xsl:value-of select="tei:repository"/>, </xsl:if>
                                    <xsl:if test="tei:idno"><xsl:value-of select="tei:idno"/></xsl:if>
                                </p>
                            </div>
                        </xsl:when>
                        <xsl:when test="self::tei:physDesc">
    <div class="ms-physical">
        <h5>Descrizione fisica</h5>
        
        <!-- Gestione di objectDesc -->
        <xsl:if test="tei:objectDesc">
            <div class="object-description">
                <!-- Descrizione del supporto -->
                <xsl:if test="tei:objectDesc/tei:supportDesc">
                    <p><strong>Supporto:</strong> 
                        <xsl:value-of select="tei:objectDesc/tei:supportDesc/tei:support"/>
                    </p>
                </xsl:if>
                
                <!-- Descrizione del layout -->
                <xsl:if test="tei:objectDesc/tei:layoutDesc">
                    <p><strong>Layout:</strong> 
                        <xsl:value-of select="tei:objectDesc/tei:layoutDesc/tei:layout"/>
                        <xsl:if test="tei:objectDesc/tei:layoutDesc/tei:layout/@columns">
                            <span class="layout-columns"> 
                                (<xsl:value-of select="tei:objectDesc/tei:layoutDesc/tei:layout/@columns"/> colonne)
                            </span>
                        </xsl:if>
                    </p>
                </xsl:if>
            </div>
        </xsl:if>
        
        <!-- Gestione di typeDesc -->
        <xsl:if test="tei:typeDesc">
            <div class="type-description">
                <p><strong>Tipologia:</strong></p>
                <ul class="type-list">
                    <xsl:for-each select="tei:typeDesc/tei:p">
                        <li><xsl:value-of select="."/></li>
                    </xsl:for-each>
                </ul>
            </div>
        </xsl:if>
        
        <!-- Altri elementi in physDesc -->
        <xsl:for-each select="*[not(self::tei:objectDesc) and not(self::tei:typeDesc)]">
            <div class="other-physical-desc">
                <xsl:apply-templates select="."/>
            </div>
        </xsl:for-each>
    </div>
</xsl:when>
                        <xsl:when test="self::tei:history">
                            <div class="ms-history">
                                <h5>Storia del documento</h5>
                                <xsl:if test="tei:origin">
                                    <p><strong>Origine:</strong> <xsl:apply-templates select="tei:origin/node()"/></p>
                                </xsl:if>
                                <xsl:for-each select="tei:provenance">
                                    <p><strong>Provenienza:</strong> <xsl:apply-templates select="node()"/></p>
                                </xsl:for-each>
                            </div>
                        </xsl:when>
                        <xsl:otherwise>
                            <div class="ms-other">
                                <xsl:apply-templates select="."/>
                            </div>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </div>
        </xsl:if>
        
        <!-- Gestione delle altre descrizioni di fonte -->
        <xsl:for-each select="//tei:fileDesc/tei:sourceDesc/node()[not(self::tei:msDesc)]">
            <xsl:choose>
                <!-- Gestisce i nodi di testo direttamente nel sourceDesc -->
                <xsl:when test="self::text()">
                    <xsl:if test="normalize-space(.) != ''">
                        <p><xsl:value-of select="normalize-space(.)"/></p>
                    </xsl:if>
                </xsl:when>
                <!-- Gestisce elementi figli come bibl, ecc. -->
                <xsl:when test="self::tei:bibl">
                    <div class="source-bibl">
                        <p><strong>Riferimento bibliografico:</strong> <xsl:value-of select="."/></p>
                    </div>
                </xsl:when>
                <!-- Gestisce altri elementi -->
                <xsl:otherwise>
                    <div class="source-item">
                        <div class="formatted-source">
                            <!-- Articoli - prima sezione -->
                            <div class="source-section">
                                <h4>ARTICOLI</h4>
                                <ul>
                                    <li><a href="#page-382" class="source-link">CORRISPONDENZA DA LECCE - LA RACCOLTA DEGLI ULIVI</a></li>
                                    <li><a href="#page-384" class="source-link">LE PREVISIONI FINANZIARIE</a></li>
                                </ul>
                            </div>
                            
                            <!-- Bibliografia - seconda sezione -->
                            <div class="source-section">
                                <h4>BIBLIOGRAFIA</h4>
                                <ul>
                                    <li><a href="#page-386" class="source-link">ETNOLOGIA</a></li>
                                    <li><a href="#page-387" class="source-link">SCIENZE MILITARI</a></li>
                                </ul>
                            </div>
                            
                            <!-- Notizie - terza sezione -->
                            <div class="source-section">
                                <h4>NOTIZIE</h4>
                                <p><a href="#page-388" class="source-link">Prime due notizie</a></p>
                            </div>
                            
                            <!-- Informazioni editoriali -->
                            <div class="editorial-info">
                                <p><strong>Casa editrice:</strong> Barbéra</p>
                                <p><strong>Titolo:</strong> La Rassegna Settimanale di Politica, Scienze, Lettere ed Arti</p>
                                <p><strong>Lingua:</strong> Italiano</p>
                                <p><strong>Fondata da:</strong> Leopoldo Franchetti, Sydney Sonnino</p>
                                <p><strong>Luogo:</strong> Firenze</p>
                                <p><strong>Tipografia:</strong> Barbéra</p>
                                <p><strong>Anno:</strong> 1879</p>
                                <p><strong>Volume:</strong> 3</p>
                                <p><strong>Numero:</strong> 72</p>
                                <p><strong>Pagine:</strong>382, 383, 384, 386, 387, 388</p>
                            </div>
                        </div>
                    </div>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </div>
</xsl:if>
                            </div>
                        </div>
                        
                        <!-- Sezione Descrizione della codifica -->
                        <div class="tendina">
                            <h2>Descrizione della codifica</h2>
                            <div class="pannello">
                                <xsl:if test="//tei:encodingDesc/tei:projectDesc">
                                    <h3>Progetto</h3>
                                    <div class="metadata-card">
                                        <p><xsl:value-of select="//tei:encodingDesc/tei:projectDesc"/></p>
                                    </div>
                                </xsl:if>
                                <xsl:if test="//tei:encodingDesc/tei:samplingDecl">
                                    <h3>Campionamento</h3>
                                    <div class="metadata-card">
                                        <p><xsl:value-of select="//tei:encodingDesc/tei:samplingDecl"/></p>
                                    </div>
                                </xsl:if>
                                <xsl:if test="//tei:encodingDesc/tei:editorialDecl">
                                    <h3>Dichiarazione editoriale</h3>
                                    <xsl:if test="//tei:encodingDesc/tei:editorialDecl/tei:correction">
                                        <div class="metadata-card">
                                            <h4>Correzioni</h4>
                                            <p><xsl:value-of select="//tei:encodingDesc/tei:editorialDecl/tei:correction"/></p>
                                        </div>
                                    </xsl:if>
                                    <xsl:if test="//tei:encodingDesc/tei:editorialDecl/tei:normalization">
                                        <div class="metadata-card">
                                            <h4>Normalizzazione</h4>
                                            <p><xsl:value-of select="//tei:encodingDesc/tei:editorialDecl/tei:normalization"/></p>
                                        </div>
                                    </xsl:if>
                                </xsl:if>
                            </div>
                        </div>
                    </div>

                    <!-- Pages  -->
                    <xsl:apply-templates select="//tei:pb" mode="page-layout"/>

                    <!-- Glossary alla fine-->
                    <xsl:apply-templates select="//tei:back/tei:div[@type='appendix']"/>
                </main>

                <!-- Footer  -->
                <footer>
                    <div>
                        <p>Progetto realizzato per il corso di Codifica di Testi <xsl:value-of select="format-date(current-date(), '[Y]')"/>.</p>
                    </div>
                    <h3>Note</h3>
                    <p>La versione digitale di questo documento è disponibile su <a href="#">GitHub</a></p>
                </footer>

                <!-- Back-to-top  -->
                <button class="back-to-top">↑</button>
                <div class="button-controls">
                    <div class="control-group">
                        <span class="control-label">Varianti di testo:</span>
                        <button id="toggle-orig-reg" class="toggle-button">Mostra forme regolarizzate</button>
                        <button id="toggle-sic-corr" class="toggle-button">Mostra correzioni</button>
                        <button id="toggle-abbr-expan" class="toggle-button">Mostra espansioni</button>
                    </div>
                    
                    <div class="control-group">
                        <span class="control-label">Entità:</span>
                        <button class="entity-button" data-entity="person">Persone</button>
                        <button class="entity-button" data-entity="place">Luoghi</button>
                        <button class="entity-button" data-entity="org">Organizzazioni</button>
                        <button class="entity-button" data-entity="term">Termini</button>
                        <button class="entity-button" data-entity="date">Date</button>
                        <button class="entity-button" data-entity="quote">Citazioni</button>
                        <button class="entity-button" data-entity="theme">Temi</button>
                        <button class="entity-button" data-entity="measure">Misure</button>
                    </div>
                </div>
            </body>
        </html>
    </xsl:template>

    <!-- UTILITY TEMPLATES -->
    
    <!-- Template per estrarre e applicare data-zone-id -->
    <xsl:template name="extract-zone-id">
        <xsl:param name="facs"/>
        <xsl:if test="$facs">
            <xsl:attribute name="data-zone-id">
                <xsl:value-of select="substring-after($facs, '#')"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    
    <!-- Template comune per entità -->
    <xsl:template name="entity-handler">
    <xsl:param name="entity-type"/>
    <xsl:param name="content"/>
    <xsl:param name="ref-id" select="substring-after(@ref, '#')"/>
    <xsl:param name="type" select="@type"/>
    
    <span class="entity {$entity-type}-name" data-entity="{$entity-type}">
        <xsl:if test="$type">
            <xsl:attribute name="data-type"><xsl:value-of select="$type"/></xsl:attribute>
        </xsl:if>
        
        <xsl:variable name="glossary-item" select="key('glossary-entry', $ref-id)"/>
        <xsl:variable name="wiki-url">
            <xsl:choose>
                <xsl:when test="$entity-type='person'">
                    <xsl:value-of select="$glossary-item/tei:persName/tei:ref/@target"/>
                </xsl:when>
                <xsl:when test="$entity-type='place'">
                    <xsl:value-of select="$glossary-item/tei:placeName/tei:ref/@target"/>
                </xsl:when>
                <xsl:when test="$entity-type='org'">
                    <xsl:value-of select="$glossary-item/tei:orgName/tei:ref/@target"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="$wiki-url != ''">
                <xsl:attribute name="data-ref"><xsl:value-of select="$wiki-url"/></xsl:attribute>
                <a href="{$wiki-url}" target="_blank">
                    <xsl:copy-of select="$content"/>
                </a>
            </xsl:when>
            <xsl:when test="@ref and not($ref-id = '')">
                <xsl:attribute name="data-ref"><xsl:value-of select="@ref"/></xsl:attribute>
                <a href="#glossary-{$ref-id}" class="glossary-link">
                    <xsl:copy-of select="$content"/>
                </a>
            </xsl:when>
            <xsl:when test="@ref and starts-with(@ref, 'http')">
                <xsl:attribute name="data-ref"><xsl:value-of select="@ref"/></xsl:attribute>
                <a href="{@ref}" target="_blank">
                    <xsl:copy-of select="$content"/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="$content"/>
            </xsl:otherwise>
        </xsl:choose>
    </span>
</xsl:template>

    <!-- TEMPLATES PER IL LAYOUT DELLE PAGINE -->
    
    <!-- Template principale per il layout delle pagine -->
    <xsl:template match="tei:pb" mode="page-layout">
        <div class="page-container" id="page-{@n}" tabindex="-1">
            <!-- Gestione dell'immagine della pagina -->
            <xsl:call-template name="page-image"/>
            
            <!-- Gestione della trascrizione della pagina -->
            <xsl:call-template name="page-transcription"/>
        </div>
    </xsl:template>
    
    <!-- Template per l'immagine della pagina -->
    <xsl:template name="page-image">
        <div class="page-image image-column">
            <div class="image-container">
                <xsl:variable name="pageId" select="concat('p', @n)"/>
                <xsl:choose>
                    <xsl:when test="//tei:facsimile/tei:surface[@xml:id = $pageId]/tei:graphic">
                        <xsl:apply-templates select="//tei:facsimile/tei:surface[@xml:id = $pageId]/tei:graphic" mode="page-image"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <img class="tei-image" src="images/placeholder.jpg" alt="No image for Page {@n}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </div>
    </xsl:template>
    
    <!-- Template per la trascrizione della pagina -->
    <xsl:template name="page-transcription">
        <div class="page-transcription text-columns">
            <div class="scrollable-columns">
                <h3>Page <xsl:value-of select="@n"/></h3>
                <div class="columns-container">
                    <xsl:variable name="currentPage" select="."/>
                    <xsl:variable name="nextPage" select="following::tei:pb[1]"/>
                    
                    <!-- Utilizzo della key per trovare le colonne di questa pagina -->
                    <xsl:variable name="pageColumns" select="key('columns-by-page', generate-id($currentPage))"/>
                    
                    <xsl:choose>
                        <xsl:when test="$pageColumns">
                            <xsl:for-each select="$pageColumns">
                                <xsl:call-template name="render-column">
                                    <xsl:with-param name="currentPage" select="$currentPage"/>
                                    <xsl:with-param name="nextPage" select="$nextPage"/>
                                </xsl:call-template>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- Fallback per contenuti prima del primo cb -->
                            <div class="column text-column column-1">
                                <div class="column-header">Colonna 1</div>
                                <xsl:apply-templates select="following-sibling::node()[not(self::tei:pb) and not(self::tei:cb) and (not($nextPage) or generate-id(following::tei:pb[1])!=generate-id($nextPage))]"/>
                            </div>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
            </div>
        </div>
    </xsl:template>
    
    <!-- Template per il rendering di una colonna -->
    <xsl:template name="render-column">
        <xsl:param name="currentPage"/>
        <xsl:param name="nextPage"/>
        
        <xsl:variable name="currentCb" select="."/>
        <xsl:variable name="nextCb" select="following::tei:cb[1]"/>
        
        <!-- Seleziona il contenuto della colonna  -->
        <xsl:variable name="columnContent" select="following-sibling::node()[
            not(self::tei:pb) and 
            not(self::tei:cb) and 
            generate-id(preceding::tei:cb[1])=generate-id($currentCb) and 
            (not($nextPage) or generate-id(preceding::tei:pb[1])=generate-id($currentPage))
        ]"/>
        
        <div class="column text-column column-{@n}">
            <div class="column-header">
                <xsl:choose>
                    <xsl:when test="@n='1'">Colonna sx</xsl:when>
                    <xsl:when test="@n='2'">Colonna dx</xsl:when>
                    <xsl:otherwise>Colonna <xsl:value-of select="@n"/></xsl:otherwise>
                </xsl:choose>
            </div>
            <xsl:apply-templates select="$columnContent"/>
        </div>
    </xsl:template>

    <!-- Template per tei:graphic con SVG overlay -->
    <xsl:template match="tei:graphic" mode="page-image">
        <div class="image-wrapper">
            <img class="tei-image" src="{@url}" alt="Page {preceding::tei:pb[1]/@n}">
                <xsl:if test="@width">
                    <xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="@height">
                    <xsl:attribute name="height"><xsl:value-of select="@height"/></xsl:attribute>
                </xsl:if>
            </img>
            <svg class="zone-overlay" viewBox="0 0 {@width} {@height}">
                <xsl:apply-templates select="../tei:zone" mode="svg"/>
            </svg>
        </div>
    </xsl:template>

    <!-- Template per zone in modalitàsvg  -->
    <xsl:template match="tei:zone" mode="svg">
        <polygon class="highlight-zone" id="zone-{@xml:id}" points="{@points}" data-zone-id="{@xml:id}"/>
    </xsl:template>

    <!-- Template per tei:text -->
    <xsl:template match="tei:text">
        <xsl:apply-templates select="tei:front"/>
        <xsl:apply-templates select="tei:body"/>
        <xsl:apply-templates select="tei:back"/>
    </xsl:template>

    <!-- Template per tei:front -->
    <xsl:template match="tei:front">
        <div class="front">
            <xsl:apply-templates select="tei:div[@type='titlePage']"/>
        </div>
    </xsl:template>

    <!-- Template per title page -->
    <xsl:template match="tei:div[@type='titlePage']">
        <div class="title-page">
            <h1><xsl:value-of select="tei:head/tei:title"/></h1>
            <xsl:apply-templates select="tei:p"/>
        </div>
    </xsl:template>

    <!-- Template per tei:body -->
    <xsl:template match="tei:body">
        <div class="body">
            <xsl:apply-templates select="tei:div"/>
        </div>
    </xsl:template>

    <!--  template per article div -->
    <xsl:template match="tei:div[@type='article']">
        <article>
            <xsl:apply-templates select="tei:head"/>
            <xsl:apply-templates select="tei:p"/>
            <xsl:apply-templates select="tei:opener"/>
            <xsl:apply-templates select="tei:closer"/>
        </article>
    </xsl:template>

    <!-- Template per head in article -->
    <xsl:template match="tei:head[parent::tei:div[@type='article']]">
    <header>
        <h2>
            <xsl:if test="tei:title[@type='main']/@facs">
                <xsl:call-template name="extract-zone-id">
                    <xsl:with-param name="facs" select="tei:title[@type='main']/@facs"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:apply-templates select="tei:title[@type='main']/node()"/>
        </h2>
        <h3>
            <xsl:if test="tei:title[@type='sub']/@facs">
                <xsl:call-template name="extract-zone-id">
                    <xsl:with-param name="facs" select="tei:title[@type='sub']/@facs"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:apply-templates select="tei:title[@type='sub']/node()"/>
        </h3>
    </header>
</xsl:template>
    <!-- Regola per i termini che hanno un riferimento al glossario -->
<xsl:template match="term[@corresp] | measure[@corresp]">
  <span class="glossario-termine" title="Clicca per vedere la definizione">
    <xsl:attribute name="data-def">
      <xsl:value-of select="substring-after(@corresp, '#')"/>
    </xsl:attribute>
    <xsl:apply-templates/>
  </span>
</xsl:template>

    <!-- Template per opener -->
    <xsl:template match="tei:opener">
        <div class="opener">
            <xsl:call-template name="extract-zone-id">
                <xsl:with-param name="facs" select="@facs"/>
            </xsl:call-template>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:byline">
        <div class="byline">
            <xsl:call-template name="extract-zone-id">
                <xsl:with-param name="facs" select="@facs"/>
            </xsl:call-template>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:dateline">
        <div class="dateline">
            <xsl:call-template name="extract-zone-id">
                <xsl:with-param name="facs" select="@facs"/>
            </xsl:call-template>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- Template per closer -->
    <xsl:template match="tei:closer">
        <div class="closer">
            <xsl:call-template name="extract-zone-id">
                <xsl:with-param name="facs" select="@facs"/>
            </xsl:call-template>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- Signed -->
    <xsl:template match="tei:signed">
        <p class="signed">
            <xsl:call-template name="extract-zone-id">
                <xsl:with-param name="facs" select="@facs"/>
            </xsl:call-template>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!-- Template per bibliografia div -->
    <xsl:template match="tei:div[@type='bibliografia']">
        <section class="bibliografia">
            <h2>Bibliografia</h2>
            <xsl:apply-templates select="tei:div[@type='subsection']"/>
        </section>
    </xsl:template>

    <!-- Template per subsection div -->
    <xsl:template match="tei:div[@type='subsection']">
        <section class="{@n}">
            <h3><xsl:value-of select="tei:head/tei:title"/></h3>
            <xsl:apply-templates select="tei:bibl"/>
            <xsl:apply-templates select="tei:p"/>
            <xsl:apply-templates select="tei:note"/>
        </section>
    </xsl:template>

    <!-- Template per bibl -->
    <xsl:template match="tei:bibl">
        <xsl:choose>
            <xsl:when test="parent::tei:p or parent::tei:note">
                <span class="bibl">
                    <xsl:call-template name="extract-zone-id">
                        <xsl:with-param name="facs" select="@facs"/>
                    </xsl:call-template>
                    <xsl:call-template name="format-bibl"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <div class="bibl">
                    <xsl:call-template name="extract-zone-id">
                        <xsl:with-param name="facs" select="@facs"/>
                    </xsl:call-template>
                    <p>
                        <xsl:call-template name="format-bibl"/>
                    </p>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Template per formattare il contenuto bibliografico -->
    <xsl:template name="format-bibl">
        <xsl:apply-templates select="tei:biblScope"/>
        <xsl:if test="tei:biblScope and (tei:author or .//tei:title)">, </xsl:if>
        <xsl:apply-templates select="tei:author"/>
        <xsl:if test="tei:author and .//tei:title">, </xsl:if>
        <xsl:if test=".//tei:title">
            <i>
                <xsl:choose>
                    <xsl:when test="tei:title[@type='main']">
                        <xsl:apply-templates select="tei:title[@type='main']"/>
                    </xsl:when>
                    <xsl:when test=".//tei:title[@type='main']">
                        <xsl:apply-templates select=".//tei:title[@type='main']"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="tei:title | .//tei:title"/>
                    </xsl:otherwise>
                </xsl:choose>
            </i>
        </xsl:if>
        <xsl:if test="tei:title[@type='translated'] or .//tei:title[@type='translated']">
            (<xsl:apply-templates select="tei:title[@type='translated'] | .//tei:title[@type='translated']"/>)
        </xsl:if>
        <xsl:if test="tei:pubPlace or tei:publisher or tei:date">
            — <xsl:apply-templates select="tei:pubPlace"/>, <xsl:apply-templates select="tei:publisher"/>, <xsl:apply-templates select="tei:date"/>.
        </xsl:if>
    </xsl:template>

    <!-- Template per author con roleName -->
    <xsl:template match="tei:author">
        <span class="author">
            <xsl:apply-templates select="tei:persName"/>
            <xsl:if test="tei:roleName"> (<xsl:value-of select="tei:roleName"/>) </xsl:if>
        </span>
    </xsl:template>

    <!-- Template per notizie  -->
    <xsl:template match="tei:div[@type='section' and @n='notizie']">
        <section class="notizie">
            <h2><xsl:value-of select="tei:head/tei:title"/></h2>
            <xsl:apply-templates select="tei:div[@type='entry']"/>
        </section>
    </xsl:template>

    <!-- Template per news  -->
    <xsl:template match="tei:div[@type='entry']">
        <div class="news-entry">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- GLOSSARIO E APPENDICI -->
    
    <!-- Template principale per l'appendice -->
    <xsl:template match="tei:back/tei:div[@type='appendix']">
        <div class="glossario">
            <h2><xsl:value-of select="tei:head"/></h2>
            
            <!-- Persone -->
            <xsl:if test="tei:listPerson/tei:person">
            <h3>Persone</h3>
            <div class="gloss">
                <xsl:for-each select="tei:listPerson/tei:person">
                    <div class="item">
                        <strong>
                            <a href="{tei:persName/tei:ref/@target}" target="_blank">
                                <xsl:choose>
                                    <!-- Per le etnie, mostra il nome dall'elemento name -->
                                    <xsl:when test="tei:persName/@type='ethnic'">
                                        <xsl:value-of select="tei:persName/tei:name"/>
                                    </xsl:when>
                                    <!-- Per le persone normali, mostra forename + surname -->
                                    <xsl:otherwise>
                                        <xsl:value-of select="tei:persName/tei:forename"/>
                                        <xsl:if test="tei:persName/tei:addName">
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="tei:persName/tei:addName"/>
                                        </xsl:if>
                                        <xsl:if test="tei:persName/tei:surname">
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="tei:persName/tei:surname"/>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </a>
                        </strong>
                        
                        <!-- Mostra le date di nascita e morte se presenti -->
                        <xsl:if test="tei:birth or tei:death">
                            <span class="person-dates">
                                <xsl:text> (</xsl:text>
                                <xsl:if test="tei:birth/@when">
                                    <xsl:value-of select="tei:birth/@when"/>
                                </xsl:if>
                                <xsl:text> – </xsl:text>
                                <xsl:if test="tei:death/@when">
                                    <xsl:value-of select="tei:death/@when"/>
                                </xsl:if>
                                <xsl:text>)</xsl:text>
                            </span>
                        </xsl:if>
                        <br/>
                        
                        <!-- Mostra occupazione se presente -->
                        <xsl:if test="tei:occupation">
                            <em>Occupazione: </em><xsl:value-of select="tei:occupation"/><br/>
                        </xsl:if>
                        
                        <!-- Mostra nota se presente -->
                        <xsl:if test="tei:note">
                            <em>Nota: </em><xsl:value-of select="tei:note"/>
                        </xsl:if>
                    </div>
                </xsl:for-each>
            </div>
        </xsl:if>
            
            <!-- Luoghi -->
            <xsl:if test="tei:listPlace/tei:place">
                <h3>Luoghi</h3>
                <div class="gloss">
                    <xsl:for-each select="tei:listPlace/tei:place">
                        <div class="item">
                            <strong>
                                <a href="{tei:placeName/tei:ref/@target}" target="_blank">
                                    <xsl:value-of select="tei:placeName/tei:name[@full='yes']"/>
                                </a>
                            </strong>
                            <br/>
                            <em>Tipologia: </em><xsl:value-of select="@type"/>
                            <xsl:if test="tei:desc">
                                <br/><em>Descrizione: </em>
                                <xsl:value-of select="tei:desc"/>
                            </xsl:if>
                        </div>
                    </xsl:for-each>
                </div>
            </xsl:if>
            
            <!-- Organizzazioni -->
            <xsl:if test="tei:listOrg/tei:org">
                <h3>Organizzazioni</h3>
                <div class="gloss">
                    <xsl:for-each select="tei:listOrg/tei:org">
                        <div class="item">
                            <strong>
                                <a href="{tei:orgName/tei:ref/@target}" target="_blank">
                                    <xsl:value-of select="tei:orgName/tei:name[@full='yes']"/>
                                </a>
                            </strong>
                            <br/>
                            <xsl:if test="tei:desc">
                                <em>Descrizione: </em>
                                <xsl:value-of select="tei:desc"/>
                            </xsl:if>
                        </div>
                    </xsl:for-each>
                </div>
            </xsl:if>
            <!-- Termini del Glossario -->
            <xsl:if test="tei:list[@type='gloss']">
            <h3>Glossario delle unità di misura e termini dialettali</h3>
            <div class="gloss">
                <xsl:for-each select="tei:list[@type='gloss']/tei:label">
                <div class="item" id="glossary-{@xml:id}">
                    <strong>
                    <xsl:value-of select="text()"/>
                    </strong>
                    <xsl:if test="tei:ref">
                    <a href="{tei:ref/@target}" target="_blank" class="external-link">[Treccani]</a>
                    </xsl:if>
                    <p>
                    <xsl:value-of select="following-sibling::tei:item[1]"/>
                    </p>
                </div>
                </xsl:for-each>
            </div>
            </xsl:if>
            
        </div>
    </xsl:template>

    <!-- Templates per gli elementi di base -->
    
    <!-- Template for paragraphs -->
    <xsl:template match="tei:p">
        <p>
            <xsl:call-template name="extract-zone-id">
                <xsl:with-param name="facs" select="@facs"/>
            </xsl:call-template>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!-- Template per head -->
    <xsl:template match="tei:head">
        <h2>
            <xsl:call-template name="extract-zone-id">
                <xsl:with-param name="facs" select="@facs"/>
            </xsl:call-template>
            <xsl:apply-templates/>
        </h2>
    </xsl:template>

    <!-- Template per italic -->
    <xsl:template match="tei:hi[@rend='italic']">
        <i><xsl:apply-templates/></i>
    </xsl:template>

    <!-- Template per choice  -->
    <xsl:template match="tei:choice">
        <span class="choice">
            <!-- Handle orig/reg -->
            <xsl:if test="tei:orig and tei:reg">
                <span class="orig-reg">
                    <span class="orig">
                        <xsl:apply-templates select="tei:orig"/>
                    </span>
                    <span class="reg hidden">
                        <xsl:apply-templates select="tei:reg"/>
                    </span>
                </span>
            </xsl:if>
            <!--  sic/corr -->
            <xsl:if test="tei:sic and tei:corr">
                <span class="sic-corr">
                    <span class="sic">
                        <xsl:apply-templates select="tei:sic"/>
                    </span>
                    <span class="corr hidden">
                        <xsl:apply-templates select="tei:corr"/>
                    </span>
                </span>
            </xsl:if>
            <!--  abbr/expan -->
            <xsl:if test="tei:abbr and tei:expan">
                <span class="abbr-expan">
                    <span class="abbr">
                        <xsl:apply-templates select="tei:abbr"/>
                    </span>
                    <span class="expan hidden">
                        <xsl:apply-templates select="tei:expan"/>
                    </span>
                </span>
            </xsl:if>
        </span>
    </xsl:template>

    <!-- Template per note -->
    <xsl:template match="tei:note">
        <div class="note">
            <xsl:call-template name="extract-zone-id">
                <xsl:with-param name="facs" select="@facs"/>
            </xsl:call-template>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- Template per lists con attributi  -->
    <xsl:template match="tei:list">
        <xsl:choose>
            <xsl:when test="@type='ordered'">
                <ol>
                    <xsl:if test="parent::tei:p/@facs">
                        <xsl:call-template name="extract-zone-id">
                            <xsl:with-param name="facs" select="parent::tei:p/@facs"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:apply-templates select="tei:item"/>
                </ol>
            </xsl:when>
            <xsl:otherwise>
                <ul>
                    <xsl:if test="parent::tei:p/@facs">
                        <xsl:call-template name="extract-zone-id">
                            <xsl:with-param name="facs" select="parent::tei:p/@facs"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:apply-templates select="tei:item"/>
                </ul>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Template per list items -->
    <xsl:template match="tei:item">
        <li><xsl:apply-templates/></li>
    </xsl:template>

    <!-- Template per figures con immagine -->
    <xsl:template match="tei:figure">
        <div class="figure-container">
            <figure class="tei-figure">
                <xsl:apply-templates select="tei:graphic"/>
                <xsl:if test="tei:head">
                    <figcaption><xsl:apply-templates select="tei:head"/></figcaption>
                </xsl:if>
                <xsl:if test="tei:code | tei:eg">
                    <pre class="figure-code"><code><xsl:apply-templates select="tei:code | tei:eg"/></code></pre>
                </xsl:if>
            </figure>
        </div>
    </xsl:template>

    <!-- Template for immagine -->
    <xsl:template match="tei:graphic">
        <img class="tei-image" src="{@url}">
            <xsl:attribute name="alt">
                <xsl:choose>
                    <xsl:when test="../tei:head"><xsl:value-of select="../tei:head"/></xsl:when>
                    <xsl:otherwise>Image</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:if test="@width">
                <xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="@height">
                <xsl:attribute name="height"><xsl:value-of select="@height"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="@rend">
                <xsl:attribute name="class">tei-image <xsl:value-of select="@rend"/></xsl:attribute>
            </xsl:if>
        </img>
    </xsl:template>

    <!-- Template per code examples -->
    <xsl:template match="tei:code | tei:eg">
        <pre><code><xsl:apply-templates/></code></pre>
    </xsl:template>

    <!-- Template per line breaks -->
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>

    
    
    <!-- Template per persName -->
    <xsl:template match="tei:persName">
        <xsl:call-template name="entity-handler">
            <xsl:with-param name="entity-type">person</xsl:with-param>
            <xsl:with-param name="content"><xsl:apply-templates/></xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Template per placeName -->
    <xsl:template match="tei:placeName">
        <xsl:call-template name="entity-handler">
            <xsl:with-param name="entity-type">place</xsl:with-param>
            <xsl:with-param name="content"><xsl:apply-templates/></xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Template per orgName -->
    <xsl:template match="tei:orgName">
        <xsl:call-template name="entity-handler">
            <xsl:with-param name="entity-type">org</xsl:with-param>
            <xsl:with-param name="content"><xsl:apply-templates/></xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Template per title -->
    <xsl:template match="tei:title">
        <span class="title" data-entity="title">
            <xsl:choose>
                <!-- Caso 1: quando c'è un tei:ref all'interno del titolo -->
                <xsl:when test="tei:ref[@target]">
                    <xsl:apply-templates select="tei:ref"/>
                </xsl:when>
                <!-- Caso 2: quando il titolo stesso ha un attributo @ref -->
                <xsl:when test="@ref">
                    <a href="{@ref}" target="_blank">
                        <xsl:apply-templates/>
                    </a>
                </xsl:when>
                <!-- Caso 3: titolo senza link -->
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>

    <!-- ref templatet -->
    <xsl:template match="tei:ref">
        <a href="{@target}" target="_blank">
            <xsl:apply-templates/>
        </a>
    </xsl:template>

    <!-- Template per date -->
    <xsl:template match="tei:date">
        <span class="entity date" data-entity="date">
            <xsl:if test="@when">
                <xsl:attribute name="data-when"><xsl:value-of select="@when"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="@ref">
                <xsl:attribute name="data-ref"><xsl:value-of select="@ref"/></xsl:attribute>
                <a href="{@ref}" target="_blank"><xsl:apply-templates/></a>
            </xsl:if>
            <xsl:if test="not(@ref)">
                <xsl:apply-templates/>
            </xsl:if>
        </span>
    </xsl:template>

    <!-- Template per term - modificato per supportare @corresp al glossario -->
<xsl:template match="tei:term">
    <span class="entity term" data-entity="term">
        <xsl:if test="@type">
            <xsl:attribute name="data-type"><xsl:value-of select="@type"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="@subtype">
            <xsl:attribute name="data-subtype"><xsl:value-of select="@subtype"/></xsl:attribute>
        </xsl:if>
        
        <!-- Gestione dei termini con riferimento al glossario -->
        <xsl:choose>
            <xsl:when test="@corresp">
                <a href="#glossary-{substring-after(@corresp, '#')}" class="glossario-termine">
                    <xsl:attribute name="title">
                        <xsl:value-of select="//tei:list[@type='gloss']/tei:item[preceding-sibling::tei:label[1]/@xml:id=substring-after(current()/@corresp, '#')]"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </a>
            </xsl:when>
            <xsl:when test="@ref">
                <xsl:attribute name="data-ref"><xsl:value-of select="@ref"/></xsl:attribute>
                <a href="{@ref}" target="_blank"><xsl:apply-templates/></a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </span>
</xsl:template>

<!-- Template per measure-->
<xsl:template match="tei:measure">
    <span class="entity measure" data-entity="measure">
        <xsl:if test="@type">
            <xsl:attribute name="data-type"><xsl:value-of select="@type"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="@unit">
            <xsl:attribute name="data-unit"><xsl:value-of select="@unit"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="@quantity">
            <xsl:attribute name="data-quantity"><xsl:value-of select="@quantity"/></xsl:attribute>
        </xsl:if>
        
        <!-- Gestione delle misure con riferimento al glossario -->
        <xsl:choose>
            <xsl:when test="@corresp">
                <a href="#glossary-{substring-after(@corresp, '#')}" class="glossario-termine">
                    <xsl:attribute name="title">
                        <xsl:value-of select="//tei:list[@type='gloss']/tei:item[preceding-sibling::tei:label[1]/@xml:id=substring-after(current()/@corresp, '#')]"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </span>
</xsl:template>

    <!-- Template per quote -->
    <xsl:template match="tei:quote">
        <span class="entity quote" data-entity="quote">
            <xsl:if test="@ref">
                <xsl:attribute name="data-ref"><xsl:value-of select="@ref"/></xsl:attribute>
                <a href="{@ref}" target="_blank"><q><xsl:apply-templates/></q></a>
            </xsl:if>
            <xsl:if test="not(@ref)">
                <q><xsl:apply-templates/></q>
            </xsl:if>
        </span>
    </xsl:template>
   


    <!-- Template per theme -->
    <xsl:template match="tei:seg[@type='theme']">
        <span class="entity theme" data-entity="theme">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <!-- Catch-all per altri elementi con @ref -->
    <xsl:template match="tei:*[@ref][not(self::tei:persName or self::tei:placeName or self::tei:orgName or self::tei:date or self::tei:term or self::tei:quote)]">
        <a href="{@ref}" target="_blank"><xsl:apply-templates/></a>
    </xsl:template>

    <!-- TEMPLATES PER METADATA -->
    <xsl:template match="tei:fileDesc" mode="metadata">
        <div class="metadata-section file-desc">
            <h3>File Description</h3>
            <xsl:apply-templates select="tei:titleStmt" mode="metadata"/>
            <xsl:apply-templates select="tei:publicationStmt" mode="metadata"/>
            <xsl:apply-templates select="tei:sourceDesc" mode="metadata"/>
        </div>
    </xsl:template>

    <xsl:template match="tei:titleStmt" mode="metadata">
        <p><strong>Title:</strong> <xsl:value-of select="tei:title[@type='main']"/></p>
        <xsl:if test="tei:author">
            <p><strong>Author:</strong> <xsl:value-of select="tei:author"/></p>
        </xsl:if>
        <xsl:if test="tei:respStmt">
            <p><strong>Responsibility:</strong>
                <xsl:for-each select="tei:respStmt">
                    <xsl:value-of select="tei:resp"/> by <xsl:value-of select="tei:name"/>
                    <xsl:if test="position() != last()">; </xsl:if>
                </xsl:for-each>
            </p>
        </xsl:if>
    </xsl:template>

    <xsl:template match="tei:publicationStmt" mode="metadata">
        <xsl:if test="tei:publisher">
            <p><strong>Publisher:</strong> <xsl:value-of select="tei:publisher"/></p>
        </xsl:if>
        <xsl:if test="tei:pubPlace">
            <p><strong>Publication Place:</strong> <xsl:value-of select="tei:pubPlace"/></p>
        </xsl:if>
        <xsl:if test="tei:date">
            <p><strong>Date:</strong> <xsl:value-of select="tei:date"/></p>
        </xsl:if>
    </xsl:template>

    <xsl:template match="tei:sourceDesc" mode="metadata">
        <div class="metadata-section source-desc">
            <h3>Source Description</h3>
            <xsl:for-each select="tei:bibl">
                <p>
                    <strong>Source:</strong>
                    <xsl:if test="tei:author">
                        <xsl:value-of select="tei:author"/>
                        <xsl:if test="tei:title or tei:pubPlace or tei:publisher or tei:date">, </xsl:if>
                    </xsl:if>
                    <xsl:if test="tei:title">
                        <i><xsl:value-of select="tei:title"/></i>
                        <xsl:if test="tei:pubPlace or tei:publisher or tei:date">, </xsl:if>
                    </xsl:if>
                    <xsl:if test="tei:pubPlace">
                        <xsl:value-of select="tei:pubPlace"/>
                        <xsl:if test="tei:publisher or tei:date">, </xsl:if>
                    </xsl:if>
                    <xsl:if test="tei:publisher">
                        <xsl:value-of select="tei:publisher"/>
                        <xsl:if test="tei:date">, </xsl:if>
                    </xsl:if>
                    <xsl:if test="tei:date">
                        <xsl:value-of select="tei:date"/>
                    </xsl:if>
                </p>
            </xsl:for-each>
            <xsl:if test="tei:msDesc">
                <p><strong>Manuscript:</strong> <xsl:value-of select="tei:msDesc/tei:msIdentifier"/></p>
            </xsl:if>
        </div>
    </xsl:template>

    <xsl:template match="tei:encodingDesc" mode="metadata">
        <div class="metadata-section encoding-desc">
            <h3>Encoding Description</h3>
            <xsl:if test="tei:projectDesc">
                <p><strong>Project Description:</strong> <xsl:value-of select="tei:projectDesc"/></p>
            </xsl:if>
            <xsl:if test="tei:editorialDecl">
                <p><strong>Editorial Declaration:</strong> <xsl:value-of select="tei:editorialDecl"/></p>
            </xsl:if>
        </div>
    </xsl:template>

    <xsl:template match="tei:profileDesc" mode="metadata">
        <div class="metadata-section profile-desc">
            <h3>Profile Description</h3>
            <xsl:if test="tei:langUsage">
                <p><strong>Languages:</strong>
                    <xsl:for-each select="tei:langUsage/tei:language">
                        <xsl:value-of select="."/>
                        <xsl:if test="position() != last()">, </xsl:if>
                    </xsl:for-each>
                </p>
            </xsl:if>
        </div>
    </xsl:template>

    <xsl:template match="tei:revisionDesc" mode="metadata">
        <div class="metadata-section revision-desc">
            <h3>Revision History</h3>
            <ul>
                <xsl:for-each select="tei:change">
                    <li>
                        <xsl:if test="@when">
                            <strong><xsl:value-of select="@when"/></strong> -
                        </xsl:if>
                        <xsl:value-of select="."/>
                    </li>
                </xsl:for-each>
            </ul>
        </div>
    </xsl:template>
</xsl:stylesheet>