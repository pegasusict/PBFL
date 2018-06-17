#!/bin/bash
############################################################################
# Pegasus' Linux Administration Tools #		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers	  #				 pegasus.ict@gmail.com #
# License: MIT						  #	Please keep my name in the credits #
############################################################################

#######################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools" #
# SCRIPT_TITLE="Header Generator Script"			  #
# MAINTAINER="Mattijs Snepvangers"					  #
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"			  #
# VERSION_MAJOR=0									  #
# VERSION_MINOR=0									  #
# VERSION_PATCH=0									  #
# VERSION_STATE="PRE-ALPHA"							  #
# VERSION_BUILD=20180617							  #
# LICENSE="MIT"										  #
#######################################################

header() {	### generates a header
			# usage: header $CHAR $LEN
			# $CHAR defaults to # and $LEN defaults to 80
	local _CHAR=${1:-#}
	local _LEN=${2:-80}
	local _HEADER=$(make_line "$_CHAR" "$_LEN")
	_HEADER+=$(header_line "$PROGRAM_SUITE" "$SCRIPT_TITLE" "$_CHAR" "$_LEN")
	_HEADER+=$(header_line "$COPYRIGHT" "$MAINTAINER_EMAIL" "$_CHAR" "$_LEN")
	_HEADER+=$(header_line "$SHORT_VERSION" "Build $VERSION_BUILD" "$_CHAR" "$_LEN")
	_HEADER+=$(header_line "License: $LICENSE" "Please keep my name in the credits" "$_CHAR" "$_LEN")
	_HEADER+="\n$(make_line $_CHAR $_LEN)"
	printf "%s\n" $_HEADER
}

header_line() {	### generates a header-line
				# usage: header_line $PART1 $PART2 $CHAR $LEN $SPACER
				# $CHAR defaults to "#", $LEN to 80 and spacer to " "
	local _PART1="$1"
	local _PART2="$2"
	local _CHAR=${3:-#}
	local _LEN=${4:-}
	local _SPACER=${5:-" "}
	local _SPACERS=""
	local _HEADER_LINE="# ${_PART1}${_SPACERS}${_PART2} #"
	for (( i=${#_HEADER_LINE}; i<MAX_WIDTH; i++ ))
		do _SPACERS+=$_SPACER
	done
	local _NEW_HEADER_LINE="# ${_PART1}${_SPACERS}${_PART2} #"
	printf "%s\n" "$_NEW_HEADER_LINE"
}

make_line() { ### generates a line
			  # usage: make_line [$CHAR [$LEN [$LINE]]]
			  # $CHAR defaults to "#" and $LEN defaults to 80
	_CHAR=${1:-#}
	_LEN=${2:-80}
	_LINE=${3:-#}
	for (( i=${#_LINE}; i<_LEN; i++ ))
		do _LINE+=$_CHAR
	done
	printf "%s\n" "$_LINE"
}
