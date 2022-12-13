#!/bin/bash

variableDec(){

read -p '.img file Name: ' imgName
read -p 'Mount point Path: ' mountPath


if [[ -z "$imgName" ]]
then
    echo Img Name is empty
elif [[ ! -f "$imgName" ]]
then
	echo Img Does not exist
fi


if [[ -z "$mountPath" || ! -e "$mountPath" ]]
then
	read -p 'No mount Path Detected, please enter name of mounting point you want to create: ' mountName
	if [[ ! -z "$mountName" ]]
	then 
		mkdir $mountName
		mountPath=$mountName	
	elif [[ -z "$mountName" ]]
	then
		echo Mount path Name is empty
		exit
	fi
fi 

mounting
 
}

mounting(){
if findmnt "$mountPath" > "/dev/null"
then
	echo File is already mounted
	touch filedata.txt
	extract
else
	echo Mounting IMG file now...
	sudo mount -o loop,offset=1048576  $imgName $mountPath
	touch filedata.txt
	extract
fi
}

extract(){
	read -p 'File you want to extract from: ' extractFile
	if [[ -z extractFile || -e extractFile ]]
	then
		echo File does not exist or input is empty
		extract
	else
		sudo tar cf extract.tar image$extractFile
		mkdir extractedData
		sudo tar xf extract.tar -C extractedData
		find image$extractFile -printf "%p;%s;%Ar %Ax;%Tr %Tx;%M;%U;%G;\n" >> filedata.txt
		sudo rm -dr extractedData
		sudo rm -dr extract.tar
		echo Data extracted to filedata.txt
		read -p 'Do you want to extract from another file? [y/n] ' recurse
		if [[ "$recurse" = "y" ]]
		then
			extract
		else
			echo Creating SQL Database:
			mysql -u root -p >sqlout.txt<<E0F 
			CREATE DATABASE KF4005A;
			USE KF4005A;
			CREATE TABLE filedata (name VARCHAR(100), size INT, adate VARCHAR(100), cdate VARCHAR(100), permission VARCHAR(100), gID INT, uID INT);
			LOAD DATA LOCAL INFILE 'filedata.txt' INTO TABLE filedata FIELDS TERMINATED BY ';';
			SELECT * FROM filedata 
			ORDER BY adate;
			DROP DATABASE KF4005A;
E0F
			exit
		fi
	fi
}

while getopts ":n*" opt; do	
	case ${opt} in
		n )
			argTrue="y"
			extract
			;;
		\? )
			echo "Usage: [-n]" 
			;;
	esac
done

if [[ argTrue != "y" ]]
then	
	variableDec
	argTrue="n"
fi