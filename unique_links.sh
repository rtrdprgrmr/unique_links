#!/bin/bash

VERBOSE=true
#FOLLOW_SYMLINK=true

usage(){
	echo "usage: $0 -add destination-directory source-file-or-directory ..."
	echo "usage: $0 -del destination-directory source-file-or-directory ..."
	echo "usage: $0 -check destination-file-or-directory ..."
}

make_hash(){
	basename=${file##*/}
	tail=${basename##*.}
	if [ "$tail" == "$basename" ]; then
		ext=
	else
		ext=.$tail
	fi
	hash=$(dd if="$file" bs=4096 count=1 2>/dev/null | openssl md5 | cut -c 1-8)
}

make_link(){
	n=$1
	if [ "${n:0:1}" != "/" ]; then
		n=$PWD/$n
	fi
	ln -s "$n" "$2"
}

add_action(){
	if [ -d "$file" ]; then
		[ $FOLLOW_SYMLINK ] && FIND_OPT=-L
		find $FIND_OPT "$file" -type f -print0 | xargs -0 "$0" -add "$dstdir"
		if [ $? -ne 0 ]; then
			exit 255
		fi
		return
	fi
	if [ ! -e "$file" ]; then
		echo "not found: $file"
		return
	fi
	make_hash
	for i in "$dstdir/$hash"*; do
		cmp --quiet "$file" "$i"
		if [ $? -eq 0 ]; then
			[ $VERBOSE ] && echo "dup: $file ($i)"
			return
		fi
	done
	newfile=$dstdir/$hash$ext
	let j=1
	while true; do
		if [ ! -e "$newfile" ] && [ ! -L "$newfile" ]; then
			make_link "$file" "$newfile"
			return
		fi
		newfile=$dstdir/${hash}_$j$ext
		let j=j+1
	done
}

del_action(){
	if [ -d "$file" ]; then
		[ $FOLLOW_SYMLINK ] && FIND_OPT=-L
		find $FIND_OPT "$file" -type f -print0 | xargs -0 "$0" -del "$dstdir"
		if [ $? -ne 0 ]; then
			exit 255
		fi
		return
	fi
	if [ ! -e "$file" ]; then
		echo "not found: $file"
		return
	fi
	make_hash
	for i in "$dstdir/$hash"*; do
		cmp --quiet "$file" "$i"
		if [ $? -eq 0 ]; then
			[ $VERBOSE ] && echo "del: $file ($i)"
			rm -f "$i"
			return
		fi
	done
}

check_action(){
	if [ -d "$file" ]; then
		find "$file" -type l -print0 | xargs -0 "$0" -check
		if [ $? -ne 0 ]; then
			exit 255
		fi
		return
	fi
	if [ ! -e "$file" ]; then
		echo "not found: $file"
		return
	fi
	if [ ! -L "$file" ]; then
		echo "not symlink: $file"
		return
	fi
	make_hash
	if [ "${basename%.*}" == "$hash" ]; then
		return
	fi
	if [ "${basename%%_*}" == "$hash" ]; then
		return
	fi
	echo "invalid: $file"
}

operation=$1
shift

if [ "$operation" == "-add" ]; then
	dstdir=$1
	shift
	if [ ! -d "$dstdir" ]; then
		echo "directory not found: $dstdir"
		exit 255
	fi
	while [[ $# -gt 0 ]]; do
		file=$1
		add_action
		shift
	done
	exit 0
fi

if [ "$operation" == "-del" ]; then
	dstdir=$1
	shift
	if [ ! -d "$dstdir" ]; then
		echo "directory not found: $dstdir"
		exit 255
	fi
	while [[ $# -gt 0 ]]; do
		file=$1
		del_action
		shift
	done
	exit 0
fi

if [ "$operation" == "-check" ]; then
	while [[ $# -gt 0 ]]; do
		file=$1
		check_action
		shift
	done
	exit 0
fi

usage
exit 255

