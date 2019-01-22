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

perl -e "use 5.010"
if [ $? -ge  1 ]
then
	tput setaf 1
	echo "Need more recent perl version than v5.010"
	tput sgr0
    exit 3;
fi

if [ -s ./.perlmodule ]; then
    tput setaf 5
    echo "Already perlmodule was installed. If you want to initialize , remove .perlmodule file"
    tput sgr0
else 
    perl -e "use Excel::Writer::XLSX"
    if [ $? -ge  1 ]; then
        tput setaf 1
        echo "Need perl module Excel::Writer::XLSX"
        echo "$ cpan Excel::Writer::XLSX"
        tput sgr0
        cpan Excel::Writer::XLSX
        echo "INSTALLED Excel::Writer::XLSX perl module" > ./.perlmodule
        exit 4;
    else 
        tput setaf 5
        echo "Already installed Excel::Writer::XLSX perl module" 
        tput sgr0
        echo "INSTALLED Excel::Writer::XLSX perl module" > ./.perlmodule
    fi
fi

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     
		machine=Linux
		lsOption="-alF --color=auto"
		break
		;; 
    Darwin*)    
		machine=Mac
		lsOption="-alFG"
		;; 
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
tput setaf 5
echo "Machine => ${machine}"
tput sgr0

if [ -z  $* ] 
then
	tput setaf 1
	echo "$ run.sh source_directories"
	echo "   - directory is not recursive."
	echo "   - ex) run.sh .. ../inc example/A"
	tput sgr0
	exit 1;
fi

if [ $1 = "clean" ] 
then
	tput setaf 2
	echo "#### Clean ./build_doxygen/src ####"
	tput sgr0
	/bin/rm -f  ./build_doxygen/src/*
	ls ${lsOption} ./build_doxygen/src/
	exit 2;
fi

tput setaf 2
echo "#### Make soft links in src ####"
tput sgr0

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
/bin/rm -rf ./build_doxygen/src
/bin/rm -rf ./build_uml/src
mkdir -p ./build_doxygen/src
mkdir -p ./build_uml/src
pwd=`pwd`
for directory in $*
do
	echo "directory : $directory"
	for file in $directory/*.cpp $directory/*.cc $directory/*.h 
	do
		basefile=`basename $file`
		echo "    basefile : $basefile  ,  file : $file"
		if [ -s $file ]; then
			echo "make soft linke $pwd/$file <-- ./build_doxygen/src/$basefile  ./build_uml/src/$basefile"
			ln -sf $pwd/$file ./build_doxygen/src/$basefile
			ln -sf $pwd/$file ./build_uml/src/$basefile
		fi
	done
	#cp -f $file $file\.orig
	#expand -t 4 $file\.orig > $file\.tmp
	#sed --in-place 's/[[:space:]]\+$//'  $file\.tmp
	#sed --in-place 's///g'  $file\.tmp
	#diff -q $file $file\.tmp
	#if [ $? -ne '0' ]
	#then
		#echo "$file Changed :::  original file : $file\.orig"
		#cp -f $file\.tmp $file
	#fi
	#rm -f $file\.tmp
done

#if [ -s ./README.md ]; then
	#echo "make soft linke $pwd/README.md <-- ./build_doxygen/src/README.md"
	#ln -sf $pwd/work/README.md ./build_doxygen/src/README.md
#fi
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"

tput setaf 5
echo "### Source Files for making a doxygen : ls ./build_doxygen/src/ ####"
tput sgr0
ls ${lsOption} ./build_doxygen/src/

cd build_doxygen; make ; cd ..
cd build_uml; make ; cd ..
cd build_perlmod; make ; cd ..
