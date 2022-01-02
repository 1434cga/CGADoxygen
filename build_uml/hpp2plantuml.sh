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

mkdir -p UML
mkdir -p old
tput setaf 2
echo "#### Check Differnce of Header files for hpp2plantuml####"
tput sgr0

tput setaf 3
echo "--> overall information : hpp2plantuml -> UML/__ALL__.class "
tput sgr0
cat src/*.h  > ./old/__ALL__.h
hpp2plantuml -i ./old/__ALL__.h | sed "s/@startuml//" | sed "s/@enduml//" > ./UML/__ALL__.class

for file in src/*.h
do
	if [ -s $file ]; then
		basefile=`basename $file`
		echo "diff -q $file old/$basefile"
		diff -q $file old/$basefile
		if [ $? -ne '0' ]; then
			tput setaf 3
			echo "--> $file changed : hpp2plantuml -> UML/${basefile}.uml "
			tput sgr0
			hpp2plantuml -i ${file} | sed "s/@startuml//" | sed "s/@enduml//" > UML/${basefile}.uml
			/bin/cp -f ${file} old/${basefile}
		else
			tput setaf 4
			echo "--- $file unchanged"
			tput sgr0
		fi
	fi
done

