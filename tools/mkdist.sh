set -e
BASEDIR=`dirname $0`
BASEDIR=`readlink -f $BASEDIR`
BASEDIR=`dirname $BASEDIR`
TMPDIR=`mktemp -d`
cp -v TypeDetection.xcu $TMPDIR
mkdir -v $TMPDIR/CleanXHTMLWriter $TMPDIR/CleanXHTMLCalc
cp -v ../stylesheets/*.xsl $TMPDIR/CleanXHTMLWriter
cp -v ../stylesheets/*.xsl $TMPDIR/CleanXHTMLCalc
sed -i 's/MathML 2.0 plus SVG 1.1/MathML 2.0 plus SVG 1.1 plus calc/' $TMPDIR/CleanXHTMLCalc/export.xsl
#sed -i 's^http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd^http://www.w3.org/Math/DTD/mathml2/xhtml-math11-f.dtd^' $TMPDIR/CleanXHTMLCalc/export.xsl
cd $TMPDIR
zip -r $BASEDIR/dist/oooxhtml.jar *
cd $BASEDIR
rm -rvf $TMPDIR