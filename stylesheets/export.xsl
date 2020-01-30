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
    xmlns:loext="urn:org:documentfoundation:names:experimental:office:xmlns:loext:1.0"
    xmlns:xforms="http://www.w3.org/2002/xforms"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:exsl="http://exslt.org/common"
    extension-element-prefixes="exsl"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="chart config dc dom dr3d draw fo form math meta number office ooo oooc ooow script style svg table text xforms xlink xsd xsi xforms xsd xsi exsl loext"
    version="1.0">

    <!--<xsl:include href="measure_conversion.xsl"/>-->
    <!-- съедает пробелы -->
    <!--<xsl:strip-space elements="*"/>-->
    <xsl:param name="pxmm" select="4"/>
    <xsl:output method="xml"
                encoding="UTF-8"
                media-type="application/xhtml+xml"
                indent="yes"
                omit-xml-declaration="no"
                doctype-public="-//W3C//DTD XHTML 1.1 plus MathML 2.0 plus SVG 1.1//EN"
                doctype-system="http://www.w3.org/2002/04/xhtml-math-svg/xhtml-math-svg-flat.dtd" />
    <!--
                doctype-public="-//W3C//DTD XHTML 1.1 plus MathML 2.0 plus SVG 1.1 plus calc//EN"
    -->

    <xsl:param name="convertstyles" select="true()"/>
    <xsl:param name="convertcolorstyles" select="true()"/>
    <!-- translit -->
    <xsl:variable name="translit_rus" select="'абвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ .,;/?\/«»!@#$%^*()&amp;'"/>
    <xsl:variable name="translit_eng" select="'abvgdeеzzijklmnoprstufhccss___eyjabvgdeеzzijklmnoprstufhccss___eyj______\/____________'"/>
    <!-- replace in export.xsl and import.xsl -->
    <xsl:variable name="generator_version" select="'1.4'"/>
    <xsl:param name="copystyles" select="'Good,Neutral,Bad,Warning,Error,First_20_line_20_indent'"/>
    <xsl:variable name="documentType" select="local-name(office:document-content | office:document/office:body/office:spreadsheet)"/>


    <!-- from measure_conversion.xsl -->
    <xsl:param name="dpi" select="111"/>
    <xsl:param name="centimeter-in-mm" select="10"/>
    <xsl:param name="inch-in-mm" select="25.4"/>
    <xsl:param name="didot-point-in-mm" select="0.376065"/>
    <xsl:param name="pica-in-mm" select="4.2333333"/>
    <xsl:param name="point-in-mm" select="0.3527778"/>
    <xsl:param name="twip-in-mm" select="0.017636684"/>
    <xsl:param name="pixel-in-mm" select="$inch-in-mm div $dpi"/>
    <!-- changing measure to mm -->
    <xsl:template name="convert2mm">
        <xsl:param name="value"/>
        <xsl:param name="rounding-factor" select="10000"/>
        <xsl:choose>
            <xsl:when test="contains($value, 'mm')">
                <xsl:value-of select="substring-before($value, 'mm')"/>
            </xsl:when>
            <xsl:when test="contains($value, 'cm')">
                <xsl:value-of select="translate(round($rounding-factor * number(substring-before($value, 'cm' ) * $centimeter-in-mm)) div $rounding-factor,',','.')"/>
            </xsl:when>
            <xsl:when test="contains($value, 'in')">
                <xsl:value-of select="translate(round($rounding-factor * number(substring-before($value, 'in' ) * $inch-in-mm)) div $rounding-factor,',','.')"/>
            </xsl:when>
            <xsl:when test="contains($value, 'pt')">
                <xsl:value-of select="translate(round($rounding-factor * number(substring-before($value, 'pt') * $point-in-mm)) div $rounding-factor,',','.')"/>
            </xsl:when>
            <xsl:when test="contains($value, 'twip')">
                <xsl:value-of select="translate(round($rounding-factor * number(substring-before($value, 'twip') * $twip-in-mm)) div $rounding-factor,',','.')"/>
            </xsl:when>
            <xsl:when test="contains($value, 'dpt')">
                <xsl:value-of select="translate(round($rounding-factor * number(substring-before($value, 'dpt') * $didot-point-in-mm)) div $rounding-factor,',','.')"/>
            </xsl:when>
            <xsl:when test="contains($value, 'pica')">
                <xsl:value-of select="translate(round($rounding-factor * number(substring-before($value, 'pica') * $pica-in-mm)) div $rounding-factor,',','.')"/>
            </xsl:when>
            <xsl:when test="contains($value, 'px')">
                <xsl:value-of select="translate(round($rounding-factor * number(substring-before($value, 'px') * $pixel-in-mm)) div $rounding-factor,',','.')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>measure_conversion.xsl: Find no conversion for <xsl:value-of select="$value"/> to 'mm'!</xsl:message>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- identity template -->
    <xsl:template match="@*|node()" mode="copy">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="copy"/>
        </xsl:copy>
    </xsl:template>


    <xsl:template match="office:annotation">
        <span class="annotation">
            <span>
                <span class="content">
                    <xsl:for-each select="text:p">
                        <xsl:apply-templates/>
                    </xsl:for-each>
                </span>
                <span class="creator" title="{substring(dc:date,1,19)}">
                    <xsl:value-of select="dc:creator"/>
                </span>
            </span>
        </span>
    </xsl:template>


    <!-- Process the document model -->
    <xsl:template match="/">
        <xsl:processing-instruction name="xml-stylesheet">
            <xsl:variable name="document" select="office:document-content| office:document"/>
            <xsl:variable name="xmlstylesheet" select="$document/office:meta/meta:user-defined[@meta:name='xml-stylesheet']"/>
            <xsl:choose>
                <xsl:when test="$xmlstylesheet">
                    <xsl:value-of select="$xmlstylesheet"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>type="text/xsl" href="/oooxhtml/oooxhtml.xsl"</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:processing-instruction>
        <xsl:apply-templates />
    </xsl:template>
    <xsl:template match="office:document-content| office:document">
        <html>
            <xsl:apply-templates select="office:meta"/>
            <xsl:apply-templates select="office:body"/>
        </html>
    </xsl:template>
    <xsl:template match="office:meta">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
            <xsl:variable name="style">
                <xsl:apply-templates select="../office:automatic-styles/style:page-layout" mode="css"/>
            </xsl:variable>
            <xsl:if test="normalize-space($style)">
                <style type="text/css">
                    <xsl:value-of select="$style"/>
                </style>
            </xsl:if>
            <title>
                <xsl:value-of select="dc:title | //text:h[@text:outline-level='1'][1]/text()"/>
                <xsl:text><![CDATA[]]></xsl:text>
            </title>
            <meta name="generator" content="oooxhtml/{$generator_version}" />
            <xsl:if test="not(meta:user-defined[@meta:name='HeadURL'])">
                <meta name="HeadURL" content="$HeadURL$"/>
            </xsl:if>
            <xsl:apply-templates select="*"/>
        </head>
    </xsl:template>
    <xsl:template match="dc:description">
        <meta name="description" content="{.}" />
    </xsl:template>
    <xsl:template match="dc:subject">
        <meta name="subject" content="{.}" />
    </xsl:template>
    <xsl:template match="meta:keyword">
        <meta name="keywords" content="{.}" />
    </xsl:template>
    <xsl:template match="meta:user-defined">
        <xsl:choose>
            <xsl:when test="@meta:name='xml-stylesheet'">
            </xsl:when>
            <xsl:otherwise>
                <meta name="{@meta:name}" content="{.}" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- берем только 1 стиль -->
    <xsl:template match="style:page-layout[@style:name='pm1']" mode="css">
        <xsl:variable name="p" select="style:page-layout-properties"/>
        <xsl:variable name="style">
            <xsl:if test="@fo:page-width and @fo:page-height">
                <xsl:value-of select="concat('size:',$p/@fo:page-width,' ',$p/@fo:page-height,';')"/>
            </xsl:if>
            <xsl:apply-templates select="$p/@*" mode="page-layout"/>
        </xsl:variable>
        <xsl:if test="normalize-space($style)">
            <xsl:value-of select="concat('@page {',$style,'}')"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="@fo:margin-top|@fo:margin-right|@fo:margin-bottom|@fo:margin-left" mode="page-layout">
        <xsl:value-of select="concat(local-name(.),':',.,';')"/>
    </xsl:template>
    <xsl:template match="@style:print-orientation" mode="page-layout">
        <xsl:if test=".='landscape'">
            <xsl:value-of select="concat('size:',.,';')"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="@*" mode="page-layout"/>

    <!-- преобразует стиль офиса в css строку -->
    <xsl:template match="@table:style-name | @text:style-name" mode="expandcss">
        <xsl:variable name="styleName" select="."/>
        <xsl:variable name="style" select = "/*/office:automatic-styles/style:style[@style:name=$styleName]"/>
        <xsl:apply-templates select="$style/*/@*" mode="css"/>

        <xsl:if test="$style/@style:parent-style-name">
            <xsl:variable name="parentStyleName" select="$style/@style:parent-style-name"/>
            <!-- не расшиярем стили родителя-строенного стиля  - не пишем | /*/office:styles/style:style[@style:name=$parentStyleName] -->
            <xsl:variable name="parentStyle" select = "/*/office:automatic-styles/style:style[@style:name=$parentStyleName]"/>
            <xsl:apply-templates select="$parentStyle/*/@*" mode="css"/>
        </xsl:if>
    </xsl:template>
    <!-- |@padding|@border-left|@border-right|@border-top|@border-bottom -->

    <xsl:template match="@fo:background-color" mode="css">
        <xsl:if test="$convertcolorstyles and .!='transparent' and .!='#ffffff'">
            <xsl:value-of select="concat(local-name(.),':',.,';')"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="@fo:color" mode="css">
        <xsl:if test="$convertcolorstyles and .!='#000000'">
            <xsl:value-of select="concat(local-name(.),':',.,';')"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="@fo:font-weight" mode="css">
        <xsl:if test=".!='normal'">
            <xsl:value-of select="concat(local-name(.),':',.,';')"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="@fo:font-size" mode="css">
        <xsl:if test=".!='10pt'">
            <xsl:value-of select="concat(local-name(.),':',.,';')"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="@fo:text-indent" mode="css">
        <xsl:value-of select="concat(local-name(.),':',.,';')"/>
    </xsl:template>
    <xsl:template match="@fo:text-align" mode="css">
        <xsl:if test=".='center' or .='justify'">
            <xsl:value-of select="concat(local-name(.),':',.,';')"/>
        </xsl:if>
        <xsl:if test=".='end'">
            <xsl:value-of select="concat(local-name(.),':right;')"/>
        </xsl:if>
    </xsl:template>

    <!--    <xsl:template match="@fo:hyphenate" mode="css">
        <xsl:if test=".='true'">hyphens:auto;</xsl:if>
    </xsl:template>-->
    <!--    <xsl:template match="@fo:wrap-option" mode="css">
        <xsl:if test=".='wrap'">word-wrap:break-word;</xsl:if>
    </xsl:template>-->
    <xsl:template match="@fo:font-style" mode="css"> <!-- |@padding|@border-left|@border-right|@border-top|@border-bottom -->
        <xsl:if test="string(.)!='normal'">
            <xsl:value-of select="concat(local-name(.),':',.,';')"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="@style:text-position" mode="css">
        <xsl:if test="substring(.,1,3)='sub'">
            <xsl:text>vertical-align:sub;font-size:smaller;</xsl:text>
        </xsl:if>
        <xsl:if test="substring(.,1,5)='super'">
            <xsl:text>vertical-align:super;font-size:smaller;</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="@style:text-underline-style" mode="css">
        <xsl:if test="string(.)!='none'">
            <xsl:text>text-decoration:underline;</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="@style:text-line-through-style" mode="css">
        <xsl:if test="string(.)!='none'">
            <xsl:text>text-decoration:line-through;</xsl:text>
        </xsl:if>
    </xsl:template>
    <!-- высота строки - важна для импорта в calc  -->
    <xsl:template match="@style:row-height" mode="css">
        <xsl:variable name="height">
            <xsl:call-template name="convert2mm">
                <xsl:with-param name="value" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="$height!=4.52">
            <xsl:value-of select="concat('height:',$height,'mm;')"/>
        </xsl:if>
    </xsl:template>
    <!-- стиль колонок таблицы -->
    <!--    <xsl:template match="@style:column-width" mode="css">
        <xsl:value-of select="concat('min-width:',.,';')"/>
    </xsl:template>-->

    <!-- все не перечисленное исключаем -->
    <xsl:template match="@*" mode="css"/>

    <!-- css styles end -->

    <xsl:template match="office:body">
        <body>
            <xsl:apply-templates />
        </body>
    </xsl:template>
    <xsl:template match="office:spreadsheet">
        <div class="container spreadsheet">
            <xsl:if test="count(table:table)>1">
                <div class="toc">
                    <p>Содержание</p>
                    <ol>
                        <xsl:for-each select="table:table">
                            <li>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:text>#</xsl:text>
                                        <xsl:apply-templates select="." mode="id"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="@table:name"/>
                                </a>
                            </li>
                        </xsl:for-each>
                    </ol>
                </div>
            </xsl:if>
            <xsl:apply-templates />
        </div>
    </xsl:template>
    <xsl:template match="office:text">
        <div class="container text">
            <xsl:apply-templates />
        </div>
    </xsl:template>

    <xsl:template match="table:table" mode="id">
        <xsl:value-of select="translate(@table:name,$translit_rus,$translit_eng)"/>
    </xsl:template>

    <xsl:template match="table:table">
        <table summary="{@table:name}">
            <xsl:attribute name="id">
                <xsl:apply-templates select="." mode="id"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*"/>
            <xsl:if test="$documentType='spreadsheet'">
                <caption>
                    <xsl:value-of select="@table:name"/>
                </caption>
            </xsl:if>
            <colgroup>
                <xsl:choose>
                    <!-- эмуляция длинной колонки, ее и все что после нее исключаем -->
                    <xsl:when test="table:table-column[@table:number-columns-repeated &gt; 100]">
                        <xsl:apply-templates select="table:table-column[@table:number-columns-repeated &gt; 100 ]/preceding-sibling::table:table-column" mode="colgroup"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="table:table-column" mode="colgroup"/>
                    </xsl:otherwise>
                </xsl:choose>

            </colgroup>
            <xsl:apply-templates />
        </table>
    </xsl:template>
    <xsl:template match="table:table-column[not(@table:number-columns-repeated) or @table:number-columns-repeated &lt; 100 ]" mode="colgroup">
        <col>
            <xsl:if test="@table:number-columns-repeated and @table:number-columns-repeated > 1">
                <xsl:attribute name="span">
                    <xsl:value-of select="@table:number-columns-repeated"/>
                </xsl:attribute>
            </xsl:if>
            <!-- стиль колонок таблицы -->
            <xsl:if test="@table:style-name">
                <xsl:variable name="styleName" select="@table:style-name"/>
                <xsl:variable name="style" select = "/*/office:automatic-styles/style:style[@style:name=$styleName]"/>
                <xsl:variable name="width">
                    <xsl:call-template name="convert2mm">
                        <xsl:with-param name="value" select="$style/*/@style:column-width"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:if test="$width!=22.58">
                    <xsl:attribute name="style">
                        <xsl:value-of select="concat('min-width:',$width,'mm;')"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:if>

            <!--            <xsl:variable name="cssstyle">
                <xsl:if test="@table:style-name">
                    <xsl:variable name="styleName" select="@table:style-name"/>
                    <xsl:variable name="style" select = "/*/office:automatic-styles/style:style[@style:name=$styleName]"/>
                    <xsl:apply-templates select="$style/*/@*" mode="css"/>
                </xsl:if>
                <xsl:if test="@table:default-cell-style-name">
                    <xsl:variable name="styleName" select="@table:default-cell-style-name"/>
                    <xsl:variable name="style" select = "/*/office:automatic-styles/style:style[@style:name=$styleName]"/>
                    <xsl:apply-templates select="$style/*/@*" mode="css"/>
                </xsl:if>
            </xsl:variable>
            <xsl:if test="normalize-space($cssstyle)">
                <xsl:attribute name="style">
                    <xsl:value-of select="normalize-space($cssstyle)"/>
                </xsl:attribute>
            </xsl:if>-->
            <xsl:if test="@table:visibility">
                <xsl:attribute name="title">collapse</xsl:attribute>
            </xsl:if>
        </col>
    </xsl:template>

    <xsl:template match="table:table-row[not(@table:number-rows-repeated)]">
        <!-- не выводим пустые строки -->
        <xsl:if test="table:table-cell[not(@table:number-columns-repeated) or @table:number-columns-repeated &lt; 100 ]">
            <tr>
                <xsl:apply-templates select="@*"/>
                <xsl:choose>
                    <!-- эмуляция длинной колонки, ее и все что после нее исключаем -->
                    <xsl:when test="table:table-cell[@table:number-columns-repeated &gt; 100]">
                        <xsl:apply-templates select="table:table-cell[@table:number-columns-repeated &gt; 100 ]/preceding-sibling::*"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="*"/>
                    </xsl:otherwise>
                </xsl:choose>
            </tr>
        </xsl:if>
    </xsl:template>
    <!-- cell begin -->
    <xsl:template match="table:table-cell" mode="repeat">
        <xsl:param name="position"/>
        <xsl:param name="cnt" select="0"/>
        <xsl:if test="$cnt > 0">
            <xsl:variable name="elname">
                <xsl:choose>
                    <xsl:when test="text:p[@text:style-name='Table_20_Heading']">th</xsl:when>
                    <xsl:otherwise>td</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:element name="{$elname}">
                <xsl:apply-templates select="@*"/>
                <!-- если нет стиля, подтянем стиль по-умолчанию -->
                <xsl:if test="not(@table:style-name)">
                    <xsl:apply-templates select="ancestor::table:table/table:table-column[position()=$position]" mode="defaultstyle"/>
                </xsl:if>
                <xsl:apply-templates />
            </xsl:element>
            <xsl:apply-templates select="." mode="repeat">
                <xsl:with-param name="cnt" select="$cnt - 1"/>
                <xsl:with-param name="position" select="$position + 1"/>
            </xsl:apply-templates>

        </xsl:if>
    </xsl:template>

    <!--    <xsl:template match="table:covered-table-cell">
        <div class="covered-table-cell"/>

    </xsl:template>-->

    <xsl:template match="table:covered-table-cell" mode="countcovered">
        <xsl:variable name="current">
            <xsl:choose>
                <xsl:when test="@table:number-columns-repeated">
                    <xsl:value-of select="@table:number-columns-repeated"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>1</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="prev">
            <xsl:if test="local-name(preceding-sibling::*[1])='covered-table-cell'">
                <xsl:apply-templates select="preceding-sibling::*[1]" mode="countcovered"/>
            </xsl:if>
            <xsl:if test="local-name(preceding-sibling::*[1])!='covered-table-cell'">
                <xsl:text>0</xsl:text>
            </xsl:if>
        </xsl:variable>
        <xsl:value-of select="$current + $prev"/>
    </xsl:template>
    <xsl:template match="table:table-column" mode="defaultstyle">
        <xsl:if test="@table:default-cell-style-name">
            <xsl:variable name="styleName" select="@table:default-cell-style-name"/>

            <xsl:if test="contains($copystyles, $styleName)">
                <xsl:attribute name="class">
                    <xsl:value-of select="$styleName"/>
                </xsl:attribute>
            </xsl:if>

            <xsl:variable name="style" select = "/*/office:automatic-styles/style:style[@style:name=$styleName]"/>
            <xsl:variable name="cssstyle">
                <xsl:apply-templates select="$style/*/@*" mode="css"/>
            </xsl:variable>
            <xsl:if test="$cssstyle!=''">
                <xsl:attribute name="style">
                    <xsl:value-of select="$cssstyle"/>
                </xsl:attribute>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <!--<xsl:template match="table:table-cell[not(@table:number-columns-repeated) or following-sibling::table:table-cell[not(@table:number-columns-repeated)]]">-->
    <xsl:template match="table:table-cell[not(@table:number-columns-repeated) or @table:number-columns-repeated &lt; 100 ]">
        <!-- предыдущие столбцы -->
        <xsl:variable name="preceding">
            <xsl:for-each select="preceding-sibling::*">
                <tmp value="{@table:number-columns-repeated | @table:number-columns-spanned | exsl:node-set(1)}"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="position" select="sum(exsl:node-set($preceding)/*/@value)+1"/>
        <xsl:variable name="column" select="ancestor::table:table/table:table-column[position()=$position]"/>

        <xsl:choose>
            <xsl:when test="@table:number-columns-repeated and @table:number-columns-repeated >1">
                <xsl:apply-templates select="." mode="repeat">
                    <xsl:with-param name="cnt" select="@table:number-columns-repeated"/>
                    <xsl:with-param name="position" select="$position"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="elname">
                    <xsl:choose>
                        <xsl:when test="text:p[@text:style-name='Table_20_Heading']">th</xsl:when>
                        <xsl:otherwise>td</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:element name="{$elname}">
                    <xsl:choose>
                        <xsl:when test="$column/@table:visibility='collapse'">
                            <xsl:attribute name="style">display:none;</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="@*"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!-- если нет стиля, подтянем стиль по-умолчанию -->
                    <xsl:if test="not(@table:style-name)">
                        <xsl:apply-templates select="exsl:node-set($column)" mode="defaultstyle"/>
                    </xsl:if>
                    <xsl:if test="local-name(preceding-sibling::*[1])='covered-table-cell'">
                        <xsl:attribute name="title">
                            <xsl:apply-templates select="preceding-sibling::*[1]" mode="countcovered"/>
                            <!--<xsl:value-of select="count(preceding-sibling::table:covered-table-cell[not(@table:number-columns-repeated)]) + sum(preceding-sibling::table:covered-table-cell/@table:number-columns-repeated)"/>-->
                        </xsl:attribute>
                    </xsl:if>
                    <!--<xsl:value-of select="$position"/>-->
                    <xsl:apply-templates select="." mode="cellvalue"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="table:table-cell[@office:value-type='date']" mode="cellvalue">
        <p>
            <xsl:value-of select="@office:date-value"/>
        </p>
    </xsl:template>

    <xsl:template match="table:table-cell" mode="cellvalue">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="@table:number-columns-spanned">
        <xsl:if test="number(.) > 1">
            <xsl:attribute name="colspan">
                <xsl:value-of select="."/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="@table:number-rows-spanned">
        <xsl:if test="number(.) > 1">
            <xsl:attribute name="rowspan">
                <xsl:value-of select="."/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="@table:formula">
        <xsl:attribute name="title">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="@table:style-name | @text:style-name">
        <xsl:variable name="styleName" select="."/>
        <xsl:variable name="style" select = "/*/office:automatic-styles/style:style[@style:name=$styleName]"/>
        <xsl:variable name="parentStyleName" select="$style/@style:parent-style-name"/>
        <xsl:if test="$styleName and contains($copystyles, $styleName)">
            <xsl:attribute name="class">
                <xsl:value-of select="$styleName"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$parentStyleName and contains($copystyles, $parentStyleName)">
            <xsl:attribute name="class">
                <xsl:value-of select="$parentStyleName"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$convertstyles">
            <xsl:variable name="styletext">
                <xsl:apply-templates select="." mode="expandcss"/>
            </xsl:variable>
            <xsl:if test="$styletext!=''">
                <xsl:attribute name="style">
                    <xsl:value-of select="$styletext"/>
                </xsl:attribute>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template match="@office:value-type">
        <xsl:if test=".='float' or .='date' or .='percentage'">
            <xsl:attribute name="class">
                <xsl:value-of select="."/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <!--    <xsl:template match="@office:value">
        <xsl:attribute name="data-value">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>    -->

    <!--<xsl:template match="@*"/>-->
    <!-- cell end -->

    <xsl:template match="text:line-break">
        <br/>
    </xsl:template>

    <xsl:template match="text:p[@text:style-name='Preformatted_20_Text']">
        <pre>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates />
        </pre>
    </xsl:template>
    <xsl:template match="text:p[@text:style-name='Quotations']">
        <blockquote>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates />
        </blockquote>
    </xsl:template>

    <xsl:template match="text:s">
        <xsl:param name="remaining" select="@text:c"/>
        <xsl:if test="$remaining > 0">
            <xsl:text> </xsl:text>
            <xsl:apply-templates select=".">
                <xsl:with-param name="remaining" select="$remaining - 1"/>
            </xsl:apply-templates>
        </xsl:if>
    </xsl:template>

    <xsl:template match="text:p">
        <!-- Иногда libreoffice выводит стиль "Заголовок 1" как обычный p, смотрим на стиль, если это Heading_20_1, выведем h1 -->
        <xsl:variable name="styleName" select="@text:style-name"/>
        <xsl:variable name="style" select = "/*/office:automatic-styles/style:style[@style:name=$styleName]"/>
        <xsl:choose>
            <xsl:when test="$style/@style:parent-style-name='Heading_20_1'">
                <h1>
                    <xsl:apply-templates />
                </h1>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="normalize-space(.) or *">
                    <p>
                        <xsl:apply-templates select="@*"/>
                        <xsl:apply-templates />
                    </p>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- автоматическая замена ссылок на разделы ссылками на закладки -->
    <xsl:template match="text:a">
        <xsl:variable name="xhref" select="@xlink:href"/>
        <xsl:variable name="prev" select="preceding-sibling::*"/>
        <xsl:if test="not(local-name($prev)='a' and $prev/@xlink:href=$xhref)">
            <xsl:variable name="href">
                <xsl:choose>
                    <xsl:when test="contains(@xlink:href,'|outline')">
                        <xsl:variable name="hname" select="translate(substring-before(@xlink:href,'|outline'),'#1234567890.','')"/>
                        <xsl:text>#</xsl:text>
                        <xsl:apply-templates select="//text:h[translate(.,'#1234567890.','')=$hname][1]" mode="id"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@xlink:href"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <a href="{$href}">
                <xsl:apply-templates />
                <!-- включение "разбитых на части" ссылок -->
                <xsl:for-each select="following-sibling::text:a[@xlink:href=$xhref]">
                    <xsl:apply-templates />
                </xsl:for-each>
            </a>
        </xsl:if>
    </xsl:template>
    <xsl:template match="text:list-header">
        <xsl:apply-templates/>
    </xsl:template>
    <!-- не пустой список -->
    <xsl:template match="text:list[text:list-item]">
        <xsl:variable name="styleName" >
            <xsl:choose>
                <xsl:when test="@text:style-name">
                    <xsl:value-of select="@text:style-name"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="ancestor::text:list[@text:style-name]/@text:style-name"/>

                    <!--                    <xsl:variable name="itemStyleName" select="text:list-item[1]/text:p[1]/@text:style-name"/>
                    <xsl:variable name="itemStyle" select = "/*/office:automatic-styles/style:style[@style:name=$itemStyleName]"/>
                    <xsl:value-of select="$itemStyle/@style:list-style-name"/>-->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="style" select = "/*/office:automatic-styles/text:list-style[@style:name=$styleName]"/>
        <xsl:choose>
            <xsl:when test="$style/text:list-level-style-number[@text:level='1']">
                <ol>
                    <xsl:apply-templates />
                </ol>
            </xsl:when>
            <xsl:otherwise>
                <ul>
                    <xsl:apply-templates />
                </ul>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    <!-- пустой список, в нем бывает list-header -->
    <xsl:template match="text:list[not(text:list-item) and text:list-header]">
        <xsl:apply-templates />
    </xsl:template>
    <!-- пустой список с заголовком, выведем только заголовок -->
    <xsl:template match="text:list[not(text:list-item) and text:list-header]">
        <xsl:apply-templates select="text:list-header/*"/>
    </xsl:template>
    <!-- элемент списка -->
    <xsl:template match="text:list-item">
        <li>
            <xsl:apply-templates />
        </li>
    </xsl:template>

    <xsl:template match="math:math">
        <math xmlns="http://www.w3.org/1998/Math/MathML">
            <xsl:for-each select="../..">
                <xsl:attribute name="width">
                    <xsl:value-of select="@svg:width"/>
                </xsl:attribute>
                <xsl:attribute name="height">
                    <xsl:value-of select="@svg:height"/>
                </xsl:attribute>
                <xsl:attribute name="alttext">
                    <xsl:value-of select="@draw:name"/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </math>
    </xsl:template>

    <xsl:template match="draw:frame">
        <xsl:apply-templates />
    </xsl:template>
    <xsl:template match="draw:object">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="draw:image[contains(@xlink:href,'.svg') and not(preceding-sibling::draw:image)]">
        <object data="{@xlink:href}" type="image/svg+xml"/>
    </xsl:template>
    <xsl:template match="draw:image">
        <!-- не выводим повторяющиеся изображения, например вставка svg в документ сохраняется как два изображения -->
        <xsl:if test="(@xlink:href or office:binary-data) and not(preceding-sibling::draw:image)">
            <img alt="{../@draw:name}" style="width:{../@svg:width};height:{../@svg:height}"> <!-- left:{../@svg:x};top:{../@svg:y}; -->
                <xsl:attribute name="src">
                    <xsl:choose>
                        <xsl:when test="normalize-space(@xlink:href)">
                            <xsl:value-of select="@xlink:href"/>
                        </xsl:when>
                        <xsl:when test="office:binary-data">
                            <xsl:value-of select="concat('data:',@loext:mime-type,';base64,',translate(office:binary-data,' &#10;',''))"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:attribute>
                <!--            <xsl:attribute name="width">
                    <xsl:call-template name="convert2px">
                        <xsl:with-param name="value" select="@svg:width" />
                    </xsl:call-template>
                </xsl:attribute>
                <xsl:attribute name="height">
                    <xsl:call-template name="convert2px">
                        <xsl:with-param name="value" select="@svg:height" />
                    </xsl:call-template>
                </xsl:attribute>-->
            </img>
        </xsl:if>
    </xsl:template>

    <xsl:template match="text:h" mode="id">
        <xsl:choose>
            <xsl:when test="text:bookmark">
                <xsl:value-of select="translate(text:bookmark/@text:name,' ','_')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="translate(normalize-space(text()|text:span|text:p),$translit_rus,$translit_eng)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="text:h">
        <xsl:if test="normalize-space(.)">
            <xsl:element name="{concat('h',@text:outline-level)}">
                <xsl:variable name="name">
                    <xsl:apply-templates select="." mode="id"/>
                </xsl:variable>
                <xsl:attribute name="id">
                    <xsl:value-of select="$name"/>
                </xsl:attribute>
                <a class="anchor" href="#{$name}">
                    <xsl:apply-templates />
                </a>

            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="text:span[@text:style-name='Citation']">
        <cite>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates />
        </cite>
    </xsl:template>
    <xsl:template match="text:span">
        <!--<xsl:if test="normalize-space(.)">-->
        <xsl:variable name="styleName" select="@text:style-name"/>
        <xsl:variable name="style">
            <xsl:apply-templates select="@text:style-name" mode="expandcss"/>
        </xsl:variable>

        <xsl:choose>
            <!-- не автоматический стиль -->
            <xsl:when test = "/*/office:styles/style:style[@style:name=$styleName and contains($copystyles, $styleName)]">
                <span class="{$styleName}">
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates />
                </span>
            </xsl:when>
            <!-- упрощаем простые стили -->
            <xsl:when test="$style='font-weight:bold;'">
                <b>
                    <xsl:apply-templates />
                </b>
            </xsl:when>
            <xsl:when test="contains($style,'vertical-align:sub;font-size:smaller;')">
                <sub>
                    <xsl:apply-templates />
                </sub>
            </xsl:when>
            <xsl:when test="contains($style,'vertical-align:super;font-size:smaller;')">
                <sup>
                    <xsl:apply-templates />
                </sup>
            </xsl:when>
            <xsl:when test="$style='font-style:italic;'">
                <i>
                    <xsl:apply-templates />
                </i>
            </xsl:when>
            <!-- если стили не сконвертировались, выведем текст без span ? -->
            <xsl:when test="$style=''">
                <xsl:apply-templates />
            </xsl:when>
            <xsl:otherwise>
                <span>
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates />
                </span>
            </xsl:otherwise>
        </xsl:choose>
        <!--</xsl:if>-->
    </xsl:template>

    <xsl:template match="*| @*" />

</xsl:stylesheet>
