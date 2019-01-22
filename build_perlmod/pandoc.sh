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

#pandoc -o MgrTelltale.docx -f markdown -t docx MgrTelltale.md
#pandoc -o SDD.docx -f markdown -t docx SDD.md
#pandoc -o MgrTelltale4OEM.docx -f markdown -t docx MgrTelltale4OEM.md

mkdir -p oldmd

cd OUTPUT

tput setaf 2
echo `pwd`
echo "#### Check Differnce of md files for pandoc ####"
tput sgr0

file='LLD.md'
echo "diff -q $file ./oldmd/$file"
diff -q $file ./oldmd/$file
if [ $? -ne '0' ]; then
	tput setaf 3
	echo "--> $file changed : pandoc -o LLD.docx -f markdown -t docx $file"
	tput sgr0
	pandoc -o LLD.docx -f markdown -t docx $file
	/bin/cp -f $file ./oldmd
else
	tput setaf 4
	echo "--- $file unchanged : pandoc"
	tput sgr0
fi

file='HLD.md'
echo "diff -q $file ./oldmd/$file"
diff -q $file ./oldmd/$file
if [ $? -ne '0' ]; then
	tput setaf 3
	echo "--> $file changed : pandoc -o HLD.docx -f markdown -t docx $file"
	tput sgr0
	pandoc -o HLD.docx -f markdown -t docx $file
	/bin/cp -f $file ./oldmd
else
	tput setaf 4
	echo "--- $file unchanged : pandoc"
	tput sgr0
fi

file='SDD.md'
echo "diff -q $file ./oldmd/$file"
diff -q $file ./oldmd/$file
if [ $? -ne '0' ]; then
	tput setaf 3
	echo "--> $file changed : pandoc -o SDD.docx -f markdown -t docx $file"
	tput sgr0
	pandoc -o SDD.docx -f markdown -t docx $file
	/bin/cp -f $file ./oldmd
else
	tput setaf 4
	echo "--- $file unchanged : pandoc"
	tput sgr0
fi

