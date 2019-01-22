#!/bin/bash

# tput value
## 0    black     COLOR_BLACK     0,0,0
## 1    red       COLOR_RED       1,0,0
## 2    green     COLOR_GREEN     0,1,0
## 3    yellow    COLOR_YELLOW    1,1,0
## 4    blue      COLOR_BLUE      0,0,1
## 5    magenta   COLOR_MAGENTA   1,0,1
## 6    cyan      COLOR_CYAN      0,1,1
## 7    white     COLOR_WHITE     1,1,1
## sgr0 Reset text format to the terminal's default

# Find Package
find_package_dpkg() {
    tput setaf 4
    echo "#### Checking < $1 > Package ####"
    tput sgr0
    dpkg -s $1 > /dev/null 2>&1
    return $?
}

find_package_source() {
    tput setaf 4
    echo "#### Checking < $1 > Package ####"
    tput sgr0
    case "$1" in
        gtest)
            test -f /usr/local/include/gtest/gtest.h ||
                test -f /usr/include/gtest/gtest.h ||
                test -f /usr/local/lib/libgtest.a ||
                test -f /usr/local/lib/libgtest.so ||
                test -f /usr/lib/libgtest.a ||
                test -f /usr/lib/libgtest.so
            ;;
        cmake)
            which cmake > /dev/null 2>&1
            ;;
        *)
            cd $TEMP_DIR
            cmake --find-package -DNAME=$1 -DCOMPILER_ID=GNU -DLANGUAGE=C -DMODE=EXIST > /dev/null 2>&1
            ;;
    esac
    return $?
}

install_package() {
    set -e
    case  "$1" in
        hpp2plantuml)
            install_hpp2plantuml
            ;;
        xlsx)
            install_xlsx
            ;;
        markdownpp)
            install_markdownpp
            ;;
        cmake)
            install_cmake
            ;;
        LLVM)
            install_llvm
            ;;
        Boost)
            install_libboost
            ;;
        gtest)
            install_gtest
            ;;
        sudo)
            if [ $USER != "root" ]; then
                tput setaf 1
                echo "#### You have to install sudo package"
                tput sgr0
                exit 1
            fi
            ;;
        *)
            install_dpkg_package $1
            ;;
    esac
    set +e
}

install_dpkg_package() {
    tput setaf 3
    echo "#### Install $1 package(using dpkg) ####"
    tput sgr0
    $SUDO apt-get install $1 -y
}

install_cmake() {
    tput setaf 3
    echo "#### Install cmake package ####"
    tput sgr0
    cd $TEMP_DIR
    wget https://cmake.org/files/v3.11/cmake-3.11.1.tar.gz
    tar zxvf cmake-3.11.1.tar.gz
    cd cmake-3.11.1/
    ./configure
    make -j$JOBS
    $SUDO make install
    cd $TEMP_DIR
}

install_libboost() {
    tput setaf 3
    echo "#### Install libboost package ####"
    tput sgr0
    cd $TEMP_DIR
    wget https://dl.bintray.com/boostorg/release/1.67.0/source/boost_1_67_0.tar.gz
    tar zxvf boost_1_67_0.tar.gz
    cd boost_1_67_0/
    ./bootstrap.sh
    ./b2 -j$JOBS
    $SUDO ./b2 install
    cd $TEMP_DIR
}

install_gtest() {
    tput setaf 3
    echo "#### Install gtest package ####"
    tput sgr0
    cd $TEMP_DIR
    wget https://github.com/google/googletest/archive/release-1.8.0.tar.gz
    tar zxvf release-1.8.0.tar.gz
    cd googletest-release-1.8.0/
    mkdir build
    cd build
    cmake ..
    make -j$JOBS
    $SUDO make install
    cd $TEMP_DIR
}

install_llvm() {

    REVISION=330569

    tput setaf 3
    echo "#### Install LLVM package ####"
    tput sgr0

    cd $TEMP_DIR
    # Checkout LLVM
    svn co -r $REVISION http://llvm.org/svn/llvm-project/llvm/trunk llvm

    # Checkout Clang
    cd llvm/tools
    svn co -r $REVISION http://llvm.org/svn/llvm-project/cfe/trunk clang
    cd $TEMP_DIR

    # Checkout Extra Clang Tools
    cd llvm/tools/clang/tools
    svn co -r $REVISION http://llvm.org/svn/llvm-project/clang-tools-extra/trunk extra
    cd $TEMP_DIR

    # Build clang
    mkdir llvm-build
    cd llvm-build
    cmake -G "Unix Makefiles" -DBUILD_SHARED_LIBS=ON ../llvm
    make -j$JOBS
    $SUDO make install
    cd $TEMP_DIR
}

install_hpp2plantuml() {
    #tput setaf 3
    #echo "#### Install setuptools package ####"
    #tput sgr0
	#cd ${TOP_DIR}
	#tar xvfo ./setuptools-40.0.0.tar.gz
	#cd ${TOP_DIR}/setuptools-40.0.0
    #python3 setup.py install --user

    tput setaf 3
    echo "#### Install hpp2plantuml package ####"
    tput sgr0
	cd ${TEMP_DIR}
	git clone https://github.com/thibaultmarin/hpp2plantuml.git
	cd ${TEMP_DIR}/hpp2plantuml/
    python3 setup.py install --user
    cd ..
	/bin/rm -rf ./hpp2plantuml
}

install_xlsx() {
    tput setaf 3
    echo "#### Install perl5/lib/perl5/Excel/Writer/XLSX package ####"
    tput sgr0
	if [ -d ~/perl5/lib/perl5/Excel/Writer/XLSX ]; then
		tput setaf 3
		echo "#### Already Installed  Excel/Writer/XLSX package ####"
		tput sgr0
	else
        cpan Excel::Writer::XLSX
		#tar xvfz ./perl5.tar.gz
		#/bin/cp -r perl5  ~/
		#/bin/rm -rf ./perl5
		#cat ./perl5.bashrc >> ~/.bashrc
	fi
}

install_markdownpp() {
    tput setaf 3
    echo "#### Install markdown-pp package ####"
    tput sgr0
	cd ${TEMP_DIR}
	git clone https://github.com/jreese/markdown-pp.git
	cd ${TEMP_DIR}/markdown-pp
    python setup.py install --user
    cd ..
	/bin/rm -rf ./markdown-pp
}


########## Start Main function ##########

##### Start Setting Environment #####

TOP_DIR=`pwd`
TEMP_DIR=$TOP_DIR/tmp
JOBS=8
USER=`whoami`
if [ $USER != "root" ]; then
    SUDO="sudo"
fi

# DEPENDENCY_DPKG_PACKAGES="sudo build-essential wget subversion python-dev git lcov"
#DEPENDENCY_DPKG_PACKAGES="sudo build-essential wget python-dev git pandoc"
# DEPENDENCY_SOURCE_PACKAGES="cmake Boost LLVM gtest"
#DEPENDENCY_SOURCE_PACKAGES="hpp2plantuml xlsx markdownpp"
DEPENDENCY_SOURCE_PACKAGES="hpp2plantuml markdownpp"

mkdir -p $TEMP_DIR

for dpkg_pack in $DEPENDENCY_DPKG_PACKAGES
do
    find_package_dpkg $dpkg_pack
    if [ $? -ne 0 ]; then
        install_package $dpkg_pack
    else
        tput setaf 2
        echo "-----> $dpkg_pack is alreay installed."
        tput sgr0
    fi
done

for src_pack in $DEPENDENCY_SOURCE_PACKAGES
do
	echo $src_pack
    find_package_source $src_pack
    if [ $? -ne 0 ]; then
        install_package $src_pack
    else
        tput setaf 2
        echo "-----> $src_pack is alreay installed."
        tput sgr0
    fi
done

tput setaf 2
echo "##### setting is done. #####"
tput sgr0

##### End Setting Environment #####


##### Start Testing Code #####



