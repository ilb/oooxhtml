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

cat > ${TMPDIR}/input.xhtml
xsltproc --nonet --novalid ${BASEDIR}/CleanXHTMLCalc/import.xsl ${TMPDIR}/input.xhtml > ${TMPDIR}/content.xml
zip -v -j -X -b ${TMPDIR} -O ${TMPDIR}/result.ods ${BASEDIR}/template1.ods ${TMPDIR}/content.xml >${TMPDIR}/zip.log
file -ib ${TMPDIR}/result.ods | grep -q "application/vnd.oasis.opendocument." || false
cat ${TMPDIR}/result.ods
rm ${TMPDIR}/*
rmdir ${TMPDIR}
