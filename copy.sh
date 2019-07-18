#!/bin/sh

# $1 : SOURCE DIRECTORY  : This directory has a lot of files and directories
# $2 : DESTINATION STORAGE without inner directory


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

#tput setaf 4
#tput sgr0


echo "help : $0 [SOURCE DIRECTORY] [DESTINATION STORAGE Name]"

if [ -d "$1" ]; then
    tput setaf 2
    echo "source directory : $1"
    tput sgr0
else
    tput setaf 3
    echo $1 is not exist
    tput sgr0
    exit 1
fi

echo "detination directory : $2"
mkdir -p $2


for i in `find . -type f -regex ".*/.*\.\(c\|md\|mdpp\|cpp\|h\|cc\)$"  -print`
do
    echo $i
    BN=`basename ${i}`
    tput setaf 2
    echo "#### filename : ${i}  , target : $2 , basename :${BN} ####"
    tput sgr0
    echo "cp -f ${i}   $2/${BN}" 
    cp -f ${i}   $2/${BN} 
done
