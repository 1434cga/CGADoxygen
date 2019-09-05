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

# https://linuxconfig.org/how-to-use-arrays-in-bash-script
declare -a my_pids

echo "help : $0 [CPU count : default 4]"

cpucnt=`cat /proc/cpuinfo | awk '/^processor/{print $3}' | wc -l`

mkdir -p oldplantuml
tput setaf 2
echo "#### Check Differnce of plantuml files : cup count ${cpucnt} ####"
tput sgr0

if [ -z "$1" ]; then
    bgmax=$(((cpucnt / 3) * 2))
    #bgmax=4
else 
    bgmax=$1
fi

fgmax=$((bgmax + 1))
num=0

tput setaf 2
echo "#### Background Max : ${bgmax}  , Foreground Max : ${fgmax} ####"
tput sgr0

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
                pid=$!;
                my_pids[$num]=$pid
                num=$((num + 1))
                if [ ${num} -eq ${bgmax} ]; then        # we do not have any foreground jobs for this block
                    tput setaf 2
                    echo "pid list... : ${my_pids[@]}"
                    for pid in "${my_pids[@]}"          # Print the values of an array
                    do 
                        echo "Waiting pid ... : ${pid}"
                        wait ${pid}
                    done
                    tput sgr0
                    for index in "${!my_pids[@]}"       # Print the keys of an array
                    do 
                        #echo "${index}"
                        unset my_pids[$index]
                    done
                    num=0
                fi
            else
                tput setaf 2
                echo "pid list... : ${my_pids[@]}"
                for pid in "${my_pids[@]}"
                do 
                    echo "Waiting pid ... : ${pid}"
                    wait ${pid}
                done
                tput sgr0

			    tput setaf 3
                echo "--> foreground ${num} ${bgmax} ${fgmax} $file changed : plantuml.jar -> png "
			    tput sgr0
                java -jar ../../build_doxygen/plantuml.jar $file

                num=0

: <<'END_COMMENT'
                if [ ${num} -lt ${fgmax} ]; then
                    num=$((num + 1))
                else
                    num=0
                fi
			    tput setaf 3
                echo "--> foreground ${num} ${bgmax} ${fgmax} $file changed : plantuml.jar -> png "
			    tput sgr0
                java -jar ../../build_doxygen/plantuml.jar $file
END_COMMENT
            fi
			/bin/cp -f $file ../oldplantuml
		else
			tput setaf 4
			echo "--- $file unchanged"
			tput sgr0
		fi
	fi
done

tput setaf 2
echo "final waiting pid list... : ${my_pids[@]}"
for pid in "${my_pids[@]}"
do 
    echo "Final waiting pid ... : ${pid}"
    wait ${pid}
done
tput sgr0

: <<'END_COMMENT'
if [ ${num} -lt ${bgmax} ]; then
    slp=$((num/2 + 2))
    echo "sleep  ${slp}"
    sleep ${slp}
fi
END_COMMENT

