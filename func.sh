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

aws-ls() {
	aws s3 ls s3://$bucket/$1 | grep "$2" | awk '{print $4}'
}

aws-mv() {
	aws s3 mv s3://$bucket/$1 s3://$bucket/$2
	echo ""
}

aws-rm() {
	aws s3 rm s3://$bucket/$(echo $1 | sed 's/+/0/g')
	echo ""
}

del-old-pkg() {
	name_pkg=$(get_name $1)
	for j in $(aws-ls $arch/ $name_pkg); do
		if [[ $1 != $j &&  $name_pkg = $(get_name $j) ]]; then
			aws-rm $arch/$j
		fi
	done
}

del-all-pkg() {
	for j in $(aws-ls $arch/ $1); do
		if [[ $1 = $(get_name $j) ]]; then
			aws-rm $arch/$j
		fi
	done
}
