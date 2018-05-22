#!/bin/sh
. ../build_config.sh

rm -rf tmp
mkdir tmp
cd tmp

wget https://github.com/acoustid/chromaprint/releases/download/v$CHROMAPRINT_VERSION/chromaprint-$CHROMAPRINT_VERSION.tar.gz
tar -xf chromaprint-$CHROMAPRINT_VERSION.tar.gz
cd chromaprint-v$CHROMAPRINT_VERSION

cmake \
    -DCMAKE_CXX_FLAGS="-fPIC" \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=OFF \
    -DBUILD_TOOLS=OFF \
    -DFFMPEG_ROOT=../../ \
    -DFFT_LIB=fftw3f \
    -DFFTW3_DIR=../../ \
    -DCMAKE_VERBOSE_MAKEFILE=ON
    .

make
make install

cd ../..
rm -r tmp

# patch libchromaprint.pc to add a missing link flag for fftw3f
sed -i -e 's/-lchromaprint/-lchromaprint -lfftw3f/g' lib/pkgconfig/libchromaprint.pc