#!/bin/bash

get_name() {
	local name=""
	local file_sp=(${1//-/ })
	for _index_f_get_name in $(seq 0 $((${#file_sp[*]}-4))); do
		if [ -z $name ]; then
			name="${file_sp[_index_f_get_name]}"
		else
			name+="-${file_sp[_index_f_get_name]}"
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

aws-rm() {
	aws s3 rm s3://$bucket/$1
	echo ""
}

del-old-pkg() {
	local name_pkg=$(get_name $1)
	for _pkg_f_del_old_pkg in $(echo "$files" | grep $name_pkg); do
		if [[ $1 != $(echo ${_pkg_f_del_old_pkg##*/} | sed 's/+/0/g') && $name_pkg = $(get_name ${_pkg_f_del_old_pkg##*/}) ]]; then
			aws-rm $_pkg_f_del_old_pkg
		fi
	done
}

del-all-pkg() {
	for _pkg_f_del_all_pkg in $(echo "$files" | grep $1); do
		if [[ $1 = $(get_name ${_pkg_f_del_all_pkg##*/}) ]]; then
			aws-rm $_pkg_f_del_all_pkg
		fi
	done
}
