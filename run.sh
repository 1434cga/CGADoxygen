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

tput setaf 2
echo "#### Make soft links in src ####"
tput sgr0

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

