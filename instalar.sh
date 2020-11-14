rm -CMakeCache.txt
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr .

make
make install