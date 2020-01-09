set -e
./mkdist.sh
unzip -o -d $HOME/.config/libreoffice/4/user/xslt/ ../dist/oooxhtml.jar
