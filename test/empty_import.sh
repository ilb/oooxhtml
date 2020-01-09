set -e
xsltproc --nonet --novalid ../stylesheets/import.xsl empty.xhtml | tidy -i -utf8 -xml -w 1000 > empty_import.fods