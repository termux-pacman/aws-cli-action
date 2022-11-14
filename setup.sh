#!/bin/bash

set -e

info() {
	echo "==> $1"
}

if [[ -z $1 || -z $2 || -z $3 ]]; then
	echo "Error: not enough information to connect"
	exit 1
fi

info "Install aws cli"
while true; do
	python -m pip install awscli || continue
	break
done

info "Set aws cli"
if [ ! -d ~/.aws ]; then
	mkdir ~/.aws
fi

if [ ! -f ~/.aws/credentials ]; then
	{
	 	echo "[default]"
		echo "aws_access_key_id = $1"
		echo "aws_secret_access_key = $2"
	} > ~/.aws/credentials
fi

if [ ! -f ~/.aws/config ]; then
	{
		echo "[default]"
		echo "region = $3"
	} > ~/.aws/config
fi
