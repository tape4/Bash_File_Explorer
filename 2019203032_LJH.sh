#!bin/bash
# Author : 2019203032 Jeong Hoon Lee

# Declare of colors
declare BlackText='[30;47m'   # Text-black  Background-gray
declare Background='[47m'     # 			Background-gray
declare Title='[30;46m'       # Text-black  Backgounrd-blue
declare BlueText='[34;47m'    # Text-blue   Background-gray
declare GreenText='[32;47m'   # Text-green  Background-gray
declare ClearColor='[0m'      # set default 
declare CursorColor='[0;43m'  # Text-white  Background-Yellow
declare GCursorColor='[0;42m' # Text-white  Background-Green
declare RedText='[31;47m'	   # Text-Red	Background-gray

unset temp; unset temp2; unset temp5;
# Declare for cursor
declare -i cursor            # cursor should be 1~20
declare -i LRcursor			 # for moving cursor LR 1: Left -1: Right
declare -i startNum			 # for print 20 (L)
declare -i startNum2		 # for print 20 (R)
# Declare for information
declare -a dirName 			# insert directory name sorted by name
declare -a cName 			# insert executable file name  sorted by name
declare -a hName 			# insert else file name sorted by name
declare -a EveryFileName	# insert left field information
declare -a EveryMakeFile	# insert right field information
declare mainMake			# .c file what have int main()
declare -a cMake			# .c files (mainMake doesn't here)
declare -a hMake			# .h files
declare -i temp				# index of left field
declare -i temp5			# index of right field

# Main function
function Main() {
	unset mainMake; unset EveryMakeFile; 
	unset cMake; unset hMake;
	cd ~
	declare -i Maxofstart=0;
	declare -i Maxofstart2=0;
	cursor=1; startNum=0; startNum2=0; LRcursor=1;

	while [ true ] # infinite loop
	do
		DrawUI  
		Maxofstart=${#EveryFileName[@]}-20;
		Maxofstart2=${#EveryMakeFile[@]}-20;
		temp=$cursor+$startNum-1
		temp5=$cursor+$startNum2-1
		temp2=`grep -r 'int main()' ./${EveryFileName[$temp]}`
		
		if [ $LRcursor -eq -1 ]; then
			read -n 3 -d "d" key
		else
			read -n 3 key
		fi
			if [ "$key" = [A ]; then	# up
				if [ $cursor -gt 1 ]; then
					cursor=cursor-1
				elif [ $cursor -eq 1 ] ; then	
					if [ $startNum -eq 0 ] && [ $LRcursor -eq 1 ]; then 
						if [ ${#EveryFileName[@]} -lt 20 ]; then
							cursor=${#EveryFileName[@]} 
						else
							cursor=20
							startNum=Maxofstart
						fi
					elif [ $startNum -ne 0 ] && [ $LRcursor -eq 1 ]; then	
						startNum=startNum-1
					elif [ $startNum2 -eq 0 ] && [ $LRcursor -eq -1 ]; then
						if [ ${#EveryMakeFile[@]} -lt 20 ]; then
							if [ ${#EveryMakeFile[@]} -gt 0 ]; then
								cursor=${#EveryMakeFile[@]} 
							else
								cursor=1
							fi
						else
							cursor=20
							startNum2=Maxofstart2
						fi
					elif [ $startNum2 -ne 0 ] && [ $LRcursor -eq -1 ]; then	
						startNum2=startNum2-1
					fi
				fi
			
			elif [ "$key" = [B ]; then   # down
				if [ $LRcursor -eq 1 ]; then
					if [ $cursor -lt 20 ] && [ $cursor -lt ${#EveryFileName[@]} ]; then	# if cursor != 20 and cursor > number of file
						cursor=cursor+1
					elif [ $cursor -eq 20 ] && [ $startNum -lt $Maxofstart ] && [ $Maxofstart -gt 0 ]; then	# if cursor == 20
						startNum=startNum+1
					elif [ $cursor -eq 20 ] || [ $cursor -eq ${#EveryFileName[@]} ]; then
						cursor=1
						if [ $startNum -eq $Maxofstart ]; then
							startNum=0
						fi
					fi
				elif [ $LRcursor -eq -1 ]; then
					if [ $cursor -lt 20 ] && [ $cursor -lt ${#EveryMakeFile[@]} ]; then	# if cursor != 20 and cursor > number of file
						cursor=cursor+1
					elif [ $cursor -eq 20 ] && [ $startNum2 -lt $Maxofstart2 ] && [ $Maxofstart2 -gt 0 ]; then	# if cursor == 20
						startNum2=startNum2+1
					elif [ $cursor -eq 20 ] || [ $cursor -eq ${#EveryMakeFile[@]} ]; then
					cursor=1
						if [ $startNum2 -eq $Maxofstart2 ]; then
						startNum2=0
						fi
					fi
				fi

			elif [ "$key" = [C ] || [ "$key" = [D ]; then	# right or left
				if [ ${#EveryMakeFile[@]} - gt 0]; then
					LRcursor=-LRcursor
				fi
				if [ $cursor -gt ${#EveryMakeFile[@]} ] && [ ${#EveryMakeFile[@]} -gt 0 ]; then
					cursor=${#EveryMakeFile[@]}
				fi

			elif [ -z ${key} ] && [ $LRcursor -eq 1 ]; then	# enter
				if [ -d ${PWD}/${EveryFileName[$temp]} ]; then     
					cd ${PWD}/${EveryFileName[$temp]}	# move to /target
					cursor=1
					startNum=0
					#unset EveryMakeFile ; unset cMake; unset hMake; unset mainMake;
				elif [ -f ./${EveryFileName[$temp]} ] && [[ $temp2 =~ "int main()" ]]; then
					mainMake=${EveryFileName[$temp]}
				elif [ -f ./${EveryFileName[$temp]} ] && [[ ${EveryFileName[$temp]} =~ ".c" ]]; then	# if c files
					temp4=`isIn cMake[@] ${EveryFileName[$temp]}`
					if [ $temp4 -eq -1 ]; then
						cMake+=(${EveryFileName[$temp]})
					fi
				elif [ -f ./${EveryFileName[$temp]} ] && [[ ${EveryFileName[$temp]} =~ ".h" ]]; then	# if h files
					temp4=`isIn hMake[@] ${EveryFileName[$temp]}`
					if [ $temp4 -eq -1 ]; then
						hMake+=(${EveryFileName[$temp]})
					fi
				fi
			elif [ -z ${key} ] && [ $LRcursor -eq -1 ]; then # if press "d" at Right
				temp2=`grep -r 'int main()' ./${EveryMakeFile[$temp5]}`
				if [[ $temp2 =~ "int main()" ]]; then
					unset mainMake
				elif [[ ${EveryMakeFile[$temp5]} =~ ".c" ]]; then
					for i in ${!cMake[@]}
					do
						if [ ${cMake[i]} = ${EveryMakeFile[$temp5]} ]; then
							unset cMake[i]:
							break;
						fi
					done
					for i in ${!cMake[@]}
					do
						temp_arr+=( "${cMake[i]}" )
					done
					cMake=("${temp_arr[@]}")
					unset temp_arr

				elif [[ ${EveryMakeFile[$temp5]} =~ ".h" ]]; then
					for i in ${!hMake[@]}
					do
						if [ ${hMake[i]} = ${EveryMakeFile[$temp5]} ]; then
							unset hMake[i]:
							break;
						fi
					done
					for i in ${!hMake[@]}
					do
						temp_arr+=( "${hMake[i]}" )
					done
					hMake=("${temp_arr[@]}")
					unset temp_arr
				fi
				if [ ${#EveryMakeFile[@]} -gt 1 -a ${#EveryMakeFile[@]} -le 20 ]; then
					cursor=cursor-1
				elif [ ${startNum2} -ne 0 ]; then
					startNum2=startNum2-1
				fi
			elif [ "${key[0]}" = "m" ] && [ $LRcursor -eq 1 ] && [ -n "${mainMake}" ]; then # "m" + Enter
				MakeMakefile 
				clear
				break;
			else 
				continue:
			fi
	done
}


function Blank() { # make Blank function   $1 is number of blanks
	for ((i=0;i<$1;i++))
	do
		echo -n " "
	done
}

function MakeMakefile() { # make makefile
	new_arr+=("${mainMake:0:-2}.o")
	for (( i=0; i<${#cMake[@]}; i++ ))
	do
		new_arr+=("${cMake[i]:0:-2}.o")
		echo "${new_arr[i]}"
	done

	rm makefile
	touch makefile
	#temp_arr+=("${mainMake:0:-2}.o")
	#temp_arr+=("${new_arr[@]}")
	echo "OBJF = "${new_arr[@]}"" >> ./makefile
	unset temp_arr

	echo "2019203032.out : \$(OBJF)" >> ./makefile
	echo -e "\tgcc $^ -o \$@"  >> ./makefile
	for (( i=0; i<${#new_arr[@]}; i++ ))
	do
		for (( j=0; j<${#hMake[@]}; j++ ))
		do
			temp2=`grep -r "#include \"${hMake[j]}\"" ./${new_arr[i]:0:-2}.c`
			if [[ $temp2 =~ ${hMake[j]} ]]; then
				temp_arr+=("${hMake[j]}")
			fi
		done
		echo "${new_arr[i]} : ${new_arr[i]:0:-2}.c ${temp_arr[@]}" >> ./makefile
		echo -e "\tgcc -c $<" >> ./makefile
		unset temp_arr
	done

	echo "clean :" >> ./makefile
	echo -e "\trm -f *.o" >> ./makefile

	unset new_arr
}

function DrawUI() {  # draw UI
	clear
	# draw title
	tput cup 0 0 
	echo "${Title}File Explorer$(Blank 70)${ClearColor}"   # Background-color blue , gray


	for ((i=1;i<27;i++))
	do
		tput cup $i 0
		echo "${Background}$(Blank 83)${ClearColor}"   # Make every tiles gray using blank
	done

	for i in 1 3 24 26
	do
		tput cup $i 0
		for (( j=0; j<83; j++ ))
		do
			echo -n "${BlackText}-"
		done
	done

	for ((i=2; i<26;i++))   # left right line
	do
		for j in 0 82
		do
			if [ ${i} -ne 3 ] && [ ${i} -ne 24 ]
			then
				tput cup $i $j
				echo "|"
			fi
		done
	done

	for ((i=4; i< 24; i++))   # center line
	do
		tput cup $i 41
		echo "|"
	done

	# print current path
	tput cup 2 1
	echo "${BlackText}Current path: `pwd`${ClearColor}"

	# coloring cursor 
	declare -i expcur=cursor+3

	if [ $LRcursor -gt 0 ]; then  # LEFT
		tput cup $expcur 1
		echo "${CursorColor}$(Blank 40)${ClearColor}"
	else							# RIGHT
		tput cup $expcur 42
		echo "${GCursorColor}$(Blank 40)${ClearColor}"
	fi

	Explorer
	Source
	Under
	tput cup 27 0
}

function isIn() {	 #$1 is array $2 is target
	declare -i temp3=-1
	for i in ${!1}
	do
		if [ $i = $2 ]; then
			temp3=1
			break;
		fi
	done
	echo "$temp3"
}

function Under() {  # print Number of .c .h
	NumberOfc=`ls -al ${PWD} | grep "^-.*\.c" | wc -l`
	NumberOfh=`ls -al ${PWD} | grep "^-.*\.h" | wc -l`
	tput cup 25 6
	echo "${BlackText}C Files : ${NumberOfc}${ClearColor}"
	tput cup 25 26
	echo "${BlackText}Header : ${NumberOfh}${ClearColor}"
}

function Explorer() {  # print File Explorer (Left Field)
	unset EveryFileName; unset EveryFilePerm; unset EveryFileSize
	unset dirName; unset dirPerm; unset dirSize;
	unset cName; unset cPerm; unset cSize;
	unset hName; unset hSize; unset hSize;
	
	declare -a EveryFilePerm
	declare -a EveryFileSize
	 
	dirName+=(`ls -ahl ${PWD} | sort -k 9 | grep "^d" | awk '{print $9}'`)
	declare -a dirPerm=(`ls -ahl ${PWD} | sort -k 9 | grep "^d" | awk '{print $1}'`) # insert dirName's permission
	declare -a dirSize=(`ls -ahl ${PWD} | sort -k 9 | grep "^d" | awk '{print $5}'`) # insert dirName's size
		
	cName=(`ls -ahl ${PWD} | sort -k 9 | grep "^-.*\.c" | awk '{print $9}'`)
	declare -a cPerm=(`ls -ahl ${PWD} | sort -k 9 | grep "^-.*\.c" | awk '{print $1}'`) # insert cName's permission		
	declare -a cSize=(`ls -ahl ${PWD} | sort -k 9 | grep "^-.*\.c" | awk '{print $5}'`) # insert cName's size

	hName=(`ls -ahl ${PWD} | sort -k 9 | grep "^-.*\.h" | awk '{print $9}'`)
	declare -a hPerm=(`ls -ahl ${PWD} | sort -k 9 | grep "^-.*\.h" | awk '{print $1}'`) # insert hName's permission
	declare -a hSize=(`ls -ahl ${PWD} | sort -k 9 | grep "^-.*\.h" | awk '{print $5}'`) # insert hNmae's size
	
	for (( i=0; i<${#dirName[@]}; i++ ))
	do
		EveryFileName+=(${dirName[i]}); EveryFilePerm+=(${dirPerm[i]}); EveryFileSize+=(${dirSize[i]});
	done

	for (( i=0; i<${#cName[@]}; i++ ))
	do
		EveryFileName+=(${cName[i]}); EveryFilePerm+=(${cPerm[i]}); EveryFileSize+=(${cSize[i]});
	done

	for (( i=0; i<${#hName[@]}; i++ ))
	do
		EveryFileName+=(${hName[i]}); EveryFilePerm+=(${hPerm[i]}); EveryFileSize+=(${hSize[i]});
	done

	# Start write
	tput cup 4 1 
	declare -i xPos=4  # xPos
	declare -i cur=cursor+3

	for (( i=${startNum}; i<${startNum}+20; i++ ))
	do
		if [ $cur -eq $xPos ] && [ $LRcursor -gt 0 ]; then
			tput cup $xPos 1
			echo "${CursorColor}${EveryFileName[i]}"
			tput cup $xPos 18
			echo "${EveryFilePerm[i]}"
			tput cup $xPos 35
			echo "${EveryFileSize[i]}${ClearColor}"
		else
			if [ -d "${PWD}/${EveryFileName[i]}" ]; then	# if directory
				tput cup $xPos 1
				echo "${BlueText}${EveryFileName[i]}"
				tput cup $xPos 18
				echo "${EveryFilePerm[i]}"
				tput cup $xPos 35
				echo "${EveryFileSize[i]}${ClearColor}"
			elif [[ "${EveryFileName[i]}" =~ ".c" ]]; then	# if .c files
				tput cup $xPos 1
				echo "${GreenText}${EveryFileName[i]}"
				tput cup $xPos 18
				echo "${EveryFilePerm[i]}"
				tput cup $xPos 35
				echo "${EveryFileSize[i]}${ClearColor}" 
			else	# if .h files
				tput cup $xPos 1
				echo "${BlackText}${EveryFileName[i]}"
				tput cup $xPos 18
				echo "${EveryFilePerm[i]}"
				tput cup $xPos 35
				echo "${EveryFileSize[i]}${ClearColor}"
			fi
		fi
		xPos=xPos+1
	done
	
}

function Source() { # print What to make (Right Field)
	unset EveryMakeFile; #unset cMake; unset hMake; sunset mainMake;

	declare -i xPos2=4  # xPos
	declare -i cur2=cursor+3

	EveryMakeFile+=($mainMake)
	EveryMakeFile+=(${cMake[@]})
	EveryMakeFile+=(${hMake[@]})

	for (( i=${startNum2}; i<${startNum2}+20; i++ ))
	do
		if [ $cur2 -eq $xPos2 ] && [ $LRcursor -lt 0 ]; then
			tput cup $xPos2 42
			echo "${GCursorColor}${EveryMakeFile[i]}"
		else
			if [ "${EveryMakeFile[i]}" = "${mainMake}" ]; then
				tput cup $xPos2 42
				echo "${RedText}${EveryMakeFile[i]}"

			elif [[ "${EveryMakeFile[i]}" =~ ".c" ]]; then	# if .c files
				tput cup $xPos2 42
				echo "${GreenText}${EveryMakeFile[i]}"
			else											# if .h files
				tput cup $xPos2 42
				echo "${BlackText}${EveryMakeFile[i]}"
			fi
		fi
		xPos2=xPos2+1
	done
}

Main
