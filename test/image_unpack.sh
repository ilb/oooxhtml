unzip -c image.odt content.xml | tidy -i -utf8 -xml -w 1000 > image.xml
unzip -c image.odt meta.xml | tidy -i -utf8 -xml -w 1000 > image_meta.xml
unzip -c image.odt styles.xml | tidy -i -utf8 -xml -w 1000 > image_styles.xml
