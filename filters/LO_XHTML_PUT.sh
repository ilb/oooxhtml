#!/bin/sh

set -e
set -u
set -o pipefail
set -o errtrace
#на коды и сообщения в стдерр фильтра апач никак не реагирует - "труба" открыта, заголовки клиенту отправлены...
#просто подменяем контент каким-нибудь безобразием заведомо не-xhtml-ным
trap 'echo "500 INTERNAL SERVER ERROR" && echo $0 failed at:${LINENO}:${?} 1>&2 && exit 1' ERR

TMPDIR=/tmp/${0//\//_}$$
mkdir ${TMPDIR}
BASEDIR=$(dirname $0)

cat > ${TMPDIR}/input
#это не наш xhtml, а настоящий - не трогаем - отдаем как было
if ! file -ib ${TMPDIR}/input | grep -q "application/vnd.oasis.opendocument." ; then
 cat ${TMPDIR}/input
 rm ${TMPDIR}/input
 rmdir ${TMPDIR}
 exit 0
fi

unzip -d ${TMPDIR} ${TMPDIR}/input content.xml meta.xml >${TMPDIR}/zip.log
#office:meta лежит в отдельном файле meta=$(xmllint --xpath "//*[local-name()='meta']" ${TMPDIR}/meta.xml)
#подключим через Xinclude
sed -e 's#<office:body>#<xi:include xmlns:xi="http://www.w3.org/2003/XInclude" href="meta.xml" xpointer="xpointer(*/*)"/><office:body>#' ${TMPDIR}/content.xml > ${TMPDIR}/xi.xml
xmllint -xinclude ${TMPDIR}/xi.xml > ${TMPDIR}/content2.xml
xsltproc --nonet --novalid ${BASEDIR}/CleanXHTMLCalc/export.xsl ${TMPDIR}/content2.xml > ${TMPDIR}/result.xhtml
cat ${TMPDIR}/result.xhtml
rm ${TMPDIR}/*
rmdir ${TMPDIR}
