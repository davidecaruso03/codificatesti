<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei">

    <xsl:output method="html" encoding="UTF-8" indent="yes" doctype-public="-//W3C//DTD HTML 5//EN" doctype-system="about:legacy-compat"/>

    <xsl:key name="facsimile-by-url" match="tei:surface" use="tei:graphic/@url"/>

    <!-- TEMPLATE PRINCIPALE (ROOT) -->
    <xsl:template match="/">
        <html lang="it">
            <head>
                <meta charset="UTF-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                <title>
                    <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/title"/>
                </title>
                <link rel="stylesheet" type="text/css" href="stile.css"/>

                <!-- INCLUSIONE DI JQUERY E DELLO SCRIPT PERSONALIZZATO -->
                <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
                <script src="script.js" defer="defer"></script>
            </head>
            <body>
                <header>
                    <h1>
                        <xsl:value-of select="//tei:monogr/tei:title"/>
                    </h1>
                    <p class="resp-stmt">Codifica TEI realizzata da: 
                        <xsl:value-of select="//tei:respStmt/tei:name[@xml:id='DCaruso']"/>
                    </p>
                </header>

                <div class="container">
                    <aside class="metadata-panel">
                        <section class="metadata-section">
                            <h2>Note</h2>
                            <xsl:apply-templates select="//tei:notesStmt/tei:note"/>
                        </section>

                        <section class="metadata-section">
                            <h2>Fonte</h2>
                            <dl class="source-details">
                                <dt>Lingua:</dt>
                                <dd>
                                    <xsl:value-of select="//tei:monogr/tei:textLang"/>
                                </dd>
                                <dt>Fondata da:</dt>
                                <dd>
                                    <xsl:for-each select="//tei:monogr/tei:respStmt/tei:name">
                                        <xsl:value-of select="."/>
                                        <xsl:if test="position() != last()">, </xsl:if>
                                    </xsl:for-each>
                                </dd>
                                <dt>Luogo:</dt>
                                <dd>
                                    <xsl:value-of select="//tei:monogr/tei:imprint/tei:pubPlace"/>
                                </dd>
                                <dt>Editore:</dt>
                                <dd>
                                    <xsl:value-of select="//tei:monogr/tei:imprint/tei:publisher"/>
                                </dd>
                                <dt>Data:</dt>
                                <dd>
                                    <xsl:value-of select="//tei:monogr/tei:imprint/tei:date"/>
                                </dd>
                                <dt>Volume:</dt>
                                <dd>
                                    <xsl:value-of select="//tei:monogr/tei:biblScope[@unit='volume']"/>
                                </dd>
                                <dt>Fascicolo:</dt>
                                <dd>
                                    <xsl:value-of select="//tei:monogr/tei:biblScope[@unit='article']"/>
                                </dd>
                                <dt>Pagine:</dt>
                                <dd>
                                    <xsl:value-of select="//tei:monogr/tei:biblScope[@unit='page']"/>
                                </dd>
                            </dl>
                        </section>

                        <section class="metadata-section">
                            <h2>Codifica</h2>
                            <xsl:apply-templates select="//tei:encodingDesc/tei:projectDesc/tei:p"/>
                        </section>

                        <!-- BOTTONI INTERATTIVI PER LA LEGENDA -->
                        <nav id="interactive-controls">
                            <h3>Evidenzia Fenomeni</h3>
                            <div id="phenomenon-buttons">
                                <button class="phenomenon-btn" data-entity-class="person">Persone</button>
                                <button class="phenomenon-btn" data-entity-class="place">Luoghi</button>
                                <button class="phenomenon-btn" data-entity-class="role">Ruoli</button>
                                <button class="phenomenon-btn" data-entity-class="organization">Organizzazioni</button>
                                <button class="phenomenon-btn" data-entity-class="ship">Navi</button>
                                <button class="phenomenon-btn" data-entity-class="date">Date</button>
                            </div>
                            <h3>Altre Opzioni</h3>
                            <button id="toggle-abbr" class="toggle-btn">Mostra Abbreviazioni</button>
                        </nav>
                    </aside>

                    <main class="content-panel">
                        <div class="column facsimile-column">
                            <h2>Facsimile</h2>
                            <xsl:apply-templates select="//tei:facsimile/tei:surface"/>
                        </div>
                        <div class="column transcription-column">
                            <h2>Trascrizione</h2>
                            <xsl:apply-templates select="/tei:TEI/tei:text/tei:body/tei:div[@type='journal']/*"/>
                        </div>
                    </main>
                </div>

                <footer>
                    <p>
                        <xsl:value-of select="//tei:publicationStmt/tei:date"/>
,                        <xsl:value-of select="//tei:publicationStmt/tei:publisher"/>
                    </p>
                </footer>
            </body>
        </html>
    </xsl:template>

    <!-- TEMPLATES PER FACSIMILE E ZONE -->
    <xsl:template match="tei:surface">
        <figure class="facsimile-image">
            <img src="immagini/{tei:graphic/@url}" alt="Facsimile pagina {@n}" usemap="#facsimile-map-{generate-id()}"/>
            <map name="facsimile-map-{generate-id()}">
                <xsl:apply-templates select="key('facsimile-by-url', tei:graphic/@url)/tei:zone"/>
            </map>
        </figure>
        <br/>

    </xsl:template>

    <xsl:template match="tei:zone">
        <!-- L'attributo href punta all'ID della riga di testo corrispondente.
         Es. href="#riga1_castellammare" -->
        <area shape="rect" href="#{@xml:id}" alt="Zona {@xml:id}">
            <!-- Gli attributi coords e data-coords contengono le coordinate per il browser e per JS -->
            <xsl:attribute name="coords">
                <xsl:value-of select="concat(@ulx, ',', @uly, ',', @lrx, ',', @lry)"/>
            </xsl:attribute>
            <xsl:attribute name="data-coords">
                <xsl:value-of select="concat(@ulx, ',', @uly, ',', @lrx, ',', @lry)"/>
            </xsl:attribute>
        </area>
    </xsl:template>

    <!-- TEMPLATES PER STRUTTURA DEL TESTO -->
    <xsl:template match="tei:div[@type='article']">
        <article class="text-article" id="article-{@n}">
            <xsl:apply-templates/>
        </article>
    </xsl:template>

    <xsl:template match="tei:div[@type='sezione_bibliografie' or @type='section']">
        <section class="text-section">
            <xsl:apply-templates/>
        </section>
    </xsl:template>

    <xsl:template match="tei:div[starts-with(@type, 'bibliografia')]">
        <div class="bibliography-entry">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:head">
        <h3>
            <xsl:apply-templates/>
        </h3>
    </xsl:template>

    <xsl:template match="tei:p | tei:note">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!-- TEMPLATE PER I LINE BREAK -->
    <xsl:template match="tei:lb[@facs]">
        <!-- Rimuoviamo il carattere '#' dall'attributo facs per creare un ID HTML valido.
         Se facs è "#riga1_castellammare", l'id diventerà "riga1_castellammare". -->
        <span class="line-anchor" id="{substring-after(@facs, '#')}"></span>

        <!-- Aggiunge un <br> a meno che non sia specificato 'break="no"' -->
        <xsl:if test="not(@break='no')">
            <br/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:lb[not(@facs)]">
        <br/>
    </xsl:template>

    <!-- TEMPLATE PER LA GESTIONE DELLE ENTITÀ -->
    <xsl:template match="tei:persName | tei:name[not(@type)]">
        <span class="entity person">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:placeName | tei:geogName">
        <span class="entity place">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:orgName">
        <span class="entity organization">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:roleName">
        <span class="entity role">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:name[@type='ship']">
        <span class="entity ship">
            <i>
                <xsl:apply-templates/>
            </i>
        </span>
    </xsl:template>

    <!-- TEMPLATE per <date> -->
    <xsl:template match="tei:date">
        <span class="entity date">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- ALTRI TEMPLATES -->
    <xsl:template match="tei:title">
        <i>
            <xsl:apply-templates/>
        </i>
    </xsl:template>
    <xsl:template match="tei:term">
        <em>
            <xsl:apply-templates/>
        </em>
    </xsl:template>
    <xsl:template match="tei:quote">
        <blockquote>
            <xsl:apply-templates/>
        </blockquote>
    </xsl:template>
    <xsl:template match="tei:foreign">
        <i lang="{@xml:lang}">
            <xsl:apply-templates/>
        </i>
    </xsl:template>

    <xsl:template match="tei:choice[tei:abbr and tei:expan]">
        <span class="abbreviation">
            <span class="abbr" style="display:none;">
                <xsl:apply-templates select="tei:abbr"/>
            </span>
            <span class="expan">
                <xsl:apply-templates select="tei:expan"/>
            </span>
        </span>
    </xsl:template>

    <xsl:template match="text()">
        <xsl:value-of select="."/>
    </xsl:template>

</xsl:stylesheet>