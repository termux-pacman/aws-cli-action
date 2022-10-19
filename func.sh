#!/bin/bash

get_name() {
	local name=""
	local file_sp=(${1//-/ })
	for k in $(seq 0 $((${#file_sp[*]}-4))); do
		if [ -z $name ]; then
			name="${file_sp[k]}"
		else
			name+="-${file_sp[k]}"
		fi
	done
	echo $name | sed 's/+/0/g'
}

get-object() {
	aws s3api get-object --bucket $bucket --key $1 $2
	echo ""
}

put-object() {
	aws s3api put-object --bucket $bucket --key $1 --body $2
	echo ""
}

aws-mv() {
	aws s3 mv s3://$bucket/$1 s3://$bucket/$2
	echo ""
}

aws-rm() {
	aws s3 rm s3://$bucket/$1
	echo ""
}

del-old-pkg() {
	name_pkg=$(get_name $1)
	for j in $(echo "$files" | grep $name_pkg); do
		if [[ $1 != ${j##*/} &&  $name_pkg = $(get_name ${j##*/}) ]]; then
			aws-rm $j
		fi
	done
}

del-all-pkg() {
	for j in $(echo "$files" | grep $1); do
		if [[ $1 = $(get_name ${j##*/}) ]]; then
			aws-rm $j
		fi
	done
}
