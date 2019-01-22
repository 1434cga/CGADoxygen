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
echo "####  plantuml.md -> md ####"
tput sgr0
cd work
for file in *.plantuml.md
do
    echo $file
    basefile=`basename $file`
    removelast=$(basename ${file%.*})
    name=`rev <<< "$file" | cut -d"." -f3- | rev`
    echo "basefile=$basefile removelast=$removelast name=$name"
    perl ../plantuml2fileInMarkdown.pl ${file} ${name}.md
done

