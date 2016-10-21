#!/bin/bash

FILES=($(find ./config -type f \( -not -name ".DS_Store" \)))

for path in "${FILES[@]}"
do
	source=${path/\./}
	target=${path/\.\/config/\/etc}

	if [[ -f $target ]]; then
		echo "    Removing \"$target\"" && rm -rf $target
	fi

	echo "    Linking \"$source\" to \"$target\"" && mkdir -p $(dirname "${target}") && ln -s $source $target
done
