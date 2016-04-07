#!/bin/sh

ROOT='/Users/bouge/share/no_save/SVN/Teach_ENS_Rennes/MIT1_PROG2/TD'

set -x

cd "$ROOT"

cd TD8_Clotures
svn commit -m ''
make pdfnup
mv td-nup.pdf "$ROOT"
cp td.pdf "$ROOT"/td8.pdf
make clean

cd MLlisp_dynamic
make clean

cd ../MLlisp_static
make clean

cd ..
(rm *.zip)

zip -r MLlisp_dynamic.zip MLlisp_dynamic
mv MLlisp_dynamic.zip "$ROOT"
zip -r MLlisp_static.zip MLlisp_static
mv MLlisp_static.zip "$ROOT"

cd ..
zip -r TD8.zip TD8_Clotures








     
