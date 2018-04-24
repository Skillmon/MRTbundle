#!/bin/zsh
# This is a shell script created to ease the package creation (zip and tarball).
# It doesn't look good but does the job. Users might ignore this file!

BDIR='/home/archie/Code/LaTeX/Own_packages'
WDIR="MRTbundle"
OUTP="$WDIR/Archives"
OLD="$OUTP/Old"

INPUT="$WDIR/MRTbeam $WDIR/MRTif $WDIR/MRTsfacc $WDIR/MRTthesis"

#ZIP_F1='tex'

#ZIP_F2='img/* template_img/*'

#FILES='img template_img tex/*.tex mrtarbeit.{tex,sty,pdf} makefile works-cited.bib readme.txt'

while true; do
    echo -n 'version numbers and dates changed? <y,N>  '
    read answer
    case $answer in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) exit;;
    esac
done

cd $BDIR/$WDIR
if [ -d $OUTP ];then;else
    mkdir $OUTP
fi
if [ -d $OLD ];then;else
    mkdir $OLD
fi

echo "\nmoving old archives to '$OLD'"
mv $OUTP/*.zip $OLD
mv $OUTP/*.tar.xz $OLD

if [ -d ./Doc ];then
    if [ -f ./Doc/Makefile ];then
        cd Doc
        make all
        cd ..
    fi
fi

cp readme.txt readme_bak
unix2dos -q -n readme_bak readme.txt

cd $BDIR
echo "\nbuilding zip-archive..."
zip -ur $OUTP/MRTbundle-$(date +'%Y-%m-%d').zip $INPUT

cd $BDIR/$WDIR
mv readme_bak readme.txt

echo "\nbuilding tarball..."
tar -C $BDIR -cavf $OUTP/MRTbundle-$(date +'%Y-%m-%d').tar.xz $INPUT

#echo $ZIP_F1 $FILES $ZIP_F2 | xargs zip -u $OUTP/mrt_template-$(date +'%Y-%m-%d').zip

#echo $FILES | xargs zsh -c find | xargs tar -uavf $OUTP/mrt_template-$(date +'%Y-%m-%d').tar.xz
