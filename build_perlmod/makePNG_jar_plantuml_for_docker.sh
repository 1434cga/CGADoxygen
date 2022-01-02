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

mkdir -p oldplantuml
tput setaf 2
echo "#### Check Differnce of plantuml files ####"
tput sgr0

bgmax=8
fgmax=10
num=0

cd outplantuml

for file in *.plantuml
do
	basefile=`basename $file`
	#echo "    basefile : $basefile  ,  file : $file"
	if [ -s $file ]; then
		echo "diff -q $file ../oldplantuml/$file"
		diff -q $file ../oldplantuml/$file
		if [ $? -ne '0' ]; then
            if [ ${num} -lt ${bgmax} ]; then
			    tput setaf 3
                echo "--> background ${num} ${bgmax} ${fgmax} $file changed : plantuml.jar -> png "
			    tput sgr0
                java -jar ../../build_doxygen/plantuml.jar $file  &
                num=$((num + 1))
            else
                if [ ${num} -lt ${fgmax} ]; then
                    num=$((num + 1))
                else
                    num=0
                fi
			    tput setaf 3
                echo "--> foreground ${num} ${bgmax} ${fgmax} $file changed : plantuml.jar -> png "
			    tput sgr0
                java -jar ../../build_doxygen/plantuml.jar $file
            fi
			/bin/cp -f $file ../oldplantuml
		else
			tput setaf 4
			echo "--- $file unchanged"
			tput sgr0
		fi
	fi
done

