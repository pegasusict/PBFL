#!/bin/bash
###############################################################################
## Pegasus' Linux Administration Tools #      Pegasus' Bash Function Library ##
## (C)2017-2020 Mattijs Snepvangers    #               pegasus.ict@gmail.com ##
## License: MIT                        #  Please keep my name in the credits ##
###############################################################################

###############################################################################
### PROGRAM_SUITE="Pegasus' Linux Administration Tools"
### SCRIPT_TITLE="Apt Functions AutoLoader"
### MAINTAINER="Mattijs Snepvangers"
### MAINTAINER_EMAIL="pegasus.ict@gmail.com"
### VER_MAJOR=0
### VER_MINOR=0
### VER_PATCH=0
### VER_STATE="ALPHA"
### BUILD=20191104
### LICENSE="MIT"
################################################################################

# fun: autoload_register
# txt: registers function placeholders which will load the respective library when required
# api: pbfl::internal
function autoload_register() {
  local -r LIB="apt"
  local -ar FUNCTIONS=( "apt_cmd" "apt_cmd_silent" "add_ppa_key" "apt_inst_with_recs"
 "apt_inst_no_recs" "apt_update" "apt_upgrade" "apt_remove" "apt_uninstall" "apt_clean"
 "apt_fix_deps" "install_pkg" "clean_sources" "apt_cycle" "apt_uninstall" )

  pbfl_autoload_register ${LIB} ${FUNCTIONS[@]}
}
