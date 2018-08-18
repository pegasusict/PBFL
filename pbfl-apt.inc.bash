#!/bin/bash
################################################################################
# Pegasus' Linux Administration Tools	#	Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers	#		 pegasus.ict@gmail.com #
# License: MIT				#   Please keep my name in the credits #
################################################################################

################################################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools"
# SCRIPT_TITLE="Apt Functions Script"
# MAINTAINER="Mattijs Snepvangers"
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"
# VER_MAJOR=0
# VER_MINOR=1
# VER_PATCH=8
# VER_STATE="ALPHA"
# BUILD=20180819
# LICENSE="MIT"
################################################################################

# fun: add_ppa_key
# txt: installs ppa certificate
# use: add_ppa_key METHOD URL [KEY]
# opt: METHOD: <wget|apt-key|aar>
# opt: URL: the URL of the PPA key
# opt: KEY: code needed when using the apt-key method
# api: pbfl::apt
add_ppa_key() {
	local _METHOD	;	_METHOD=$1
	local _URL		;	_URL=$2
	local _KEY		;	_KEY=$3
	case $_METHOD in
		"wget"		)	wget -q -a "$LOG_FILE" $_URL -O- | apt-key add - ;;
		"apt-key"	)	apt-key adv --keyserver $_URL --recv-keys $_KEY | dbg_line ;;
		"aar"		)	add-apt-repository $_URL | dbg_line ;;
	esac
}

# fun: apt_inst
# txt: updates all installed packages
# use: apt_inst PACKAGES
# opt: PACKAGES: space separated list of packages to be installed
# api: pbfl::apt
apt_inst() {
	local _PACKAGES	;	_PACKAGES="$@"
	apt-get install --force-yes -y --no-install-recommends -qq --allow-unauthenticated ${_PACKAGES} 2>&1 | dbg_line
}

# fun: apt_update
# txt: reloads the apt database
# use: apt_update
# api: pbfl::apt
apt_update() {
	info_line "Updating apt cache"
	apt-get -qqy update 2>&1 | dbg_line
}

# fun: apt_upgrade
# txt: updates all installed packages
# use: apt_upgrade
# api: pbfl::apt
apt_upgrade() {
	info_line "Updating installed packages"
	apt-get -qqy --allow-unauthenticated upgrade 2>&1 | dbg_line
}

# fun: apt_remove
# txt: uninstalls & purges all obsolete packages
# use: apt_remove
# api: pbfl::apt
apt_remove() {
	info_line "Cleaning up obsolete packages"
	apt-get -qqy auto-remove --purge 2>&1 | dbg_line
}

# fun: apt_clean
# txt: cleans up apt cache
# use: apt_clean
# api: pbfl::apt
apt_clean() {
	info_line "Clearing old/obsolete package cache"
	apt-get -qqy autoclean 2>&1 | dbg_line
}

# fun: apt_cycle
# txt: does a complete update/upgrade/autoremove/clean cycle
# use: apt_cycle
# api: pbfl::apt
apt_cycle() {
	apt_update
	apt_upgrade
	apt_remove
	apt_clean
}

# fun: apt_fix_deps
# txt: fixes broken dependencies
# use: apt_fix_deps
# api: pbfl::apt
apt_fix_deps() {
	info_line "Fixing any broken dependencies if needed"
	apt -qqy --fix-broken install 2>&1
}

# fun: install
# txt: install a .deb package not available in apt
# use: install <DEB_PACKAGE>
# opt: DEB_PACKAGE: path to file with .deb extension
# api: pbfl::apt
install() {
	local _DEB_PACKAGE	;	_DEB_PACKAGE=$1
	dpkg -i $_DEB_PACKAGE 2>&1 | dbg_line
}

# fun: clean_sources
# txt: cleans up /etc/apt/sources.list and /etc/apt/sources.list.d/*
# use: clean_sources
# api: pbfl::apt
clean_sources() {
    info_line "removing duplicate lines from source lists"
    #perl -i -ne 'print if ! $a{$_}++' /etc/apt/sources.list /etc/apt/sources.list.d/* | dbg_line
    local TEMP; TEMP=$(mktemp)
    local -a FILES=($(echo /etc/apt/*.list /etc/apt/sources.list.d/*|sort))
    local LENGTH; LENGTH=$(echo ${#FILES[@]})
    for ((i=0;i<LENGTH;i++))
    do
	for ((j=0;j<=3;j++))
	do
	    [ "${FILES[i]}" == "${FILES[i+j]}" ] && continue
	    [ "$((i+j))" -ge "$LENGTH" ] && continue
	    #echo ${FILES[i]} ${FILES[i+j]}
	    grep -w -Ff ${FILES[i]} -v ${FILES[i+j]} > ${TEMP}
	    mv ${TEMP} ${FILES[i+j]}
	done
    done
}
