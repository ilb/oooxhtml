xsltproc --nonet --novalid ../stylesheets/import.xsl image.xhtml | tidy -i -utf8 -xml -w 1000 > image_import.xml