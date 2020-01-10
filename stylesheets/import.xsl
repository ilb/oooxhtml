<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0"
    xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dom="http://www.w3.org/2001/xml-events"
    xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0"
    xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
    xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
    xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0"
    xmlns:math="http://www.w3.org/1998/Math/MathML"
    xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0"
    xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0"
    xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
    xmlns:ooo="http://openoffice.org/2004/office"
    xmlns:oooc="http://openoffice.org/2004/calc"
    xmlns:ooow="http://openoffice.org/2004/writer"
    xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0"
    xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
    xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
    xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    xmlns:of="urn:oasis:names:tc:opendocument:xmlns:of:1.2"
    xmlns:calcext="urn:org:documentfoundation:names:experimental:calc:xmlns:calcext:1.0"
    xmlns:loext="urn:org:documentfoundation:names:experimental:office:xmlns:loext:1.0"
    xmlns:xforms="http://www.w3.org/2002/xforms"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:str="http://exslt.org/strings"
    xmlns:x="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xsd xsi str"
    version="1.0">

    <!--<xsl:include href="measure_conversion.xsl"/>-->
    <xsl:strip-space elements="*"/>
    <xsl:param name="pxmm" select="4"/>
    <!-- replace in export.xsl and import.xsl -->
    <xsl:variable name="generator_version" select="'1.4'"/>
    <xsl:variable name="is_spreadsheet" select="boolean(/x:html/x:body/x:div[contains(@class,'spreadsheet')])"/>

    <xsl:output method="xml"
                encoding="UTF-8"
                media-type="application/xhtml+xml"
                indent="no"
                omit-xml-declaration="no" />

    <!-- identity template -->
    <xsl:template match="@*|node()" mode="copy">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="copy"/>
        </xsl:copy>
    </xsl:template>

    <!-- Process the document model -->
    <xsl:template match="/">
        <xsl:apply-templates />
    </xsl:template>
    <xsl:template match="x:html">
        <office:document office:version="1.2">
            <xsl:choose>
                <xsl:when test="$is_spreadsheet">
                    <xsl:attribute name="office:mimetype">application/vnd.oasis.opendocument.spreadsheet</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="office:mimetype">application/vnd.oasis.opendocument.text</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <office:styles>
                <xsl:choose>
                    <xsl:when test="$is_spreadsheet">
                        <style:default-style style:family="table-cell">
                            <style:paragraph-properties style:tab-stop-distance="12.5mm"/>
                            <style:text-properties style:font-name="Liberation Sans" fo:language="ru" fo:country="RU" style:font-name-asian="Droid Sans Fallback" style:language-asian="zh" style:country-asian="CN" style:font-name-complex="FreeSans" style:language-complex="hi" style:country-complex="IN"/>
                            <style:table-cell-properties  fo:border="0.06pt solid #000000" fo:wrap-option="wrap"/>
                        </style:default-style>
                        <number:number-style style:name="N0">
                            <number:number number:min-integer-digits="1"/>
                        </number:number-style>
                        <style:style style:name="Default" style:family="table-cell"/>
                        <style:style style:name="Heading_20__28_user_29_" style:display-name="Heading (user)" style:family="table-cell" style:parent-style-name="Default">
                            <style:text-properties fo:color="#000000" fo:font-size="24pt" fo:font-style="normal" fo:font-weight="bold"/>
                        </style:style>
                        <style:style style:name="Heading_20_1" style:display-name="Heading 1" style:family="table-cell" style:parent-style-name="Heading_20__28_user_29_">
                            <style:text-properties fo:color="#000000" fo:font-size="18pt" fo:font-style="normal" fo:font-weight="normal"/>
                        </style:style>
                        <style:style style:name="Heading_20_2" style:display-name="Heading 2" style:family="table-cell" style:parent-style-name="Heading_20__28_user_29_">
                            <style:text-properties fo:color="#000000" fo:font-size="12pt" fo:font-style="normal" fo:font-weight="normal"/>
                        </style:style>
                        <style:style style:name="Text" style:family="table-cell" style:parent-style-name="Default"/>
                        <style:style style:name="Note" style:family="table-cell" style:parent-style-name="Text">
                            <style:table-cell-properties fo:background-color="#ffffcc" style:diagonal-bl-tr="none" style:diagonal-tl-br="none" fo:border="0.74pt solid #808080"/>
                            <style:text-properties fo:color="#333333" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="normal"/>
                        </style:style>
                        <style:style style:name="Footnote" style:family="table-cell" style:parent-style-name="Text">
                            <style:text-properties fo:color="#808080" fo:font-size="10pt" fo:font-style="italic" fo:font-weight="normal"/>
                        </style:style>
                        <style:style style:name="Hyperlink" style:family="table-cell" style:parent-style-name="Text">
                            <style:text-properties fo:color="#0000ee" fo:font-size="10pt" fo:font-style="normal" style:text-underline-style="solid" style:text-underline-width="auto" style:text-underline-color="#0000ee" fo:font-weight="normal"/>
                        </style:style>
                        <style:style style:name="Status" style:family="table-cell" style:parent-style-name="Default"/>
                        <style:style style:name="Good" style:family="table-cell" style:parent-style-name="Status">
                            <style:table-cell-properties fo:background-color="#ccffcc"/>
                            <style:text-properties fo:color="#006600" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="normal"/>
                        </style:style>
                        <style:style style:name="Neutral" style:family="table-cell" style:parent-style-name="Status">
                            <style:table-cell-properties fo:background-color="#ffffcc"/>
                            <style:text-properties fo:color="#996600" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="normal"/>
                        </style:style>
                        <style:style style:name="Bad" style:family="table-cell" style:parent-style-name="Status">
                            <style:table-cell-properties fo:background-color="#ffcccc"/>
                            <style:text-properties fo:color="#cc0000" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="normal"/>
                        </style:style>
                        <style:style style:name="Warning" style:family="table-cell" style:parent-style-name="Status">
                            <style:text-properties fo:color="#cc0000" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="normal"/>
                        </style:style>
                        <style:style style:name="Error" style:family="table-cell" style:parent-style-name="Status">
                            <style:table-cell-properties fo:background-color="#cc0000"/>
                            <style:text-properties fo:color="#ffffff" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="bold"/>
                        </style:style>
                        <style:style style:name="Accent" style:family="table-cell" style:parent-style-name="Default">
                            <style:text-properties fo:color="#000000" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="bold"/>
                        </style:style>
                        <style:style style:name="Accent_20_1" style:display-name="Accent 1" style:family="table-cell" style:parent-style-name="Accent">
                            <style:table-cell-properties fo:background-color="#000000"/>
                            <style:text-properties fo:color="#ffffff" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="normal"/>
                        </style:style>
                        <style:style style:name="Accent_20_2" style:display-name="Accent 2" style:family="table-cell" style:parent-style-name="Accent">
                            <style:table-cell-properties fo:background-color="#808080"/>
                            <style:text-properties fo:color="#ffffff" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="normal"/>
                        </style:style>
                        <style:style style:name="Accent_20_3" style:display-name="Accent 3" style:family="table-cell" style:parent-style-name="Accent">
                            <style:table-cell-properties fo:background-color="#dddddd"/>
                        </style:style>
                    </xsl:when>
                    <xsl:otherwise>
                        <style:default-style style:family="graphic">
                            <style:graphic-properties svg:stroke-color="#3465a4" draw:fill-color="#729fcf" fo:wrap-option="no-wrap" draw:shadow-offset-x="0.3cm" draw:shadow-offset-y="0.3cm" draw:start-line-spacing-horizontal="0.283cm" draw:start-line-spacing-vertical="0.283cm" draw:end-line-spacing-horizontal="0.283cm" draw:end-line-spacing-vertical="0.283cm" style:flow-with-text="false"/>
                            <style:paragraph-properties style:text-autospace="ideograph-alpha" style:line-break="strict" style:font-independent-line-spacing="false">
                                <style:tab-stops/>
                            </style:paragraph-properties>
                            <style:text-properties style:use-window-font-color="true" style:font-name="Liberation Serif" fo:font-size="12pt" fo:language="ru" fo:country="RU" style:letter-kerning="true" style:font-name-asian="Droid Sans Fallback" style:font-size-asian="10.5pt" style:language-asian="zh" style:country-asian="CN" style:font-name-complex="FreeSans" style:font-size-complex="12pt" style:language-complex="hi" style:country-complex="IN"/>
                        </style:default-style>
                        <style:default-style style:family="paragraph">
                            <style:paragraph-properties fo:orphans="2" fo:widows="2" fo:hyphenation-ladder-count="no-limit" style:text-autospace="ideograph-alpha" style:punctuation-wrap="hanging" style:line-break="strict" style:tab-stop-distance="1.251cm" style:writing-mode="page"/>
                            <style:text-properties style:use-window-font-color="true" style:font-name="Liberation Serif" fo:font-size="12pt" fo:language="ru" fo:country="RU" style:letter-kerning="true" style:font-name-asian="Droid Sans Fallback" style:font-size-asian="10.5pt" style:language-asian="zh" style:country-asian="CN" style:font-name-complex="FreeSans" style:font-size-complex="12pt" style:language-complex="hi" style:country-complex="IN" fo:hyphenate="false" fo:hyphenation-remain-char-count="2" fo:hyphenation-push-char-count="2"/>
                        </style:default-style>
                        <style:default-style style:family="table">
                            <style:table-properties table:border-model="collapsing"/>
                        </style:default-style>
                        <style:default-style style:family="table-row">
                            <style:table-row-properties fo:keep-together="auto"/>
                        </style:default-style>
                        <style:style style:name="Standard" style:family="paragraph" style:class="text"/>
                        <style:style style:name="Heading" style:family="paragraph" style:parent-style-name="Standard" style:next-style-name="Text_20_body" style:class="text">
                            <style:paragraph-properties fo:margin-top="0.423cm" fo:margin-bottom="0.212cm" loext:contextual-spacing="false" fo:keep-with-next="always"/>
                            <style:text-properties style:font-name="Liberation Sans" fo:font-family="&apos;Liberation Sans&apos;" style:font-family-generic="swiss" style:font-pitch="variable" fo:font-size="14pt" style:font-name-asian="Droid Sans Fallback" style:font-family-asian="&apos;Droid Sans Fallback&apos;" style:font-family-generic-asian="system" style:font-pitch-asian="variable" style:font-size-asian="14pt" style:font-name-complex="FreeSans" style:font-family-complex="FreeSans" style:font-family-generic-complex="system" style:font-pitch-complex="variable" style:font-size-complex="14pt"/>
                        </style:style>
                        <style:style style:name="Text_20_body" style:display-name="Text body" style:family="paragraph" style:parent-style-name="Standard" style:class="text">
                            <style:paragraph-properties fo:margin-top="0cm" fo:margin-bottom="0.247cm" loext:contextual-spacing="false" fo:line-height="115%"/>
                        </style:style>
                        <style:style style:name="List" style:family="paragraph" style:parent-style-name="Text_20_body" style:class="list">
                            <style:text-properties style:font-size-asian="12pt" style:font-name-complex="FreeSans1" style:font-family-complex="FreeSans" style:font-family-generic-complex="swiss"/>
                        </style:style>
                        <style:style style:name="Caption" style:family="paragraph" style:parent-style-name="Standard" style:class="extra">
                            <style:paragraph-properties fo:margin-top="0.212cm" fo:margin-bottom="0.212cm" loext:contextual-spacing="false" text:number-lines="false" text:line-number="0"/>
                            <style:text-properties fo:font-size="12pt" fo:font-style="italic" style:font-size-asian="12pt" style:font-style-asian="italic" style:font-name-complex="FreeSans1" style:font-family-complex="FreeSans" style:font-family-generic-complex="swiss" style:font-size-complex="12pt" style:font-style-complex="italic"/>
                        </style:style>
                        <style:style style:name="Index" style:family="paragraph" style:parent-style-name="Standard" style:class="index">
                            <style:paragraph-properties text:number-lines="false" text:line-number="0"/>
                            <style:text-properties style:font-size-asian="12pt" style:font-name-complex="FreeSans1" style:font-family-complex="FreeSans" style:font-family-generic-complex="swiss"/>
                        </style:style>
                        <style:style style:name="Graphics" style:family="graphic">
                            <style:graphic-properties text:anchor-type="paragraph" svg:x="0cm" svg:y="0cm" style:wrap="dynamic" style:number-wrapped-paragraphs="no-limit" style:wrap-contour="false" style:vertical-pos="top" style:vertical-rel="paragraph" style:horizontal-pos="center" style:horizontal-rel="paragraph" />
                        </style:style>
                        <style:style style:name="Preformatted_20_Text" style:display-name="Preformatted Text" style:family="paragraph" style:parent-style-name="Standard" style:class="html">
                            <style:paragraph-properties fo:margin-top="0cm" fo:margin-bottom="0cm" contextual-spacing="false"/>
                            <style:text-properties style:font-name="Liberation Mono" fo:font-family="'Liberation Mono'" style:font-family-generic="modern" style:font-pitch="fixed" fo:font-size="10pt" style:font-name-asian="Droid Sans Fallback2" style:font-family-asian="'Droid Sans Fallback', monospace" style:font-size-asian="10pt" style:font-name-complex="Liberation Mono" style:font-family-complex="'Liberation Mono'" style:font-family-generic-complex="modern" style:font-pitch-complex="fixed" style:font-size-complex="10pt"/>
                        </style:style>
                        <style:style style:name="Heading_20_1" style:display-name="Heading 1" style:family="paragraph" style:parent-style-name="Heading" style:next-style-name="Text_20_body" style:default-outline-level="1" style:class="text">
                            <style:paragraph-properties fo:margin-top="0.423cm" fo:margin-bottom="0.212cm" contextual-spacing="false"/>
                            <style:text-properties fo:font-size="130%" fo:font-weight="bold" style:font-size-asian="130%" style:font-weight-asian="bold" style:font-size-complex="130%" style:font-weight-complex="bold"/>
                        </style:style>
                        <style:style style:name="Heading_20_2" style:display-name="Heading 2" style:family="paragraph" style:parent-style-name="Heading" style:next-style-name="Text_20_body" style:default-outline-level="2" style:class="text">
                            <style:paragraph-properties fo:margin-top="0.353cm" fo:margin-bottom="0.212cm" contextual-spacing="false"/>
                            <style:text-properties fo:font-size="115%" fo:font-weight="bold" style:font-size-asian="115%" style:font-weight-asian="bold" style:font-size-complex="115%" style:font-weight-complex="bold"/>
                        </style:style>
                        <style:style style:name="Heading_20_3" style:display-name="Heading 3" style:family="paragraph" style:parent-style-name="Heading" style:next-style-name="Text_20_body" style:default-outline-level="3" style:class="text">
                            <style:paragraph-properties fo:margin-top="0.247cm" fo:margin-bottom="0.212cm" contextual-spacing="false"/>
                            <style:text-properties fo:font-size="101%" fo:font-weight="bold" style:font-size-asian="101%" style:font-weight-asian="bold" style:font-size-complex="101%" style:font-weight-complex="bold"/>
                        </style:style>
                        <style:style style:name="Heading_20_4" style:display-name="Heading 4" style:family="paragraph" style:parent-style-name="Heading" style:next-style-name="Text_20_body" style:default-outline-level="4" style:class="text">
                            <style:paragraph-properties fo:margin-top="0.212cm" fo:margin-bottom="0.212cm" contextual-spacing="false"/>
                            <style:text-properties fo:font-size="95%" fo:font-style="italic" fo:font-weight="bold" style:font-size-asian="95%" style:font-style-asian="italic" style:font-weight-asian="bold" style:font-size-complex="95%" style:font-style-complex="italic" style:font-weight-complex="bold"/>
                        </style:style>
                        <style:style style:name="Situation" style:family="text">
                            <style:text-properties fo:color="#ed1c24"/>
                        </style:style>
                        <style:style style:name="Motivation" style:family="text">
                            <style:text-properties fo:color="#0066b3"/>
                        </style:style>
                        <style:style style:name="Outcome" style:family="text">
                            <style:text-properties fo:color="#00a65d"/>
                        </style:style>
                        <style:style style:name="Level1" style:family="text">
                            <style:text-properties fo:color="#706e0c"/>
                        </style:style>
                        <style:style style:name="Level1" style:family="text">
                            <style:text-properties fo:color="#706e0c"/>
                        </style:style>
                        <style:style style:name="Level2" style:family="text">
                            <style:text-properties fo:color="#f58220"/>
                        </style:style>
                        <style:style style:name="Level3" style:family="text">
                            <style:text-properties fo:color="#00a65d"/>
                        </style:style>
                        <style:style style:name="Level4" style:family="text">
                            <style:text-properties fo:color="#0066b3"/>
                        </style:style>
                        <style:style style:name="Level5" style:family="text">
                            <style:text-properties fo:color="#a3238e"/>
                        </style:style>
                        <style:style style:name="Level6" style:family="text">
                            <style:text-properties fo:color="#000000"/>
                        </style:style>

                        <text:outline-style style:name="Outline">
                            <text:outline-level-style text:level="1" style:num-format="">
                                <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                                    <style:list-level-label-alignment text:label-followed-by="listtab"/>
                                </style:list-level-properties>
                            </text:outline-level-style>
                            <text:outline-level-style text:level="2" style:num-format="">
                                <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                                    <style:list-level-label-alignment text:label-followed-by="listtab"/>
                                </style:list-level-properties>
                            </text:outline-level-style>
                            <text:outline-level-style text:level="3" style:num-format="">
                                <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                                    <style:list-level-label-alignment text:label-followed-by="listtab"/>
                                </style:list-level-properties>
                            </text:outline-level-style>
                            <text:outline-level-style text:level="4" style:num-format="">
                                <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                                    <style:list-level-label-alignment text:label-followed-by="listtab"/>
                                </style:list-level-properties>
                            </text:outline-level-style>
                            <text:outline-level-style text:level="5" style:num-format="">
                                <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                                    <style:list-level-label-alignment text:label-followed-by="listtab"/>
                                </style:list-level-properties>
                            </text:outline-level-style>
                            <text:outline-level-style text:level="6" style:num-format="">
                                <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                                    <style:list-level-label-alignment text:label-followed-by="listtab"/>
                                </style:list-level-properties>
                            </text:outline-level-style>
                            <text:outline-level-style text:level="7" style:num-format="">
                                <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                                    <style:list-level-label-alignment text:label-followed-by="listtab"/>
                                </style:list-level-properties>
                            </text:outline-level-style>
                            <text:outline-level-style text:level="8" style:num-format="">
                                <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                                    <style:list-level-label-alignment text:label-followed-by="listtab"/>
                                </style:list-level-properties>
                            </text:outline-level-style>
                            <text:outline-level-style text:level="9" style:num-format="">
                                <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                                    <style:list-level-label-alignment text:label-followed-by="listtab"/>
                                </style:list-level-properties>
                            </text:outline-level-style>
                            <text:outline-level-style text:level="10" style:num-format="">
                                <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                                    <style:list-level-label-alignment text:label-followed-by="listtab"/>
                                </style:list-level-properties>
                            </text:outline-level-style>
                        </text:outline-style>
                        <text:notes-configuration text:note-class="footnote" style:num-format="1" text:start-value="0" text:footnotes-position="page" text:start-numbering-at="document"/>
                        <text:notes-configuration text:note-class="endnote" style:num-format="i" text:start-value="0"/>
                        <text:linenumbering-configuration text:number-lines="false" text:offset="0.499cm" style:num-format="1" text:number-position="left" text:increment="5"/>

                    </xsl:otherwise>
                </xsl:choose>
            </office:styles>

            <office:automatic-styles>
                <!--YYYY-MM-DD-->
                <number:date-style style:name="Ndate">
                    <number:year number:style="long" />
                    <number:text>-</number:text>
                    <number:month number:style="long" />
                    <number:text>-</number:text>
                    <number:day number:style="long" />
                </number:date-style>
                <number:number-style style:name="Nfloat">
                    <number:number number:decimal-places="2" loext:min-decimal-places="0" number:min-integer-digits="1"/>
                </number:number-style>
                <number:percentage-style style:name="Npercentage">
                    <number:number number:decimal-places="0" loext:min-decimal-places="0" number:min-integer-digits="1"/>
                    <number:text>%</number:text>
                </number:percentage-style>
                <style:style style:name="td" style:family="table-cell">
                    <style:table-cell-properties fo:border="0.06pt solid #000000" fo:wrap-option="wrap" style:vertical-align="top"/>
                </style:style>
                <style:style style:name="date" style:family="table-cell" style:data-style-name="Ndate">
                    <style:table-cell-properties fo:border="0.06pt solid #000000" fo:wrap-option="wrap" style:vertical-align="top"/>
                </style:style>
                <style:style style:name="float" style:family="table-cell" style:data-style-name="Nfloat">
                    <style:table-cell-properties fo:border="0.06pt solid #000000" fo:wrap-option="wrap" style:vertical-align="top"/>
                </style:style>
                <style:style style:name="percentage" style:family="table-cell" style:data-style-name="Npercentage">
                    <style:table-cell-properties fo:border="0.06pt solid #000000" fo:wrap-option="wrap" style:vertical-align="top"/>
                </style:style>

                <style:style style:name="sub" style:family="text">
                    <style:text-properties style:text-position="sub 58%"/>
                </style:style>
                <style:style style:name="sup" style:family="text">
                    <style:text-properties style:text-position="super 58%"/>
                </style:style>
                <style:style style:name="b" style:family="text">
                    <style:text-properties fo:font-weight="bold" style:font-weight-asian="bold" style:font-weight-complex="bold" />
                </style:style>
                <style:style style:name="i" style:family="text">
                    <style:text-properties fo:font-style="italic" style:font-style-asian="italic" style:font-style-complex="italic" />
                </style:style>
                <style:style style:name="u" style:family="text">
                    <style:text-properties style:text-underline-style="solid" style:text-underline-width="auto" style:text-underline-color="font-color" />
                </style:style>
                <style:style style:name="h1" style:family="paragraph" style:parent-style-name="Heading_20_1">
                    <!--<style:text-properties officeooo:rsid="00091fd5" officeooo:paragraph-rsid="00091fd5" />-->
                </style:style>
                <style:style style:name="h2" style:family="paragraph" style:parent-style-name="Heading_20_2">
                    <!--<style:text-properties officeooo:rsid="00091fd5" officeooo:paragraph-rsid="00091fd5" />-->
                </style:style>
                <style:style style:name="h3" style:family="paragraph" style:parent-style-name="Heading_20_3">
                    <!--<style:text-properties officeooo:rsid="00091fd5" officeooo:paragraph-rsid="00091fd5" />-->
                </style:style>
                <style:style style:name="h4" style:family="paragraph" style:parent-style-name="Heading_20_4">
                    <!--<style:text-properties officeooo:rsid="000a7363" officeooo:paragraph-rsid="000a7363" />-->
                </style:style>

                <text:list-style style:name="ol">
                    <text:list-level-style-number text:level="1" text:style-name="Numbering_20_Symbols" style:num-suffix="." style:num-format="1">
                        <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                            <style:list-level-label-alignment text:label-followed-by="listtab" text:list-tab-stop-position="1.27cm" fo:text-indent="-0.635cm" fo:margin-left="1.27cm"/>
                        </style:list-level-properties>
                    </text:list-level-style-number>
                    <text:list-level-style-number text:level="2" text:style-name="Numbering_20_Symbols" style:num-suffix="." style:num-format="1">
                        <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                            <style:list-level-label-alignment text:label-followed-by="listtab" text:list-tab-stop-position="1.905cm" fo:text-indent="-0.635cm" fo:margin-left="1.905cm"/>
                        </style:list-level-properties>
                    </text:list-level-style-number>
                    <text:list-level-style-number text:level="3" text:style-name="Numbering_20_Symbols" style:num-suffix="." style:num-format="1">
                        <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                            <style:list-level-label-alignment text:label-followed-by="listtab" text:list-tab-stop-position="2.54cm" fo:text-indent="-0.635cm" fo:margin-left="2.54cm"/>
                        </style:list-level-properties>
                    </text:list-level-style-number>
                    <text:list-level-style-number text:level="4" text:style-name="Numbering_20_Symbols" style:num-suffix="." style:num-format="1">
                        <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                            <style:list-level-label-alignment text:label-followed-by="listtab" text:list-tab-stop-position="3.175cm" fo:text-indent="-0.635cm" fo:margin-left="3.175cm"/>
                        </style:list-level-properties>
                    </text:list-level-style-number>
                    <text:list-level-style-number text:level="5" text:style-name="Numbering_20_Symbols" style:num-suffix="." style:num-format="1">
                        <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                            <style:list-level-label-alignment text:label-followed-by="listtab" text:list-tab-stop-position="3.81cm" fo:text-indent="-0.635cm" fo:margin-left="3.81cm"/>
                        </style:list-level-properties>
                    </text:list-level-style-number>
                    <text:list-level-style-number text:level="6" text:style-name="Numbering_20_Symbols" style:num-suffix="." style:num-format="1">
                        <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                            <style:list-level-label-alignment text:label-followed-by="listtab" text:list-tab-stop-position="4.445cm" fo:text-indent="-0.635cm" fo:margin-left="4.445cm"/>
                        </style:list-level-properties>
                    </text:list-level-style-number>
                    <text:list-level-style-number text:level="7" text:style-name="Numbering_20_Symbols" style:num-suffix="." style:num-format="1">
                        <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                            <style:list-level-label-alignment text:label-followed-by="listtab" text:list-tab-stop-position="5.08cm" fo:text-indent="-0.635cm" fo:margin-left="5.08cm"/>
                        </style:list-level-properties>
                    </text:list-level-style-number>
                    <text:list-level-style-number text:level="8" text:style-name="Numbering_20_Symbols" style:num-suffix="." style:num-format="1">
                        <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                            <style:list-level-label-alignment text:label-followed-by="listtab" text:list-tab-stop-position="5.715cm" fo:text-indent="-0.635cm" fo:margin-left="5.715cm"/>
                        </style:list-level-properties>
                    </text:list-level-style-number>
                    <text:list-level-style-number text:level="9" text:style-name="Numbering_20_Symbols" style:num-suffix="." style:num-format="1">
                        <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                            <style:list-level-label-alignment text:label-followed-by="listtab" text:list-tab-stop-position="6.35cm" fo:text-indent="-0.635cm" fo:margin-left="6.35cm"/>
                        </style:list-level-properties>
                    </text:list-level-style-number>
                    <text:list-level-style-number text:level="10" text:style-name="Numbering_20_Symbols" style:num-suffix="." style:num-format="1">
                        <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                            <style:list-level-label-alignment text:label-followed-by="listtab" text:list-tab-stop-position="6.985cm" fo:text-indent="-0.635cm" fo:margin-left="6.985cm"/>
                        </style:list-level-properties>
                    </text:list-level-style-number>
                </text:list-style>
                <text:list-style style:name="ul">
                    <text:list-level-style-bullet text:level="1" text:style-name="Bullet_20_Symbols" text:bullet-char="•">
                        <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                            <style:list-level-label-alignment text:label-followed-by="listtab" text:list-tab-stop-position="1.27cm" fo:text-indent="-0.635cm" fo:margin-left="1.27cm"/>
                        </style:list-level-properties>
                    </text:list-level-style-bullet>
                    <text:list-level-style-bullet text:level="2" text:style-name="Bullet_20_Symbols" text:bullet-char="◦">
                        <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                            <style:list-level-label-alignment text:label-followed-by="listtab" text:list-tab-stop-position="1.905cm" fo:text-indent="-0.635cm" fo:margin-left="1.905cm"/>
                        </style:list-level-properties>
                    </text:list-level-style-bullet>
                    <text:list-level-style-bullet text:level="3" text:style-name="Bullet_20_Symbols" text:bullet-char="▪">
                        <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                            <style:list-level-label-alignment text:label-followed-by="listtab" text:list-tab-stop-position="2.54cm" fo:text-indent="-0.635cm" fo:margin-left="2.54cm"/>
                        </style:list-level-properties>
                    </text:list-level-style-bullet>
                    <text:list-level-style-bullet text:level="4" text:style-name="Bullet_20_Symbols" text:bullet-char="•">
                        <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                            <style:list-level-label-alignment text:label-followed-by="listtab" text:list-tab-stop-position="3.175cm" fo:text-indent="-0.635cm" fo:margin-left="3.175cm"/>
                        </style:list-level-properties>
                    </text:list-level-style-bullet>
                    <text:list-level-style-bullet text:level="5" text:style-name="Bullet_20_Symbols" text:bullet-char="◦">
                        <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                            <style:list-level-label-alignment text:label-followed-by="listtab" text:list-tab-stop-position="3.81cm" fo:text-indent="-0.635cm" fo:margin-left="3.81cm"/>
                        </style:list-level-properties>
                    </text:list-level-style-bullet>
                    <text:list-level-style-bullet text:level="6" text:style-name="Bullet_20_Symbols" text:bullet-char="▪">
                        <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                            <style:list-level-label-alignment text:label-followed-by="listtab" text:list-tab-stop-position="4.445cm" fo:text-indent="-0.635cm" fo:margin-left="4.445cm"/>
                        </style:list-level-properties>
                    </text:list-level-style-bullet>
                    <text:list-level-style-bullet text:level="7" text:style-name="Bullet_20_Symbols" text:bullet-char="•">
                        <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                            <style:list-level-label-alignment text:label-followed-by="listtab" text:list-tab-stop-position="5.08cm" fo:text-indent="-0.635cm" fo:margin-left="5.08cm"/>
                        </style:list-level-properties>
                    </text:list-level-style-bullet>
                    <text:list-level-style-bullet text:level="8" text:style-name="Bullet_20_Symbols" text:bullet-char="◦">
                        <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                            <style:list-level-label-alignment text:label-followed-by="listtab" text:list-tab-stop-position="5.715cm" fo:text-indent="-0.635cm" fo:margin-left="5.715cm"/>
                        </style:list-level-properties>
                    </text:list-level-style-bullet>
                    <text:list-level-style-bullet text:level="9" text:style-name="Bullet_20_Symbols" text:bullet-char="▪">
                        <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                            <style:list-level-label-alignment text:label-followed-by="listtab" text:list-tab-stop-position="6.35cm" fo:text-indent="-0.635cm" fo:margin-left="6.35cm"/>
                        </style:list-level-properties>
                    </text:list-level-style-bullet>
                    <text:list-level-style-bullet text:level="10" text:style-name="Bullet_20_Symbols" text:bullet-char="•">
                        <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
                            <style:list-level-label-alignment text:label-followed-by="listtab" text:list-tab-stop-position="6.985cm" fo:text-indent="-0.635cm" fo:margin-left="6.985cm"/>
                        </style:list-level-properties>
                    </text:list-level-style-bullet>
                </text:list-style>

                <style:style style:name="img" style:family="graphic" style:parent-style-name="Graphics">
                    <style:graphic-properties style:mirror="none" fo:clip="rect(0cm, 0cm, 0cm, 0cm)" draw:luminance="0%" draw:contrast="0%" draw:red="0%" draw:green="0%" draw:blue="0%" draw:gamma="100%" draw:color-inversion="false" draw:image-opacity="100%" draw:color-mode="standard" />
                </style:style>
                <xsl:choose>
                    <xsl:when test="contains(/x:html/x:head/x:style,'@page')">
                        <xsl:variable name="pagestyle" select="normalize-space(substring-before(substring-after(substring-after(/x:html/x:head/x:style,'@page'),'{'),'}'))"/>
                        <style:page-layout style:name="pm1">
                            <style:page-layout-properties>
                                <xsl:for-each select="str:tokenize($pagestyle,';')">
                                    <xsl:variable name="attr" select="normalize-space(substring-before(.,':'))"/>
                                    <xsl:variable name="value" select="normalize-space(substring-after(.,':'))"/>
                                    <xsl:choose>
                                        <xsl:when test="$attr='size'">
                                            <xsl:choose>
                                                <xsl:when test="$value='portrait' or $value='landscape'">
                                                    <xsl:attribute name="style:print-orientation">
                                                        <xsl:value-of select="$value"/>
                                                    </xsl:attribute>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:variable name="width" select="normalize-space(substring-before($value,' '))"/>
                                                    <xsl:variable name="height" select="normalize-space(substring-after($value,' '))"/>

                                                    <xsl:attribute name="fo:page-width">
                                                        <xsl:value-of select="$width"/>
                                                    </xsl:attribute>
                                                    <xsl:attribute name="fo:page-height">
                                                        <xsl:value-of select="$height"/>
                                                    </xsl:attribute>
                                                    <!--                                        <xsl:if test="number($width) > number($height)">
                                                        <xsl:attribute name="style:print-orientation">landscape</xsl:attribute>
                                                    </xsl:if>
                                                    <xsl:if test="number($width) &lt;= number($height)">
                                                        <xsl:attribute name="style:print-orientation">portrait</xsl:attribute>
                                                    </xsl:if>-->
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:when test="$attr='margin-top' or $attr='margin-right' or $attr='margin-bottom' or $attr='margin-left'">
                                            <xsl:attribute name="fo:{$attr}">
                                                <xsl:value-of select="$value"/>
                                            </xsl:attribute>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:for-each>
                            </style:page-layout-properties>
                            <style:header-style />
                            <style:footer-style />
                        </style:page-layout>
                    </xsl:when>
                    <xsl:otherwise>
                        <style:page-layout style:name="pm1">
                            <style:page-layout-properties fo:page-width="21cm" fo:page-height="29.7cm" style:num-format="1" style:print-orientation="portrait" fo:margin-top="2cm" fo:margin-bottom="2cm" fo:margin-left="2cm" fo:margin-right="2cm" style:writing-mode="lr-tb" style:footnote-max-height="0cm"/>
                            <style:header-style />
                            <style:footer-style />
                        </style:page-layout>>
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:apply-templates select="//@style" mode="convertstyle"/>
            </office:automatic-styles>
            <office:master-styles>
                <style:master-page style:name="Standard" style:page-layout-name="pm1" />
            </office:master-styles>
            <xsl:apply-templates />
        </office:document>
    </xsl:template>
    <xsl:template match="@style" mode="convertstyle">
        <xsl:variable name="htmlnodename" select="local-name(..)"/>
        <xsl:variable name="family">
            <xsl:choose>
                <xsl:when test="$htmlnodename='table'">table</xsl:when>
                <xsl:when test="$htmlnodename='tr'">table-row</xsl:when>
                <xsl:when test="$htmlnodename='td' or $htmlnodename='th'">table-cell</xsl:when>
                <xsl:when test="$htmlnodename='col'">table-column</xsl:when>
                <xsl:when test="$htmlnodename='p'">paragraph</xsl:when>
                <xsl:when test="$htmlnodename='span'">text</xsl:when>
            </xsl:choose>
        </xsl:variable>

        <!-- преобразуем css стили в стили odf -->
        <style:style style:name="{generate-id(.)}" style:family="{$family}">
            <style:text-properties >
                <xsl:for-each select="str:tokenize(.,';')">
                    <xsl:variable name="attr" select="normalize-space(substring-before(.,':'))"/>
                    <xsl:variable name="value" select="normalize-space(substring-after(.,':'))"/>
                    <xsl:choose>
                        <xsl:when test="$attr='font-weight'">
                            <xsl:attribute name="fo:font-weight">
                                <xsl:value-of select="$value"/>
                            </xsl:attribute>
                            <xsl:attribute name="style:font-weight-asian">
                                <xsl:value-of select="$value"/>
                            </xsl:attribute>
                            <xsl:attribute name="style:font-weight-complex">
                                <xsl:value-of select="$value"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:when test="$attr='font-style'">
                            <xsl:attribute name="fo:font-style">
                                <xsl:value-of select="$value"/>
                            </xsl:attribute>
                            <xsl:attribute name="style:font-style-asian">
                                <xsl:value-of select="$value"/>
                            </xsl:attribute>
                            <xsl:attribute name="style:font-style-complex">
                                <xsl:value-of select="$value"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:when test="$attr='color'">
                            <xsl:attribute name="fo:color">
                                <xsl:value-of select="$value"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:when test="$attr='background-color'">
                            <xsl:attribute name="fo:background-color">
                                <xsl:value-of select="$value"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:when test="$attr='font-size'">
                            <xsl:attribute name="fo:font-size">
                                <xsl:value-of select="$value"/>
                            </xsl:attribute>
                            <xsl:attribute name="style:font-size-asian">
                                <xsl:value-of select="$value"/>
                            </xsl:attribute>
                            <xsl:attribute name="style:font-size-complex">
                                <xsl:value-of select="$value"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:when test="$attr='text-decoration' and $value='line-through'">
                            <xsl:attribute name="style:text-line-through-style">solid</xsl:attribute>
                            <xsl:attribute name="style:text-line-through-type">single</xsl:attribute>
                        </xsl:when>

                        <!--                        <xsl:when test="$attr='hyphens' and $value='auto'">
                            <xsl:attribute name="fo:hyphenate">true</xsl:attribute>
                        </xsl:when>-->
                    </xsl:choose>
                </xsl:for-each>
            </style:text-properties>
            <style:paragraph-properties>
                <xsl:for-each select="str:tokenize(.,';')">
                    <xsl:variable name="attr" select="substring-before(.,':')"/>
                    <xsl:variable name="value" select="normalize-space(substring-after(.,':'))"/>
                    <xsl:choose>
                        <xsl:when test="$attr='text-align'">
                            <xsl:attribute name="fo:text-align">
                                <xsl:if test="$value='center'">center</xsl:if>
                                <xsl:if test="$value='left'">start</xsl:if>
                                <xsl:if test="$value='right'">end</xsl:if>
                            </xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </style:paragraph-properties>
            <xsl:if test="$htmlnodename='tr'">
                <style:table-row-properties fo:break-before="auto" style:use-optimal-row-height="true">
                    <xsl:for-each select="str:tokenize(.,';')">
                        <xsl:variable name="attr" select="substring-before(.,':')"/>
                        <xsl:variable name="value" select="normalize-space(substring-after(.,':'))"/>
                        <xsl:choose>
                            <xsl:when test="$attr='height'">
                                <xsl:attribute name="style:row-height">
                                    <xsl:value-of select="$value"/>
                                </xsl:attribute>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </style:table-row-properties>
            </xsl:if>
            <xsl:if test="$htmlnodename='col'">
                <style:table-column-properties fo:break-before="auto">
                    <xsl:for-each select="str:tokenize(.,';')">
                        <xsl:variable name="attr" select="substring-before(.,':')"/>
                        <xsl:variable name="value" select="normalize-space(substring-after(.,':'))"/>
                        <xsl:choose>
                            <xsl:when test="$attr='min-width' or $attr='width'">
                                <xsl:attribute name="style:column-width">
                                    <xsl:value-of select="$value"/>
                                </xsl:attribute>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </style:table-column-properties>
            </xsl:if>
            <xsl:if test="$htmlnodename='td'">
                <style:table-cell-properties fo:border="0.06pt solid #000000" fo:wrap-option="wrap" style:vertical-align="top">
                    <xsl:for-each select="str:tokenize(.,';')">
                        <xsl:variable name="attr" select="substring-before(.,':')"/>
                        <xsl:variable name="value" select="normalize-space(substring-after(.,':'))"/>
                        <xsl:choose>
                            <xsl:when test="$attr='background-color'">
                                <xsl:attribute name="fo:background-color">
                                    <xsl:value-of select="$value"/>
                                </xsl:attribute>
                            </xsl:when>
                            <!--                            <xsl:when test="$attr='word-wrap' and $value='break-word'">
                                <xsl:attribute name="fo:wrap-option">wrap</xsl:attribute>
                            </xsl:when>-->
                        </xsl:choose>
                    </xsl:for-each>
                </style:table-cell-properties>
            </xsl:if>


        </style:style>
    </xsl:template>
    <xsl:template match="@style">
        <xsl:choose>
            <xsl:when test="local-name(..)='table' or local-name(..)='tr' or local-name(..)='td' or local-name(..)='col'">
                <xsl:attribute name="table:style-name">
                    <xsl:value-of select="generate-id(.)"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="local-name(..)='img'">
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="text:style-name">
                    <xsl:value-of select="generate-id(.)"/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="x:head">
        <office:meta>
            <xsl:apply-templates />
        </office:meta>
    </xsl:template>
    <xsl:template match="x:title">
        <dc:title>
            <xsl:apply-templates />
        </dc:title>
    </xsl:template>
    <xsl:template match="x:html" mode="checkversion">
        <xsl:variable name="generator" select="x:head/x:meta[@name='generator']/@content"/>
        <xsl:choose>
            <xsl:when test="normalize-space(substring-before($generator,'/'))='oooxhtml' and normalize-space(substring-after($generator,'/'))>$generator_version">false</xsl:when>
            <xsl:otherwise>true</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="x:meta[@name]">
        <xsl:choose>
            <xsl:when test="@name='generator'">
            </xsl:when>
            <xsl:when test="@name='description'">
                <dc:description>
                    <xsl:value-of select="@content"/>
                </dc:description>
            </xsl:when>
            <xsl:when test="@name='keywords'">
                <meta:keyword>
                    <xsl:value-of select="@content"/>
                </meta:keyword>
            </xsl:when>
            <xsl:when test="@name='subject'">
                <dc:subject>
                    <xsl:value-of select="@content"/>
                </dc:subject>
            </xsl:when>
            <xsl:otherwise>
                <meta:user-defined meta:name="{@name}">
                    <xsl:value-of select="@content"/>
                </meta:user-defined>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="/processing-instruction('xml-stylesheet')">
                <meta:user-defined meta:name="xml-stylesheet">
                    <xsl:value-of select="/processing-instruction('xml-stylesheet')"/>
                </meta:user-defined>
        </xsl:if>
    </xsl:template>
    <!--    <xsl:template match="x:script">
        <meta:user-defined meta:name="script">
            <xsl:value-of select="@src"/>
        </meta:user-defined>
    </xsl:template>-->
    <!--    <xsl:template match="office:automatic-styles">
        <xsl:copy>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@*|node()" mode="copy">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="copy"/>
        </xsl:copy>
    </xsl:template>-->
    <!-- для импорта несовместимых документов? -->
    <xsl:template match="x:body[not(x:div) ]">
        <office:body>
            <office:text>
                <xsl:apply-templates />
            </office:text>
        </office:body>
    </xsl:template>
    <xsl:template name="message_version">
        <text:p>
            Внимание! Установлена несовместимая версия фильтров XML, требуется обновление.
            <text:a xlink:href="https://docs.ilb.ru/oooxhtml/readme.xhtml#install" xlink:type="simple">Инструкции по обновлению</text:a>
        </text:p>

    </xsl:template>
    <xsl:template match="x:body">
        <office:body>
            <xsl:variable name="checkversion">
                <xsl:apply-templates select="/x:html" mode="checkversion"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$checkversion='false'">
                    <xsl:choose>
                        <xsl:when test="$is_spreadsheet">
                            <office:spreadsheet>
                                <table:table table:name="ОШИБКА">
                                    <table:table-column table:style-name="co1" table:default-cell-style-name="td"/>
                                    <table:table-row table:style-name="ro1">
                                        <table:table-cell office:value-type="string" calcext:value-type="string">
                                            <xsl:call-template name="message_version"/>
                                        </table:table-cell>
                                    </table:table-row>
                                </table:table>
                            </office:spreadsheet>
                        </xsl:when>
                        <xsl:otherwise>
                            <office:text>
                                <xsl:call-template name="message_version"/>
                            </office:text>
                        </xsl:otherwise>
                    </xsl:choose>

                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates />
                </xsl:otherwise>
            </xsl:choose>

        </office:body>
    </xsl:template>
    <xsl:template match="x:span[contains(@class,'annotation')]">
        <office:annotation>
            <dc:creator>
                <xsl:value-of select="x:span/x:span[@class='creator']"/>
            </dc:creator>
            <dc:date>
                <xsl:value-of select="x:span/x:span[@class='creator']/@title"/>
                <!--<xsl:value-of select="x:span/x:span[@class='date']"/>-->
            </dc:date>
            <text:p>
                <xsl:for-each select="x:span/x:span[@class='content']">
                    <xsl:apply-templates/>
                </xsl:for-each>
            </text:p>
        </office:annotation>
    </xsl:template>

    <xsl:template match="x:div[contains(@class,'spreadsheet')]">
        <office:spreadsheet>
            <table:calculation-settings table:case-sensitive="false" table:automatic-find-labels="false" table:use-regular-expressions="false" table:use-wildcards="true">
                <table:iteration table:maximum-difference="0.0001"/>
            </table:calculation-settings>
            <xsl:apply-templates />
            <table:named-expressions/>
        </office:spreadsheet>
    </xsl:template>
    <xsl:template match="x:div[contains(@class,'text')]">
        <office:text>
            <xsl:apply-templates />
        </office:text>
    </xsl:template>

    <!-- TODO: что делать с div, чтобы они сохранялись? -->
    <xsl:template match="x:div">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="x:table">
        <table:table table:name="{@summary}">
            <xsl:apply-templates select="@*"/>
            <!-- если в таблице нет col, создадим колонки по счислу колонок в первой строке -->
            <xsl:if test="not(x:col) and not(x:colgroup)">
                <table:table-column table:number-columns-repeated="{count(x:tr[1]/x:td)}"/>
            </xsl:if>
            <xsl:apply-templates select="*"/>
        </table:table>
    </xsl:template>
    <xsl:template match="x:colgroup">
        <xsl:apply-templates />
    </xsl:template>
    <xsl:template match="x:col">
        <table:table-column>
            <xsl:apply-templates select="@*"/>
            <xsl:if test="@title='collapse'">
                <xsl:attribute name="table:visibility">collapse</xsl:attribute>
            </xsl:if>
        </table:table-column>
    </xsl:template>
    <xsl:template match="@span">
        <xsl:attribute name="table:number-columns-repeated">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="x:tr">
        <table:table-row>
            <xsl:apply-templates select="*|@*"/>
        </table:table-row>
    </xsl:template>
    <!-- cell begin -->
    <xsl:template match="x:td">
        <xsl:if test="@title and substring(@title,1,3)!='of:'">
            <table:covered-table-cell table:number-columns-repeated="{@title}"/>
        </xsl:if>
        <table:table-cell>
            <xsl:if test="not(@style) and not(@class)">
                <xsl:attribute name="table:style-name">td</xsl:attribute>
            </xsl:if>
            <xsl:if test="@title and substring(@title,1,3)='of:'">
                <xsl:attribute name="table:formula">
                    <xsl:value-of select="@title"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="*|@*"/>
        </table:table-cell>
    </xsl:template>
    <xsl:template match="@class">
        <xsl:choose>
            <xsl:when test="local-name(..)='body' or local-name(..)='div'">
                <!-- skip -->
            </xsl:when>
            <xsl:when test="local-name(..)='table' or local-name(..)='tr' or local-name(..)='td'">
                <xsl:choose>
                    <xsl:when test=".='date'">
                        <xsl:attribute name="office:value-type">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                        <xsl:attribute name="office:date-value">
                            <xsl:value-of select="../x:p/text()"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test=".='float'">
                        <xsl:attribute name="office:value-type">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                        <xsl:attribute name="office:value">
                            <xsl:value-of select="translate(translate(../x:p/text(),',','.'),'&#160; ','')"/>
                        </xsl:attribute>
                        <xsl:attribute name="calcext:value-type">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test=".='percentage'">
                        <xsl:attribute name="office:value-type">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                        <xsl:attribute name="office:value">
                            <xsl:value-of select="translate(translate(../x:p/text(),',','.'),'&#160; %','') div 100"/>
                        </xsl:attribute>
                        <xsl:attribute name="calcext:value-type">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:attribute name="table:style-name">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="text:style-name">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@colspan">
        <xsl:attribute name="table:number-columns-spanned">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="@rowspan">
        <xsl:attribute name="table:number-rows-spanned">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <!-- cell end -->

    <xsl:template match="x:p">
        <text:p>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates />
        </text:p>
    </xsl:template>

    <xsl:template match="x:span">
        <text:span>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates />
        </text:span>
    </xsl:template>
    <xsl:template match="x:a">
        <xsl:choose>
            <xsl:when test="@class='anchor'">
                <xsl:apply-templates />
            </xsl:when>
            <xsl:otherwise>
                <text:a xlink:href="{@href}" xlink:type="simple">
                    <xsl:apply-templates />
                </text:a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="x:br">
        <text:line-break/>
    </xsl:template>
    <xsl:template match="x:sup">
        <text:span text:style-name="sup">
            <xsl:apply-templates />
        </text:span>
    </xsl:template>
    <xsl:template match="x:sub">
        <text:span text:style-name="sub">
            <xsl:apply-templates />
        </text:span>
    </xsl:template>

    <xsl:template match="x:b">
        <text:span text:style-name="b">
            <xsl:apply-templates />
        </text:span>
    </xsl:template>
    <xsl:template match="x:i">
        <text:span text:style-name="i">
            <xsl:apply-templates />
        </text:span>
    </xsl:template>
    <xsl:template match="x:u">
        <text:span text:style-name="u">
            <xsl:apply-templates />
        </text:span>
    </xsl:template>
    <xsl:template match="x:pre">
        <text:p text:style-name="Preformatted_20_Text">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates />
        </text:p>
    </xsl:template>
    <xsl:template match="x:h1|x:h2|x:h3|x:h4">
        <text:h text:style-name="{local-name(.)}" text:outline-level="{substring(local-name(.),2,1)}">
            <xsl:choose>
                <xsl:when test="@id">
                    <text:bookmark text:name="{@id}"/>
                </xsl:when>
                <xsl:when test="a[@id]">
                    <text:bookmark text:name="{a/@id}"/>
                </xsl:when>
                <xsl:when test="a[@name]">
                    <text:bookmark text:name="{a/@name}"/>
                </xsl:when>

            </xsl:choose>

            <xsl:apply-templates />
        </text:h>
    </xsl:template>

    <xsl:template match="x:ul">
        <text:list text:style-name="ul">
            <xsl:apply-templates />
        </text:list>
    </xsl:template>

    <xsl:template match="x:ol">
        <text:list text:style-name="ol">
            <xsl:apply-templates />
        </text:list>
    </xsl:template>
    <xsl:template match="x:li">
        <text:list-item>
            <xsl:apply-templates />
        </text:list-item>
    </xsl:template>

    <xsl:template match="math:math">
        <draw:frame draw:style-name="fr1" draw:name="{@alttext}" text:anchor-type="as-char" svg:width="{@width}" svg:height="{@height}" draw:z-index="1">
            <draw:object>
                <xsl:apply-templates select="." mode="copy"/>
            </draw:object>
        </draw:frame>
    </xsl:template>

    <xsl:template match="x:img">
        <draw:frame draw:style-name="img" draw:name="{@alt}" text:anchor-type="paragraph" draw:z-index="0">
            <xsl:for-each select="str:tokenize(@style,';')">
                <xsl:variable name="attr" select="normalize-space(substring-before(.,':'))"/>
                <xsl:variable name="value" select="normalize-space(substring-after(.,':'))"/>
                <xsl:choose>
                    <xsl:when test="$attr='left'">
                        <xsl:attribute name="svg:x">
                            <xsl:value-of select="$value"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$attr='top'">
                        <xsl:attribute name="svg:y">
                            <xsl:value-of select="$value"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$attr='width'">
                        <xsl:attribute name="svg:width">
                            <xsl:value-of select="$value"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$attr='height'">
                        <xsl:attribute name="svg:height">
                            <xsl:value-of select="$value"/>
                        </xsl:attribute>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
            <draw:image draw:filter-name="&lt;Все форматы&gt;" >
                <xsl:choose>
                    <xsl:when test="substring(@src,1,5)='data:'">
                        <xsl:attribute name="loext:mime-type">
                            <xsl:value-of select="substring-before(substring(@src,6),';')"/>
                        </xsl:attribute>
                        <office:binary-data>
                            <xsl:value-of select="substring-after(@src,';base64,')"/>
                        </office:binary-data>
                    </xsl:when>
                    <xsl:when test="@src">
                        <xsl:attribute name="xlink:href">
                            <xsl:value-of select="@src"/>
                        </xsl:attribute>
                        <xsl:attribute name="xlink:type">
                            simple
                        </xsl:attribute>
                        <xsl:attribute name="xlink:show">
                            embed
                        </xsl:attribute>
                        <xsl:attribute name="xlink:actuate">
                            onLoad
                        </xsl:attribute>
                    </xsl:when>
                </xsl:choose>
            </draw:image>
        </draw:frame>
    </xsl:template>

    <xsl:template match="* | @*" />

</xsl:stylesheet>
