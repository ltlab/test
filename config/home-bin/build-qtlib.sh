#!/bin/sh

CROSS_COMPILE_PREFIX=arm-hisiv200-linux-

QTLIB_DIR=$HOME/qtlib
BUILD_DIR=`pwd`/tmp4qt

MAJOR_VER=5.1
MINOR_VER=1
QT_VER=${MAJOR_VER}.${MINOR_VER}

QT_URL="http://download.qt-project.org/official_releases/qt/$MAJOR_VER/$QT_VER/single"
QT_FILENAME=qt-everywhere-opensource-src-${QT_VER}.tar.gz
QT_LOCAL_PATH=$BUILD_DIR/$(basename $QT_FILENAME .tar.gz)

QMAKE_CONF_FILE=$QT_LOCAL_PATH/qtbase/mkspecs/linux-arm-gnueabi-g++/qmake.conf

QT_CONFIG_OPTION="-v -opensource -confirm-license -release \
-prefix $HOME/qtlib/ \
-xplatform linux-arm-gnueabi-g++ \
-device-option \
CROSS_COMPILE=/opt/hisi-linux/x86-arm/arm-hisiv200-linux/target/bin/arm-hisiv200-linux- \
-make libs \
-no-c++11 \
-no-gui \
-no-widgets \
-no-accessibility \
-no-opengl \
-no-openvg \
-no-compile-examples \
-nomake tests \
-nomake examples \
-nomake tools"

COLOR_SH="$HOME/bin/color.sh"

if [ -e $COLOR_SH ] ; then
	source $COLOR_SH
fi

echo -e $YELLOW_BOLD"QT_VER: $QT_VER $BUILD_DIR"$ENDCOLOR
echo -e $WHITE_BOLD"QT_OPT:"$ENDCOLOR" $QT_CONFIG_OPTION"
echo -e $WHITE_BOLD"QT_FILENAME: $QT_FILENAME"$ENDCOLOR

if [ -e $QTLIB_DIR ]  ; then 
	exit 0
fi

cd $HOME

mkdir -p $BUILD_DIR

cd $BUILD_DIR

wget $QT_URL/$QT_FILENAME

tar -zxvf $QT_FILENAME

sed -i "s/arm-linux-gnueabi-/$CROSS_COMPILE_PREFIX/g" $QMAKE_CONF_FILE

cd $QT_LOCAL_PATH/qtbase

./configure $QT_CONFIG_OPTION

make -j2

make install

cd $HOME

rm -rf $BUILD_DIR

