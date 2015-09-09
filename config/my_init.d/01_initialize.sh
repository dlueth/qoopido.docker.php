#!/bin/bash

INIT="/etc/php5/initialize.sh"
files=($(find /app/config/php5 -type f))

for source in "${files[@]}" 
do
	pattern="\.DS_Store"
	target=${source/\/app\/config\/php5/\/etc\/php5}
	
	if [[ ! $target =~ $pattern ]]; then
		if [[ -f $target ]]; then
			echo "    Removing \"$target\"" && rm -rf $target
		fi
		
		echo "    Linking \"$source\" to \"$target\"" && mkdir -p $(dirname "${target}") && ln -s $source $target
	fi
done

if [ -f $INIT ]
then
	 chmod +x $INIT && chmod 755 $INIT && ln -s $INIT /etc/my_init.d/99_initialize.sh
fi

mkdir -p /app/htdocs
mkdir -p /app/sessions
mkdir -p /app/logs/php5