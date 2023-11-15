#!/bin/bash

affich() {
	ID=$(echo "$res" | awk -F'/' '{print $4}')
	printf "\nfile uploaded successfully .\n"
	echo "File name is : $file_name"
	echo "Your file ID is : $ID"
}

upload()
{
	printf "Where the file is located -path-: "
	read path
	printf "Enter the File Name: "
	read file_name
	cd $path
	res=$(curl --progress-bar --upload-file ./$file_name https://transfer.sh/$file_name)
	ID=$(echo "$res" | awk -F'/' '{print $4}')
	affich file_name res
	exit 0
}

download()
{
	printf "Enter the File Name: "
	read file_name
	printf "Enter the ID : "
	read ID
#	user=$(echo ~$username | awk -F'/' '{print $3}')
#	cd && cd Desktop
	curl https://transfer.sh/$ID/$file_name -o $file_name
	exit 0
}

printf "You want to upload or download a file: "
read action
 if [ "$action" == "upload" ]; then
 	upload
 elif [ "$action" == "download" ]; then
 	download
 else
	 echo "Usage : sh $0 \ntape upload or download"
 fi

