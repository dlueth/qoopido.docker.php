#!/bin/bash

mkdir -p /app/htdocs
mkdir -p /app/data/sessions
mkdir -p /app/data/logs
mkdir -p /app/config

FILES=($(find /app/config -type f \( -not -name ".DS_Store" \)))

for source in "${FILES[@]}"
do
	target=${source/\/app\/config/\/etc\/php/5.5}

	if [[ -f $target ]]; then
		echo "    Removing \"$target\"" && rm -rf $target
	fi

	echo "    Linking \"$source\" to \"$target\"" && mkdir -p $(dirname "${target}") && ln -s $source $target
done