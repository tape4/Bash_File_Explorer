#!bin/bash

# GwangWoon University. 2019203032. Jeong Hoon Lee

# Declare of colors
declare BlackText='[30;47m'  # Text-black Background-gray
declare Background='[47m'    # 	    Background-gray
declare Title='[30;46m'      # Text-black Backgounrd-blue
declare BlueText='[34;47m'   # Text-blue  Background-gray
declare GreenText='[32;47m'  # Text-green Background-gray
declare ClearColor='[0m'     # set default 
declare CursorColor='[0;43m' # Text-white Background-Yellow

# Declare for cursor
declare -i cursor=0            # moving cursor 1~20
declare -i count=0	       # count for limit 20

# Dec;are for information
declare -a dirName # insert directory name sorted by name
declare -a exeName # insert executable file name  sorted by name
declare -a otrName # insert else file name sorted by name

# declare -i TreeX
# declare -i TreeY
# declare -a Bridge=('|' '├' '└')


# Draw Tree 
:<<END
function DrawTree() { #$1 Must directory  #$2 Xpos  #$3 Ypos
	TreeX=$2; TreeY=$3;
	
	TreeX=TreeX+1; 
	TreeY=TreeY+1;
	
	tput cup $TreeX $TreeY
	echo "${BlueText}${PWD##*/}${ClearColor}"

	for files in $1/*;
	do
		if [ -x "$files" ]; then
			TreeX=TreeX+1;
			echo "${BlackText}${Bridge[1]}${ClearColor}"
			TreeY=TreeY+1;
			echo "${BlackText}${files}${ClearColor}"
		fi
	done
}

	TreeX=$2; TreeY=$3;
	declare -i NumberOfbar=0
	tput cup $TreeX $TreeY
	
	echo "${BlueText}${PWD##*/}${ClearColor}"
	TreeX=TreeX+1 
	
	for ((i=0; i<"${#dirName[@]}"; i++))
	do
		if [ -d ${dirName[i]} ] && [ "${dirName[i]}" = "." ] && [ "${dirName[i]}" = ".." ]; then
			tput cup $TreeX $TreeY
			echo "${BlackText}${Bridge[1]}${ClearColor}"
	
			DrawTree ${dirNam[i]} $TreeX $TreeY
		fi
	done

END

# Main function
function Main() {
	while [ true ] # infinite loop
	do
		DrawUI  
		declare -i max=count-1 
		read -n 3 key
			if [ "$key" = [A ] && [ $cursor -ne 0 ]; then        # up
				cursor=cursor-1
			elif [ "$key" = [B ] && [ $cursor -lt $max ]; then   # down
				cursor=cursor+1    
	#		elif [ "$key" = [C ]; then 			       # right
	#			break;
	#		elif [ "$key" = [D ]; then                           # left
	#			break;
			elif [ -z ${key} ]; then                               # enter
				if [ -d ${PWD}/${dirName[$cursor]} ]; then     
					cd ${PWD}/${dirName[$cursor]}          # move to /target
					cursor=0
				fi
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
		echo "${BlackText}-----------------------------------------------------------------------------------"
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
	declare -i expcur=cursor+4
	tput cup $expcur 1
	echo "${CursorColor}$(Blank 40)${ClearColor}"



	Explorer
	#DrawTree ${PWD} 3 41
	Under
	tput cup 27 0
}

function Under() {  # print Number of Fils, Directories and size of current Directory size
	NumberOfDir=`ls -al ${PWD} | grep "^d" | wc -l`
	NumberOfDir=`expr $NumberOfDir - 2`
	NumberOfFiles=`ls -al ${PWD} | grep "^-" | wc -l`
	CurrentDirSize=`du -sh | awk '{print $1}'`
	tput cup 25 6
	echo "${BlackText}Directory : ${NumberOfDir}${ClearColor}"
	tput cup 25 26
	echo "${BlackText}File : ${NumberOfFiles}${ClearColor}" 
	tput cup 25 44 
	echo "${BlackText}Current Directory Size : ${CurrentDirSize}${ClearColor}"
}

function Explorer() {  # print File Explorer
	unset EveryFileName; unset EveryFilePerm; unset EveryFileSize
	unset dirName; unset dirPerm; unset dirSize;
	unset exeName; unset exePerm; unset exeSize;
	unset otrName; unset otrSize; unset otrSize;
	
 	declare -a EveryFileName=(`ls -ahl ${PWD} | sort -k 9 | awk '{print $9}'`) #insert every file name of this dir. sorted by name
	declare -a EveryFilePerm=(`ls -ahl ${PWD} | sort -k 9 | awk '{print $1}'`) #insert every file permission of this dir. sorted by name
	declare -a EveryFIleSize=(`ls -ahl ${PWD} | sort -k 9 | awk '{print $5}'`) 

	declare -a dirPerm # insert dirName's permission
	declare -a dirSize # insert dirName's size
		
	declare -a exePerm # insert exeName's permission		
	declare -a exeSize # insert exeName's size

	declare -a otrPerm # insert otrName's permission
	declare -a otrSize # insert otrNmae's size
	
	# get information using "ls -ahl"
	for ((i=0; i<${#EveryFileName[@]}; i++))
	do
		if [ -d "${PWD}/${EveryFileName[i]}" ]; then  # if EveryFileName[i] means directory
			dirName+=(${EveryFileName[i]})
			dirPerm+=(${EveryFilePerm[i+1]})    # according to "sum" need to + 1
			dirSize+=(${EveryFIleSize[i]}) 	
		
		elif [ -x "${PWD}/${EveryFileName[i]}" ]; then # if EveryFileName[i] means executable file
			exeName+=(${EveryFileName[i]})
			exePerm+=(`ls -ahl ${PWD}/${EveryFileName[i]} | awk '{print $1}'`)
			exeSize+=(`ls -ahl ${PWD}/${EveryFileName[i]} | awk '{print $5}'`) 	
		
		else
			otrName+=(${EveryFileName[i]}) # else
			otrPerm+=(`ls -ahl ${PWD}/${EveryFileName[i]} | awk '{print $1}'`)
			otrSize+=(`ls -ahl ${PWD}/${EveryFileName[i]} | awk '{print $5}'`) 	
		fi			
	done
	
	
	# Start write
	tput cup 4 1
	count=0  # For max info (20)
	declare -i StartExplorerX=4  # xPos

	#left File Name start
	for ((i=0; i<${#dirName[@]}; i++))
	do
		if [ $count -eq 20 ]; then
			break;	
		fi
		tput cup $StartExplorerX 1
		if [ $count -eq $cursor ]; then
			echo "${CursorColor}${dirName[i]}${ClearColor}"
		else
			echo "${BlueText}${dirName[i]}${ClearColor}"
		fi
		StartExplorerX=StartExplorerX+1
		count=count+1
	done
	
	
	for ((i=0; i<${#exeName[@]}; i++))
	do
		if [ $count -eq 20 ]; then
			break;	
		fi
		tput cup $StartExplorerX 1
		if [ $count -eq $cursor ]; then
			echo "${CursorColor}${exeName[i]}${ClearColor}"
		else
			echo "${GreenText}${exeName[i]}${ClearColor}"
		fi
		StartExplorerX=StartExplorerX+1
		count=count+1
	done

	for ((i=0; i<${#otrName[@]}; i++))
	do
		if [ $count -eq 20 ]; then
			break;
		fi
		tput cup $StartExplorerX 1
		if [ $count -eq $cursor ]; then
			echo "${CursorColor}${otrName[i]}${ClearColor}"
		else
			echo "${BlackText}${otrName[i]}${ClearColor}"
		fi
		StartExplorerX=StartExplorerX+1
		count=count+1
	done
	#left File Name finish

	count=0; StartExplorerX=4;   # clear var

	#center File Permission start
	for ((i=0; i<${#dirPerm[@]}; i++))
	do
		if [ $count -eq 20 ]; then
			break;	
		fi
		tput cup $StartExplorerX 18
		if [ $count -eq $cursor ]; then
			echo "${CursorColor}${dirPerm[i]}${ClearColor}"
		else
			echo "${BlueText}${dirPerm[i]}${ClearColor}"
		fi
		StartExplorerX=StartExplorerX+1
		count=count+1
	done
	
	
	for ((i=0; i<${#exePerm[@]}; i++))
	do
		if [ $count -eq 20 ]; then
			break;	
		fi
		tput cup $StartExplorerX 18
		if [ $count -eq $cursor ]; then
			echo "${CursorColor}${exePerm[i]}${ClearColor}"
		else
			echo "${GreenText}${exePerm[i]}${ClearColor}"
		fi
		StartExplorerX=StartExplorerX+1
		count=count+1
	done

	for ((i=0; i<${#otrPerm[@]}; i++))
	do
		if [ $count -eq 20 ]; then
			break;
		fi
		tput cup $StartExplorerX 18
		if [ $count -eq $cursor ]; then
			echo "${CursorColor}${otrPerm[i]}${ClearColor}"
		else
			echo "${BlackText}${otrPerm[i]}${ClearColor}"
		fi
		StartExplorerX=StartExplorerX+1
		count=count+1
	done
	# center File Permission finish

	count=0; StartExplorerX=4;  # clear var

	# right File Size start
	for ((i=0; i<${#dirSize[@]}; i++))
	do
		if [ $count -eq 20 ]; then
			break;	
		fi
		
		if [ "${dirName[i]}" = "." ] || [ "${dirName[i]}" = ".." ]; then 
		dirSize[i]="-"; 		
		fi
		
		tput cup $StartExplorerX 35
		if [ $count -eq $cursor ]; then
			echo "${CursorColor}${dirSize[i]}${ClearColor}"
		else
			echo "${BlueText}${dirSize[i]}${ClearColor}"
		fi
		StartExplorerX=StartExplorerX+1
		count=count+1
	done
	
	
	for ((i=0; i<${#exeSize[@]}; i++))
	do
		if [ $count -eq 20 ]; then
			break;	
		fi
		tput cup $StartExplorerX 35
		if [ $count -eq $cursor ]; then
			echo "${CursorColor}${exeSize[i]}${ClearColor}"
		else
			echo "${GreenText}${exeSize[i]}${CleaerColor}"
		fi
		StartExplorerX=StartExplorerX+1
		count=count+1
	done

	for ((i=0; i<${#otrSize[@]}; i++))
	do
		if [ $count -eq 20 ]; then
			break;
		fi
		tput cup $StartExplorerX 35
		if [ $count -eq $cursor ]; then
			echo "${CursorColor}${exeSize[i]}${ClearColor}"
		else
			echo "${BlackText}${otrSize[i]}${ClearColor}"
		fi
		StartExplorerX=StartExplorerX+1
		count=count+1
	done
	#right File Size finish

}

Main
