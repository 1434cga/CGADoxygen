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

mkdir -p ../old
dodoxy='0'
if [ -d "./DOXYGEN_OUTPUT" ]; then
    tput setaf 2
    echo "#### Check Differnce of doxygen ####"
    tput sgr0
	for file in src/* 
	do
		if [ -s $file ]; then
			basefile=`basename $file`
			echo "diff -q $file ../old/$basefile"
			diff -q $file ../old/$basefile
			if [ $? -ne '0' ]; then
				tput setaf 3
				echo "--> $file changed"
				tput sgr0
				dodoxy='1'
			fi
		fi
	done
	if [ $dodoxy -eq '1' ]; then
		/bin/rm -f ../old/*
		/bin/cp -f ./src/* ../old
		tput setaf 2
		echo "#### Run Doxygen ####"
		tput sgr0
        echo "Reuse DOXYGEN_OUTPUT" > doxygen.log
		doxygen Doxyfile >> doxygen.log
	else
		tput setaf 2
		echo "#### All files are same. ####"
		echo "#### if you run manually , run make after make clean ####"
		tput sgr0
	fi
else
    tput setaf 2
    echo "#### Run Doxygen ####"
    tput sgr0
    echo "New DOXYGEN_OUTPUT" > doxygen.log
	doxygen Doxyfile >> doxygen.log
	/bin/cp -f ./src/* ../old
fi

