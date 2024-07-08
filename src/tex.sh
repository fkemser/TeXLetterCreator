#!/bin/sh
#
# SPDX-FileCopyrightText: Copyright (c) 2023-2024 Florian Kemser and the TeXLetterCreator contributors
# SPDX-License-Identifier: GPL-3.0-or-later
#
#===============================================================================
#
#         FILE:   /src/tex.sh
#
#        USAGE:   Run <tex.sh -h> for more information
#
#  DESCRIPTION:   TeXLetterCreator Run File
#
#      OPTIONS:   Run <tex.sh -h> for more information
#
# REQUIREMENTS:   Run <tex.sh -h> for more information
#
#         BUGS:   ---
#
#        NOTES:   Please edit the configuration file (/etc/tex.cfg.sh)
#                 before you start.
#
#         TODO:   See 'TODO:'-tagged lines below.
#===============================================================================

#===============================================================================
#  CONFIG
#===============================================================================
#  DONE: Enable PID based locking? (true|false)
#  (If 'true' then parts of the script require root privileges.)
readonly PIDLOCK_ENABLED="false"

#===============================================================================
#  INIT - DO NOT EDIT
#===============================================================================
#  Run repository initialization script
. "$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/init.sh"              || \
{ printf "%s\n\n"                                                           \
    "ERROR: Could not run the repository initialization script './init.sh'. Aborting..." >&2
  return 1
}

#===============================================================================
#  PARAMETER (TEMPLATE) - DO NOT EDIT
#===============================================================================
#  Script actions <ARG_ACTION_...>
readonly ARG_ACTION_ABOUT="about"
readonly ARG_ACTION_EXIT="exit"
readonly ARG_ACTION_HELP="help"
arg_action=""

#  Log destination <ARG_LOGDEST_...>
readonly ARG_LOGDEST_BOTH="both"                  # Terminal window + System log
readonly ARG_LOGDEST_SYSLOG="syslog"  	          # System log
readonly ARG_LOGDEST_TERMINAL="terminal"          # Terminal window
readonly ARG_LOGDEST_LIST="BOTH SYSLOG TERMINAL"
arg_logdest=""

#  Script operation modes <ARG_MODE_...>
readonly ARG_MODE_DAEMON="daemon"                 # Daemon
readonly ARG_MODE_INTERACTIVE="interactive"       # Interactive
readonly ARG_MODE_INTERACTIVE_SUBMENU="submenu"   # Submenu
readonly ARG_MODE_SCRIPT="script"                 # Script
arg_mode="${ARG_MODE_SCRIPT}"

#===============================================================================
#  PARAMETER (CUSTOM)
#===============================================================================
#-------------------------------------------------------------------------------
#  Script actions <ARG_ACTION_...>
#-------------------------------------------------------------------------------
#                        DONE: DEFINE YOUR ACTIONS HERE
#
#                                      |||
#                                     \|||/
#                                      \|/
#-------------------------------------------------------------------------------
readonly ARG_ACTION_CREATE="create"
readonly ARG_ACTION_PRINT="print"
#-------------------------------------------------------------------------------
#                                      /|\
#                                     /|||\
#                                      |||
#
#                        DONE: DEFINE YOUR ACTIONS HERE
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#  Other parameters <arg_...>
#-------------------------------------------------------------------------------
#  In case you define any additional constants for your parameters please use
#  the following naming convention:
#
#  Name                 Description
#  -----------------------------------------------------------------------------
#  <ARG>_DEFAULT        Default value that <arg> will be reset to,
#                       see <LIST_ARG_CLEANUP_INTERACTIVE> below.
#
#  <ARG>_LIST[_...]     List of allowed values, either directly or
#                       indirectly via constant pointers.
#
#  <ARG>_MAX            Maximum value
#  <ARG>_MIN            Minimum value
#
#                       DONE: DEFINE YOUR PARAMETERS HERE
#
#                                      |||
#                                     \|||/
#                                      \|/
#-------------------------------------------------------------------------------
arg_file_in=""      # Input '.tex' file (full path)
arg_file_out=""     # Output '.pdf' file (full path)
arg_recp_addr=""    # Recipient's address (multiline, without name)
arg_recp_name=""    # Recipient's name (one line)

# Variables (identifiers, multiple separated by space ' ') that have been
# exported by the calling script/terminal, for further use in the the LaTeX
# input file. The purpose of this parameter: (La)TeX uses some special
# characters that have to be escaped (\) when using them as "normal" characters.
# This parameter makes sure that this script is aware of the variables that
# have to be checked for special characters. See also:
#   https://tex.stackexchange.com/a/34586
arg_vars=""
#-------------------------------------------------------------------------------
#                                      /|\
#                                     /|||\
#                                      |||
#
#                       DONE: DEFINE YOUR PARAMETERS HERE
#-------------------------------------------------------------------------------

#===============================================================================
#  GLOBAL VARIABLES (TEMPLATE) - DO NOT EDIT
#===============================================================================
# Trap handling
trap_blocked="false"        # Prevent trap execution? (true|false)
trap_triggered="false"      # <trap_...()> function was called? (true|false)

#===============================================================================
#  GLOBAL VARIABLES (CUSTOM)
#===============================================================================
#                    DONE: DEFINE YOUR GLOBAL VARIABLES HERE
#
#                                      |||
#                                     \|||/
#                                      \|/
#===============================================================================
file_out_aux=""   # TeX output file (.aux)
file_out_log=""   # TeX output file (.log)
file_out_pdf=""   # TeX output file (.pdf)
file_tmp=""       # Temporary helper file
#===============================================================================
#                                      /|\
#                                     /|||\
#                                      |||
#
#                    DONE: DEFINE YOUR GLOBAL VARIABLES HERE
#===============================================================================

#===============================================================================
#  GLOBAL CONSTANTS (TEMPLATE)
#===============================================================================
#-------------------------------------------------------------------------------
#  Lists of allowed actions <ARG_ACTION_...>
#-------------------------------------------------------------------------------
#  Used for auto-generating help's SYNOPSIS section and the main menu in
#  interactive mode. Please define a list of actions (separated by space) that
#  are allowed in interactive (also submenu) and/or script mode.
#  Use the variable's name but WITHOUT the <ARG_ACTION_> prefix,
#  e.g. for <ARG_ACTION_CUSTOM1> just use <CUSTOM1> in the list.
#-------------------------------------------------------------------------------
#                      DONE: DEFINE YOUR ACTION LISTS HERE
#
#                                      |||
#                                     \|||/
#                                      \|/
#-------------------------------------------------------------------------------
# Interactive mode / Submenu mode
readonly ARG_ACTION_LIST_INTERACTIVE="CREATE PRINT"
# Classic script mode
readonly ARG_ACTION_LIST_SCRIPT="HELP CREATE PRINT"
#-------------------------------------------------------------------------------
#                                      /|\
#                                     /|||\
#                                      |||
#
#                      DONE: DEFINE YOUR ACTION LISTS HERE
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#                    DONE: DEFINE YOUR PARAMETER LISTS HERE
#
#                                      |||
#                                     \|||/
#                                      \|/
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#  Lists of compatible parameters (script mode only)
#-------------------------------------------------------------------------------
#  Used for auto-generating help's SYNOPSIS section. Please define a list of
#  parameters (separated by space) that are allowed in script mode.
#  !!! Use the variable's name in capital letters,
#      e.g. for <arg_int> use <ARG_INT> !!!
readonly LIST_ARG="ARG_FILE_IN ARG_FILE_OUT ARG_RECP_ADDR ARG_RECP_NAME \
ARG_VARS"

#-------------------------------------------------------------------------------
#  Lists of parameters to clear/reset (interactive mode only)
#-------------------------------------------------------------------------------
#  List of arguments that have to be cleared or reset to their default values
#  after running <run()> function (interactive mode only).
#  To assign a default value to a parameter please define a constant (above)
#  with the suffix '_DEFAULT', e.g. <ARG_STR_DEFAULT> for <arg_str>.
#  !!! Use the variable's name as defined, so usually lowercase letters !!!
readonly LIST_ARG_CLEANUP_INTERACTIVE=""
#-------------------------------------------------------------------------------
#                                      /|\
#                                     /|||\
#                                      |||
#
#                    DONE: DEFINE YOUR PARAMETER LISTS HERE
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#  Custom language-specific strings <TXT_...>
#-------------------------------------------------------------------------------
#  Please do not set anything here, use '/src/lang/run.<ll>.lang.sh'
#  and <init_lang()> function (see below) instead.

#-------------------------------------------------------------------------------
#  OTHER
#-------------------------------------------------------------------------------
# Current language ID (ISO 639-1), see <init_lang()>
ID_LANG=""

# Number of running instances,
# used to check if this script was called recursively
INSTANCES=""

# Daemon mode sleep interval (in s), see <main_daemon()>
readonly T_DAEMON_SLEEP="60"

#===============================================================================
#  GLOBAL CONSTANTS (CUSTOM)
#===============================================================================
#                    DONE: DEFINE YOUR GLOBAL CONSTANTS HERE
#
#                                      |||
#                                     \|||/
#                                      \|/
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#                                      /|\
#                                     /|||\
#                                      |||
#
#                    DONE: DEFINE YOUR GLOBAL CONSTANTS HERE
#-------------------------------------------------------------------------------

#===============================================================================
#  FUNCTIONS (TEMPLATE)
#===============================================================================
#===  FUNCTION  ================================================================
#         NAME:  args_check
#  DESCRIPTION:  Check if passed arguments are valid
#      OUTPUTS:  An error message to <stderr> and/or <syslog>
#                in case an error occurs
#   RETURNS  0:  All arguments are valid
#            1:  At least one argument is not valid
#===============================================================================
args_check() {
  #-----------------------------------------------------------------------------
  #  DO NOT EDIT
  #-----------------------------------------------------------------------------
  # Check if selected action is compatible with the selected mode
  lib_shtpl_arg_action_is_valid                                             && \

  #-----------------------------------------------------------------------------
  #                        DONE: DEFINE YOUR CHECKS HERE
  #                   (DO NOT FORGET THE TERMINATING '|| \')
  #
  #                                     |||
  #                                    \|||/
  #                                     \|/
  #-----------------------------------------------------------------------------

  #-----------------------------------------------------------------------------
  #  Check if mandatory arguments are set (daemon / script mode only)
  #-----------------------------------------------------------------------------
  #  Some arguments may not be listed here as <init_update()> may set their
  #  default values.
  #-----------------------------------------------------------------------------
  if    [ "${arg_action}" != "${ARG_ACTION_HELP}" ] && \
        [ "${arg_mode}" = "${ARG_MODE_DAEMON}" ]; then

    # Daemon mode
    true

  elif  [ "${arg_action}" != "${ARG_ACTION_HELP}" ] && \
        [ "${arg_mode}" = "${ARG_MODE_INTERACTIVE_SUBMENU}" ]; then

    # Submenu mode
    true

  elif  [ "${arg_action}" != "${ARG_ACTION_HELP}" ] && \
        [ "${arg_mode}" = "${ARG_MODE_SCRIPT}" ]; then

    # Script mode
    lib_shtpl_arg_is_set "arg_file_in" "arg_recp_addr" "arg_recp_name"

  fi                                                                        && \

  #-----------------------------------------------------------------------------
  #  Check argument types / value ranges
  #-----------------------------------------------------------------------------
  #  For more available checks, please have a look at the functions
  #  <lib_core_is()> and <lib_core_regex()> in '/lib/SHlib/lib/core.lib.sh'
  #-----------------------------------------------------------------------------
  #  arg_file_in
  if lib_core_is --not-empty "${arg_file_in}"; then
    lib_core_is --file "${arg_file_in}" || \
    { error "<${arg_file_in}> ${TXT_ARGS_CHECK_ERR_ARG_FILE_IN}"; arg_file_in=""; false; }
  fi                                                                        && \

  #  arg_file_out (script mode)
  if lib_core_is --empty "${arg_file_out}"; then
    if  [ "${arg_mode}" = "${ARG_MODE_SCRIPT}" ] && \
        [ "${arg_action}" != "${ARG_ACTION_HELP}" ]; then
      arg_file_out="$(lib_core_file_get --dir "${arg_file_in}")"
      arg_file_out="${arg_file_out}/$(lib_core_file_get --name "${arg_file_in}")"
      arg_file_out="${arg_file_out}_$(date +%s).pdf"
    fi
  fi                                                                        && \

  #  arg_file_out (all modes)
  if lib_core_is --not-empty "${arg_file_out}"; then
    #  Make sure that <arg_file_out> is a valid file path and that
    #  <arg_file_out> does not exist yet
    touch -c "${arg_file_out}" 2>/dev/null && \
    ! lib_core_is --file "${arg_file_out}" || \
    { error "<${arg_file_out}> ${TXT_ARGS_CHECK_ERR_ARG_FILE_OUT}"; arg_file_out=""; false; }
  fi                                                                        && \

  #  arg_recp_addr
  true                                                                      && \

  #  arg_recp_name
  true                                                                      && \

  #  arg_vars
  if lib_core_is --not-empty "${arg_vars}"; then
    lib_core_var_is --set ${arg_vars}
  fi                                                                        || \
  #-----------------------------------------------------------------------------
  #                                     /|\
  #                                    /|||\
  #                                     |||
  #
  #                        DONE: DEFINE YOUR CHECKS HERE
  #                   (DO NOT FORGET THE TERMINATING '|| \')
  #-----------------------------------------------------------------------------
  { error "${TXT_ARGS_CHECK_ERR}"
    return 1
  }
}

#===  FUNCTION  ================================================================
#         NAME:  args_read
#  DESCRIPTION:  Read passed arguments into global parameters/variables
#      GLOBALS:  arg_action     arg_logdest   arg_mode
#                arg_file_in    arg_file_out  arg_recp_addr  arg_recp_name
#                arg_vars
# PARAMETER  1:  Should be "$@" to get all arguments passed
#      OUTPUTS:  An error message to <stderr> and/or <syslog>
#                in case an error occurs
#   RETURNS  0:  All arguments were successfully parsed
#            1:  At least one argument could not be parsed
#===============================================================================
args_read() {
  #-----------------------------------------------------------------------------
  #  No arguments => Run script interactively
  #-----------------------------------------------------------------------------
  if [ $# -eq 0 ]; then
    arg_mode="${ARG_MODE_INTERACTIVE}"
    return
  fi

  #-----------------------------------------------------------------------------
  #  Arguments defined => Run script in script mode
  #-----------------------------------------------------------------------------
  local arg_current
  while [ $# -gt 0 ]; do
    arg_current="$1"
    case "$1" in
      #-------------------------------------------------------------------------
      #  PARAMETER (TEMPLATE)
      #-------------------------------------------------------------------------
      #  Script actions <ARG_ACTION_...>
      -h|--help) arg_action="${ARG_ACTION_HELP}"; break ;;

      #  Script operation modes <ARG_MODE_...>
      --submenu)
        # Possibility to run a certain submenu interactively
        arg_mode="${ARG_MODE_INTERACTIVE_SUBMENU}"
        arg_action="$2"
        [ $# -ge 1 ] && { shift; }
        ;;

      #-------------------------------------------------------------------------
      #  PARAMETER (CUSTOM)
      #-------------------------------------------------------------------------
      #                 DONE: DEFINE YOUR ARGUMENT PARSING HERE
      #
      #                                   |||
      #                                  \|||/
      #                                   \|/
      #-------------------------------------------------------------------------
      #  Script actions <ARG_ACTION_...>
      --${ARG_ACTION_CREATE}|--${ARG_ACTION_PRINT})
        arg_action="${1#--}"
        ;;

      #  Other parameters <arg_...>
      #  DONE: Please make sure that the command line options set here match
      #        the ones set in '/src/lang/run.0.lang.sh' (<L_RUN_HLP_PAR_ARG_...>).
      -a|--address) arg_recp_addr="$2"; [ $# -ge 1 ] && { shift; } ;;
      -i|--in)      arg_file_in="$(lib_core_expand_tilde "$2")"; [ $# -ge 1 ] && { shift; } ;;
      -n|--name)    arg_recp_name="$2"; [ $# -ge 1 ] && { shift; } ;;
      -o|--out)     arg_file_out="$(lib_core_expand_tilde "$2")"; [ $# -ge 1 ] && { shift; } ;;
      -v|--vars)    arg_vars="$2"; [ $# -ge 1 ] && { shift; } ;;
      #-------------------------------------------------------------------------
      #                                   /|\
      #                                  /|||\
      #                                   |||
      #
      #                 DONE: DEFINE YOUR ARGUMENT PARSING HERE
      #-------------------------------------------------------------------------

      #-------------------------------------------------------------------------
      #  Last or undefined parameter
      #-------------------------------------------------------------------------
      *)
        #-----------------------------------------------------------------------
        #            DONE: DEFINE YOUR (LAST) ARGUMENT PARSING HERE
        #        PLEASE DO NOT FORGET TO DEFINE <L_RUN_HLP_PAR_LASTARG>
        #               IN '/src/lang/run.0.lang.sh' ACCORDINGLY.
        #
        #                                 |||
        #                                \|||/
        #                                 \|/
        #-----------------------------------------------------------------------
        #  Example: File/Directory parsing
        if [ $# -eq 1 ]; then
          #  Only one argument left
          local lastarg="$(lib_core_expand_tilde "$1")"

          #  Check if it can be a filepath
          touch -c "${lastarg}" 2>/dev/null && \
          arg_file_in="${lastarg}"
        else
          #  More than one argument left
          #
          #  Ignore wrong argument and continue with next one ('true')
          #  or exit program ('false')?
          false
        fi
        #-----------------------------------------------------------------------
        #                                 /|\
        #                                /|||\
        #                                 |||
        #
        #            DONE: DEFINE YOUR (LAST) ARGUMENT PARSING HERE
        #        PLEASE DO NOT FORGET TO DEFINE <L_RUN_HLP_PAR_LASTARG>
        #               IN '/src/lang/run.0.lang.sh' ACCORDINGLY.
        #-----------------------------------------------------------------------
        ;;
    esac                                                  && \
    [ $# -gt 0 ]                                          && \
    shift                                                 || \
    { error "<${arg_current}> ${TXT_ARGS_READ_ERR}"
      return 1
    }
  done
}

#===  FUNCTION  ================================================================
#         NAME:  cleanup_interactive
#  DESCRIPTION:  Cleanup, executed each cycle after <run()>
#                (interactive mode only)
#===============================================================================
cleanup_interactive() {
  #-----------------------------------------------------------------------------
  #  DO NOT EDIT
  #-----------------------------------------------------------------------------
  #  Reset arguments to their default values
  local list
  list="${LIST_ARG_CLEANUP_INTERACTIVE}"

  local arg
  local val
  for arg in ${list}; do
    val="$(lib_core_str_to --const "${arg}_DEFAULT")"
    eval "val=\${${val}}"
    eval "${arg}=\${val}"
  done

  #-----------------------------------------------------------------------------
  #         DONE: DEFINE YOUR CLEANUP COMMANDS (INTERACTIVE MODE) HERE
  #
  #                                     |||
  #                                    \|||/
  #                                     \|/
  #-----------------------------------------------------------------------------
  rm -f "${file_out_aux}" "${file_out_log}" "${file_tmp}"
  case "${arg_action}" in
    ${ARG_ACTION_PRINT}) rm -f "${file_out_pdf}" ;;
  esac

  file_out_aux=""
  file_out_log=""
  file_out_pdf=""
  file_tmp=""

  arg_action=""
  #-----------------------------------------------------------------------------
  #                                     /|\
  #                                    /|||\
  #                                     |||
  #
  #         DONE: DEFINE YOUR CLEANUP COMMANDS (INTERACTIVE MODE) HERE
  #-----------------------------------------------------------------------------
}

#===  FUNCTION  ================================================================
#         NAME:  error
#  DESCRIPTION:  Log/Print error message and optionally exit
#          ...:  See <msg()>
#===============================================================================
error() {
  msg --error "$@"
}

#===  FUNCTION  ================================================================
#         NAME:  help
#  DESCRIPTION:  Print help message using 'less' utility
#         DONE:  Please do not hardcode any help texts here.
#                Edit '/src/lang/run.<...>.lang.sh' to define your help texts
#                and edit <help_synopsis()> below to modify the SYNOPSIS
#                section of your help.
#===============================================================================
help() {
  lib_shtpl_help
}

#===  FUNCTION  ================================================================
#         NAME:  help_synopsis
#  DESCRIPTION:  Create help's <SYNOPSIS> section
#      OUTPUTS:  Write SYNOPSIS text to <stdout>
#===============================================================================
help_synopsis() {
  local ARG_SECTION_SYNOPSIS="--synopsis"
  local ARG_SECTION_TLDR="--tldr"
  local arg_section="${1:-${ARG_SECTION_SYNOPSIS}}"

  #  Get language-dependent text strings
  local ttl_action
  local ttl_option
  local txt_interactive
  local txt_intro
  local txt_script
  eval "ttl_action=\${LIB_SHTPL_${ID_LANG}_TXT_HELP_TTL_SYNOPSIS_ACTION}"
  eval "ttl_option=\${LIB_SHTPL_${ID_LANG}_TXT_HELP_TTL_SYNOPSIS_OPTION}"
  eval "txt_interactive=\${LIB_SHTPL_${ID_LANG}_TXT_HELP_TXT_SYNOPSIS_INTERACTIVE}"
  eval "txt_script=\${LIB_SHTPL_${ID_LANG}_TXT_HELP_TXT_SYNOPSIS_SCRIPT}"
  case "${arg_section}" in
    ${ARG_SECTION_SYNOPSIS})
      eval "txt_intro=\${LIB_SHTPL_${ID_LANG}_TXT_HELP_TXT_SYNOPSIS_INTRO}"
      ;;
    ${ARG_SECTION_TLDR})
      eval "txt_intro=\${LIB_SHTPL_${ID_LANG}_TXT_HELP_TXT_TLDR_SYNOPSIS}"
      ;;
    *)
      return 1
      ;;
  esac

  #-----------------------------------------------------------------------------
  #  SYNOPSIS (INTRO)
  #-----------------------------------------------------------------------------
  #  Pointer prefix used for actions and options
  local ptr_prefix
  ptr_prefix="L_$(lib_core_file_get --name "$0")"
  ptr_prefix="$(lib_core_str_to --const "${ptr_prefix}")"

  #  Last argument, see  <args_read()>, <L_RUN_HLP_PAR_LASTARG> in
  #  '/src/lang/run.0.lang.sh', and <L_RUN_<DE|EN|..>_HLP_DES_LASTARG> in
  #  '/src/lang/run.<de|en|...>.lang.sh'.
  local par_lastarg # Parameter, e.g. '<file>'
  local txt_lastarg # Parameter description, e.g. '<file> is optional'
  eval "par_lastarg=\${${ptr_prefix}_HLP_PAR_LASTARG}"
  eval "txt_lastarg=\${${ptr_prefix}_${ID_LANG}_HLP_DES_LASTARG}"

  #  SYNOPSIS strings
  local synopsis_tldr   # TL;DR (short) version
  local synopsis        # SYNOPSIS (long) version

  #-----------------------------------------------------------------------------
  #                DONE: DEFINE YOUR SYNOPSIS (INTRO) TEXT HERE
  #
  #                                     |||
  #                                    \|||/
  #                                     \|/
  #-----------------------------------------------------------------------------
  #  TL;DR (short) version
  synopsis_tldr="\
${txt_intro}

${txt_interactive}:
> ${L_TEX_ABOUT_RUN}

${txt_script}:
> ${L_TEX_ABOUT_RUN} [ ${ttl_option} ]... ${ttl_action}${par_lastarg:+ ${par_lastarg}}"

  #  SYNOPSIS (long) version
  synopsis="\
${synopsis_tldr}

${ttl_action} := $(lib_msg_print_list_ptr "${ARG_ACTION_LIST_SCRIPT}" "${ptr_prefix}_HLP_PAR_ARG_ACTION_")

${ttl_option} := $(lib_msg_print_list_ptr "${LIST_ARG}" "${ptr_prefix}_HLP_PAR_" "" "true")"

  if lib_core_is --not-empty "${txt_lastarg}"; then
    synopsis="\
${synopsis}

${par_lastarg} : ${txt_lastarg}"
  fi
  #-----------------------------------------------------------------------------
  #                                     /|\
  #                                    /|||\
  #                                     |||
  #
  #                DONE: DEFINE YOUR SYNOPSIS (INTRO) TEXT HERE
  #-----------------------------------------------------------------------------

  #  Print
  case "${arg_section}" in
    ${ARG_SECTION_SYNOPSIS})
      eval lib_msg_print_heading -111 \"\${LIB_SHTPL_${ID_LANG}_TXT_HELP_TTL_SYNOPSIS}\"
      printf "%s\n" "${synopsis}"
      ;;

    ${ARG_SECTION_TLDR})
      eval lib_msg_print_heading -311 \"\${LIB_SHTPL_${ID_LANG}_TXT_HELP_TTL_TLDR_SYNOPSIS}\"
      printf "%s\n" "${synopsis_tldr}"
      return
      ;;
  esac

  #-----------------------------------------------------------------------------
  #  SYNOPSIS (ACTION)
  #-----------------------------------------------------------------------------
  eval lib_msg_print_heading -211 \"\${LIB_SHTPL_${ID_LANG}_TXT_HELP_TTL_SYNOPSIS_ACTION}\"

  #-----------------------------------------------------------------------------
  #                DONE: DEFINE YOUR SYNOPSIS (ACTION) TEXT HERE
  #
  #                                     |||
  #                                    \|||/
  #                                     \|/
  #-----------------------------------------------------------------------------
  #  NOTE:
  #    Please define your help texts in '/src/lang/run.<...>.lang.sh' before
  #    continuing here. To create/format the texts automatically, please use the
  #    the <lib_shtpl_arg()> function. You can find its documentation in
  #    '/lib/SHtemplateLIB/lib/shtpl.0.lib.sh'.
  #-----------------------------------------------------------------------------
  lib_msg_print_propvalue "--left" "--left" "2" "" " "                                                \
    "$(lib_shtpl_arg --par "ARG_ACTION_HELP")"    "$(lib_shtpl_arg --des "ARG_ACTION_HELP")" " " ""   \
                                                                                                      \
    "$(lib_shtpl_arg --par "ARG_MODE_INTERACTIVE_SUBMENU")"   "$(lib_shtpl_arg --des "ARG_MODE_INTERACTIVE_SUBMENU")

<menu>$(lib_shtpl_arg --list-ptr "arg_action" "INTERACTIVE")" " " ""                                  \
                                                                                                      \
    "$(lib_shtpl_arg --par "ARG_ACTION_CREATE")"  "$(lib_shtpl_arg --des "ARG_ACTION_CREATE")" " " "" \
    "$(lib_shtpl_arg --par "ARG_ACTION_PRINT")"   "$(lib_shtpl_arg --des "ARG_ACTION_PRINT")"
  #-----------------------------------------------------------------------------
  #                                     /|\
  #                                    /|||\
  #                                     |||
  #
  #                DONE: DEFINE YOUR SYNOPSIS (ACTION) TEXT HERE
  #-----------------------------------------------------------------------------

  #-----------------------------------------------------------------------------
  #  SYNOPSIS (OPTION)
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #                DONE: DEFINE YOUR SYNOPSIS (OPTION) TEXT HERE
  #
  #                                     |||
  #                                    \|||/
  #                                     \|/
  #-----------------------------------------------------------------------------
  #  NOTE:
  #    Please define your help texts in '/src/lang/run.<...>.lang.sh' before
  #    continuing here. To create/format the texts automatically, please use the
  #    the <lib_shtpl_arg()> function. You can find its documentation in
  #    '/lib/SHtemplateLIB/lib/shtpl.0.lib.sh'.
  #-----------------------------------------------------------------------------
  eval lib_msg_print_heading -211 \"\${LIB_SHTPL_${ID_LANG}_TXT_HELP_TTL_SYNOPSIS_OPTION}\"
  lib_msg_print_propvalue "--left" "--left" "2" "" " "                                        \
    "$(lib_shtpl_arg --par "arg_file_in")"    "$(lib_shtpl_arg --des "arg_file_in")" " " ""   \
    "$(lib_shtpl_arg --par "arg_file_out")"   "$(lib_shtpl_arg --des "arg_file_out")" " " ""  \
    "$(lib_shtpl_arg --par "arg_recp_addr")"  "$(lib_shtpl_arg --des "arg_recp_addr")" " " "" \
    "$(lib_shtpl_arg --par "arg_recp_name")"  "$(lib_shtpl_arg --des "arg_recp_name")" " " "" \
    "$(lib_shtpl_arg --par "arg_vars")"       "$(lib_shtpl_arg --des "arg_vars")"
  #-----------------------------------------------------------------------------
  #                                     /|\
  #                                    /|||\
  #                                     |||
  #
  #                DONE: DEFINE YOUR SYNOPSIS (OPTION) TEXT HERE
  #-----------------------------------------------------------------------------
}

#===  FUNCTION  ================================================================
#         NAME:  info
#  DESCRIPTION:  Log/Print info message and optionally exit
#          ...:  See <msg()>
#===============================================================================
info() {
  msg --info "$@"
}

#===  FUNCTION  ================================================================
#         NAME:  init_check_pre
#  DESCRIPTION:  Check script requirements (before argument parsing)
#      OUTPUTS:  An error message to <stderr> and/or <syslog>
#                in case an error occurs
#   RETURNS  0:  All mandatory requirements are fulfilled
#            1:  At least one mandatory requirement is not fulfilled
#===============================================================================
init_check_pre() {
  #=============================================================================
  #  Mandatory (= script will break on error)
  #=============================================================================
  #-----------------------------------------------------------------------------
  #                        DONE: DEFINE YOUR CHECKS HERE
  #                   (DO NOT FORGET THE TERMINATING '|| \')
  #
  #                                     |||
  #                                    \|||/
  #                                     \|/
  #-----------------------------------------------------------------------------
  lib_core_is --cmd "chmod" "lualatex"                                      || \
  #-----------------------------------------------------------------------------
  #                                     /|\
  #                                    /|||\
  #                                     |||
  #
  #                        DONE: DEFINE YOUR CHECKS HERE
  #                   (DO NOT FORGET THE TERMINATING '|| \')
  #-----------------------------------------------------------------------------
  { error "${TXT_INIT_CHECK_ERR}"
    return 1
  }

  #=============================================================================
  #  Optional (= script will continue on error)
  #=============================================================================
  local optionalFulfilled="true"
  #-----------------------------------------------------------------------------
  #                        DONE: DEFINE YOUR CHECKS HERE
  #                   (DO NOT FORGET THE TERMINATING '|| \')
  #
  #                                     |||
  #                                    \|||/
  #                                     \|/
  #-----------------------------------------------------------------------------
  true                                                                      || \
  optionalFulfilled="false"
  #-----------------------------------------------------------------------------
  #                                     /|\
  #                                    /|||\
  #                                     |||
  #
  #                        DONE: DEFINE YOUR CHECKS HERE
  #                   (DO NOT FORGET THE TERMINATING '|| \')
  #-----------------------------------------------------------------------------
  if ! ${optionalFulfilled}; then
    warning "${TXT_INIT_CHECK_WARN}"
    sleep 3
  fi
}

#===  FUNCTION  ================================================================
#         NAME:  init_check_post
#  DESCRIPTION:  Check script requirements (after argument parsing)
#      OUTPUTS:  An error message to <stderr> and/or <syslog>
#                in case an error occurs
#   RETURNS  0:  All mandatory requirements are fulfilled
#            1:  At least one mandatory requirement is not fulfilled
#===============================================================================
init_check_post() {
  #=============================================================================
  #  Mandatory (= script will break on error)
  #=============================================================================
  #-----------------------------------------------------------------------------
  #  DO NOT EDIT
  #-----------------------------------------------------------------------------
  # Check for running log service (except when terminal is the only destination)
  case "${arg_logdest}" in
    ${ARG_LOGDEST_BOTH}|${ARG_LOGDEST_SYSLOG})
      service log status >/dev/null 2>&1        || \
      service rsyslog status >/dev/null 2>&1    || \
      service syslog-ng status >/dev/null 2>&1  || \
      lib_msg_message --terminal --error "${TXT_INIT_CHECK_ERR_LOGSERVICE}"
      ;;
    ${ARG_LOGDEST_TERMINAL})
      ;;
    *)
      lib_msg_message --terminal --error "${TXT_INVALID_ARG_1} <${arg_logdest}> ${TXT_INVALID_ARG_2} [${L_TEX_HLP_PAR_ARG_LOGDEST}]. ${LIB_SHTPL_EN_TXT_HELP} ${LIB_SHTPL_EN_TXT_ABORTING}"
      ;;
  esac                                                                      && \

  #-----------------------------------------------------------------------------
  #                        DONE: DEFINE YOUR CHECKS HERE
  #                   (DO NOT FORGET THE TERMINATING '|| \')
  #
  #                                     |||
  #                                    \|||/
  #                                     \|/
  #-----------------------------------------------------------------------------
  true                                                                      || \
  #-----------------------------------------------------------------------------
  #                                     /|\
  #                                    /|||\
  #                                     |||
  #
  #                        DONE: DEFINE YOUR CHECKS HERE
  #                   (DO NOT FORGET THE TERMINATING '|| \')
  #-----------------------------------------------------------------------------
  { error "${TXT_INIT_CHECK_ERR}"
    return 1
  }

  #=============================================================================
  #  Optional (= script will continue on error)
  #=============================================================================
  local optionalFulfilled="true"
  #-----------------------------------------------------------------------------
  #                        DONE: DEFINE YOUR CHECKS HERE
  #                   (DO NOT FORGET THE TERMINATING '|| \')
  #
  #                                     |||
  #                                    \|||/
  #                                     \|/
  #-----------------------------------------------------------------------------
  true                                                                      || \
  optionalFulfilled="false"
  #-----------------------------------------------------------------------------
  #                                     /|\
  #                                    /|||\
  #                                     |||
  #
  #                        DONE: DEFINE YOUR CHECKS HERE
  #                   (DO NOT FORGET THE TERMINATING '|| \')
  #-----------------------------------------------------------------------------
  if ! ${optionalFulfilled}; then
    warning "${TXT_INIT_CHECK_WARN}"
    sleep 3
  fi
}

#===  FUNCTION  ================================================================
#         NAME:  init_first
#  DESCRIPTION:  Lock the script (PID file) or initialize instance counter,
#                set default log destination, and install trap handler
#      OUTPUTS:  In case of ...
#                  success : An info message with the script's PID to <syslog>
#                            (only if script is NOT run within a terminal)
#                    error : An error message to either <stderr> or <syslog>
#   RETURNS  0:  Success
#            1:  Error
#===============================================================================
init_first() {
  if ${PIDLOCK_ENABLED}; then
    #  PID lock (to prevent further instances) or ...
    lib_os_ps_pidlock --lock
  else
    # ... instance counter (used to check if this script was called recursively)
    readonly INSTANCES="$(lib_core_file_get --name "$0")_instances" && \
    eval "export ${INSTANCES}=$(( ${INSTANCES} + 1 ))"
  fi                                                                        && \

  #  Set default log destination (can be overwritten in <args_read()>)
  if lib_core_is --terminal-stdin || lib_core_is --terminal-stdout; then
    arg_logdest="${ARG_LOGDEST_TERMINAL}"
  else
    arg_logdest="${ARG_LOGDEST_SYSLOG}"
  fi                                                                        && \

  #  Install trap handlers
  local sig                                                                 && \
  for sig in EXIT HUP INT QUIT TERM; do
    #---------------------------------------------------------------------------
    #       DONE: ADD FURTHER TRAP PARAMETERS HERE (and in <trap_main()>)
    #
    #                                    |||
    #                                   \|||/
    #                                    \|/
    #---------------------------------------------------------------------------
    #  Please make sure to escape your variable and put it in escaped quotes,
    #  e.g. for variable <var> use: \"\${var}\"
    trap "{
      trap_main                                                     \
        \"${sig}\"          \"true\"            \"\${I_DIR_PID}\"   \
        \"\${I_EXT_PID}\"   \"\${arg_mode}\"
    }" ${sig}
    #---------------------------------------------------------------------------
    #                                    /|\
    #                                   /|||\
    #                                    |||
    #
    #       DONE: ADD FURTHER TRAP PARAMETERS HERE (and in <trap_main()>)
    #---------------------------------------------------------------------------
  done                                                                      && \

  #  Get PID (if PID lock is disabled, then <lib_os_ps_pidlock()> will fail.)
  local pid                                                                 && \
  { pid="$(lib_os_ps_pidlock --getpid)" || \
    lib_os_ps_get_ownpid pid
  }                                                                         && \

  #-----------------------------------------------------------------------------
  #                       DONE: ADD FURTHER COMMANDS HERE
  #                   (DO NOT FORGET THE TERMINATING '&& \')
  #
  #                                     |||
  #                                    \|||/
  #                                     \|/
  #----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #                                     /|\
  #                                    /|||\
  #                                     |||
  #
  #                       DONE: ADD FURTHER COMMANDS HERE
  #                   (DO NOT FORGET THE TERMINATING '&& \')
  #-----------------------------------------------------------------------------

  #  Print/Log
  info --syslog "${TXT_INIT_FIRST_INFO} (PID <${pid}>)."
}

#===  FUNCTION  ================================================================
#         NAME:  init_lang
#  DESCRIPTION:  Set language-specific text constants
#      GLOBALS:  ID_LANG  ... (see 'eval ...' commands below)
#===============================================================================
init_lang() {
  ID_LANG="$(lib_os_get --lang)"

  #=============================================================================
  #  Supported Languages
  #=============================================================================
  #-----------------------------------------------------------------------------
  #            DONE: ADD SUPPORTED LANGUAGES HERE (ISO 639-1 CODES)
  #
  #                                     |||
  #                                    \|||/
  #                                     \|/
  #-----------------------------------------------------------------------------
  case "${ID_LANG}" in
    ${LIB_C_ID_LANG_EN}) readonly ID_LANG="${LIB_C_ID_L_EN}" ;;
    ${LIB_C_ID_LANG_DE}) readonly ID_LANG="${LIB_C_ID_L_DE}" ;;
    *) readonly ID_LANG="${LIB_C_ID_L_EN}" ;;
  esac
  #-----------------------------------------------------------------------------
  #                                     /|\
  #                                    /|||\
  #                                     |||
  #
  #            DONE: ADD SUPPORTED LANGUAGES HERE (ISO 639-1 CODES)
  #-----------------------------------------------------------------------------

  #=============================================================================
  #  CUSTOM
  #=============================================================================
  #-----------------------------------------------------------------------------
  #         DONE: PUBLISH YOUR CUSTOM LANGUAGE-SPECIFIC STRINGS <L_...>
  #               (DEFINED IN '/src/lang/run.<ll>.lang.sh') HERE
  #
  #                                     |||
  #                                    \|||/
  #                                     \|/
  #-----------------------------------------------------------------------------
  eval "readonly TXT_ARGS_CHECK_ERR_ARG_FILE_IN=\${LIB_SHTPL_${ID_LANG}_TXT_FILE_NOT_FOUND}"
  eval "readonly TXT_ARGS_CHECK_ERR_ARG_FILE_OUT=\${LIB_SHTPL_${ID_LANG}_TXT_FILE_ALREADY_EXISTS}"
  #-----------------------------------------------------------------------------
  #                                    /|\
  #                                   /|||\
  #                                    |||
  #
  #         DONE: PUBLISH YOUR CUSTOM LANGUAGE-SPECIFIC STRINGS <L_...>
  #               (DEFINED IN '/src/lang/run.<ll>.lang.sh') HERE
  #-----------------------------------------------------------------------------

  #=============================================================================
  #  TEMPLATE - DO NOT EDIT
  #=============================================================================
  eval "readonly TXT_ARGS_CHECK_ERR=\${LIB_SHTPL_${ID_LANG}_TXT_ARGS_CHECK_ERR}"
  eval "readonly TXT_ARGS_READ_ERR=\${LIB_SHTPL_${ID_LANG}_TXT_ARGS_READ_ERR}"
  eval "readonly TXT_CONTINUE_ENTER=\${LIB_SHTPL_${ID_LANG}_TXT_CONTINUE_ENTER}"
  eval "readonly TXT_CONTINUE_YESNO=\${LIB_SHTPL_${ID_LANG}_TXT_CONTINUE_YESNO}"
  eval "readonly TXT_INIT_CHECK_ERR=\${LIB_SHTPL_${ID_LANG}_TXT_INIT_CHECK_ERR}"
  eval "readonly TXT_INIT_CHECK_ERR_LOGSERVICE=\${LIB_SHTPL_${ID_LANG}_TXT_INIT_CHECK_ERR_LOGSERVICE}"
  eval "readonly TXT_INIT_CHECK_WARN=\${LIB_SHTPL_${ID_LANG}_TXT_INIT_CHECK_WARN}"
  eval "readonly TXT_INIT_FIRST_INFO=\${LIB_SHTPL_${ID_LANG}_TXT_INIT_FIRST_INFO}"
  eval "readonly TXT_INIT_UPDATE_ERR=\${LIB_SHTPL_${ID_LANG}_TXT_INIT_UPDATE_ERR}"
  eval "readonly TXT_INVALID_ARG_1=\${LIB_SHTPL_${ID_LANG}_TXT_INVALID_ARG_1}"
  eval "readonly TXT_INVALID_ARG_2=\${LIB_SHTPL_${ID_LANG}_TXT_INVALID_ARG_2}"
  eval "readonly TXT_PROCESSING=\${LIB_SHTPL_${ID_LANG}_TXT_PROCESSING}"
}

#===  FUNCTION  ================================================================
#         NAME:  init_update
#  DESCRIPTION:  Update global variables/constants and perform initialization
#                commands that should be executed after argument parsing
#      OUTPUTS:  An error message to <stderr> and/or <syslog>
#                in case an error occurs
#   RETURNS  0:  Success
#            1:  Error
#===============================================================================
init_update() {
  #-----------------------------------------------------------------------------
  #                   DONE: DEFINE YOUR UPDATE COMMANDS HERE
  #
  #                                     |||
  #                                    \|||/
  #                                     \|/
  #-----------------------------------------------------------------------------
  true                                                                      || \
  #-----------------------------------------------------------------------------
  #                                     /|\
  #                                    /|||\
  #                                     |||
  #
  #                   DONE: DEFINE YOUR UPDATE COMMANDS HERE
  #-----------------------------------------------------------------------------
  { error "${TXT_INIT_UPDATE_ERR}"
    return 1
  }
}

#===  FUNCTION  ================================================================
#         NAME:  main
#  DESCRIPTION:  Main function
#      OUTPUTS:  (See functions listed below)

#                In case an error occurs during <init_...()> or <args_...()>:
#                  An error message will be printed to <stderr> and/or <syslog>,
#                  the script's help will be automatically shown, and the script
#                  exits with '1'.
#
#      RETURNS:  (See functions listed below)
#===============================================================================
main() {
  #-----------------------------------------------------------------------------
  #  DO NOT EDIT
  #-----------------------------------------------------------------------------
  #   init_lang         Set language-specific text constants
  #
  #   init_first        Set default log destination, lock the script (PID file)
  #                     install trap handler and run other commands that need
  #                     to be executed right at the beginning
  #
  #   init_check_pre    Check script requirements (before argument parsing)
  #
  #   args_read         Read/Parse arguments
  #
  #   args_check        Check if passed arguments are valid
  #
  #   init_update       Update global variables/constants and perform
  #                     initialization commands that should be executed after
  #                     argument parsing
  #
  #   init_check_post   Check script requirements (after argument parsing)
  #
  #   main_daemon       Main subfunction (daemon mode)
  #   main_interactive  Main subfunction (interactive / submenu mode)
  #   main_script       Main subfunction (script mode)
  #-----------------------------------------------------------------------------
  init_lang                                                                 && \
  init_first                                                                && \
  init_check_pre                                                            && \
  args_read "$@"                                                            && \
  case "${arg_mode}" in
    ${ARG_MODE_DAEMON}|${ARG_MODE_INTERACTIVE_SUBMENU}|${ARG_MODE_SCRIPT})
      args_check      && \
      init_update     && \
      init_check_post
      ;;
    ${ARG_MODE_INTERACTIVE})
      # For further init functions see <main_interactive()>
      lib_core_is --cmd dialog || \
      error "${TXT_INIT_CHECK_ERR}"
      ;;
  esac                                                                      || \

  # If any error occurred show help but wait some seconds before
  # (to allow the user to read error/warning messages)
  { lib_core_is --terminal-stdout && { sleep 3; help; }; return 1; }

  # Run mode-specific subfunctions
  case "${arg_mode}" in
    ${ARG_MODE_DAEMON}) main_daemon ;;
    ${ARG_MODE_INTERACTIVE}|${ARG_MODE_INTERACTIVE_SUBMENU}) main_interactive || return $? ;;
    ${ARG_MODE_SCRIPT}) main_script ;;
  esac
}

#===  FUNCTION  ================================================================
#         NAME:  main_daemon
#  DESCRIPTION:  Main subfunction (daemon mode)
#===============================================================================
main_daemon() {
  #-----------------------------------------------------------------------------
  #  DO NOT EDIT
  #-----------------------------------------------------------------------------
  # Create subshell PID directory (removed in <trap_main()>)
  lib_core_sudo mkdir -p "${I_DIR_PID}"                                     || \
  { error "Could not create subshell PID directory at <${I_DIR_PID}>. Aborting..."
    return 1
  }

  #-----------------------------------------------------------------------------
  #             DONE: DEFINE YOUR MAIN FUNCTION (DAEMON MODE) HERE
  #
  #                                     |||
  #                                    \|||/
  #                                     \|/
  #-----------------------------------------------------------------------------
  true
  #-----------------------------------------------------------------------------
  #                                     /|\
  #                                    /|||\
  #                                     |||
  #
  #             DONE: DEFINE YOUR MAIN FUNCTION (DAEMON MODE) HERE
  #-----------------------------------------------------------------------------
}

#===  FUNCTION  ================================================================
#         NAME:  main_interactive
#  DESCRIPTION:  Main subfunction (interactive / submenu mode)
#===============================================================================
main_interactive() {
  # Check for minimum terminal size (otherwise some dialogues would fail)
  lib_msg_dialog_autosize >/dev/null                                        && \

  # Show welcome message (but not in submenu mode)
  if [ "${arg_mode}" = "${ARG_MODE_INTERACTIVE}" ]; then
    lib_shtpl_about --dialog
  fi                                                                        && \

  #-----------------------------------------------------------------------------
  #          DONE: INSERT COMMANDS HERE THAT RUN ONCE AT THE BEGINNING
  #                   (DO NOT FORGET THE TERMINATING '&& \')
  #
  #                                     |||
  #                                    \|||/
  #                                     \|/
  #-----------------------------------------------------------------------------
  true                                                                      && \
  #-----------------------------------------------------------------------------
  #                                     /|\
  #                                    /|||\
  #                                     |||
  #
  #          DONE: INSERT COMMANDS HERE THAT RUN ONCE AT THE BEGINNING
  #                   (DO NOT FORGET THE TERMINATING '&& \')
  #-----------------------------------------------------------------------------

  if [ "${arg_mode}" = "${ARG_MODE_INTERACTIVE}" ]; then
    #---------------------------------------------------------------------------
    #         DONE: INSERT COMMANDS HERE THAT RUN ONCE AT THE BEGINNING
    #                     EXCEPT WHEN BEING IN SUBMENU MODE
    #                  (DO NOT FORGET THE TERMINATING '&& \')
    #
    #                                    |||
    #                                   \|||/
    #                                    \|/
    #---------------------------------------------------------------------------
    true && \
    #---------------------------------------------------------------------------
    #                                    /|\
    #                                   /|||\
    #                                    |||
    #
    #         DONE: INSERT COMMANDS HERE THAT RUN ONCE AT THE BEGINNING
    #                     EXCEPT WHEN BEING IN SUBMENU MODE
    #                  (DO NOT FORGET THE TERMINATING '&& \')
    #---------------------------------------------------------------------------

    #---------------------------------------------------------------------------
    #  DO NOT EDIT
    #---------------------------------------------------------------------------
    args_check          && \
    init_update         && \
    init_check_post
  fi                                                                        && \

  # Endless loop until user exits
  local exitcode                                                            && \
  while menu_main || { clear; false; }; do
    exitcode="0"
    case "${arg_action}" in
      "")
        # See comment at the end of menu_main() function
        if [ "${arg_mode}" = "${ARG_MODE_INTERACTIVE_SUBMENU}" ]; then
          # 'submenu' mode: user has cancelled 'dialog' so exit with error
          return 2
        else
          # other modes: run cleanup procedure and get back to main menu
          cleanup_interactive
          continue
        fi
        ;;

      #-------------------------------------------------------------------------
      #    DONE: ADD <ARG_ACTION_...> WHERE PROMPT TO CONTINUE IS NOT NEEDED
      #
      #                                   |||
      #                                  \|||/
      #                                   \|/
      #-------------------------------------------------------------------------
      ${ARG_ACTION_ABOUT}|${ARG_ACTION_HELP}|${ARG_ACTION_EXIT}|\
      ${ARG_ACTION_PRINT})
        run || exitcode="$?"
        ;;
      #-------------------------------------------------------------------------
      #                                   /|\
      #                                  /|||\
      #                                   |||
      #
      #    DONE: ADD <ARG_ACTION_...> WHERE PROMPT TO CONTINUE IS NOT NEEDED
      #-------------------------------------------------------------------------

      *)
        # Run a certain command and prompt the user to continue
        clear
        lib_msg_print_heading -201 "${TXT_PROCESSING}"
        run || exitcode="$?"
        # No prompt in submenu mode
        if [ "${arg_mode}" = "${ARG_MODE_INTERACTIVE}" ]; then
          lib_msg_print_heading -2 "${TXT_CONTINUE_ENTER}"
          read -r dummy
        fi
        ;;
    esac

    # Submenu mode means "run a certain sub-menu and exit"
    [ "${arg_mode}" = "${ARG_MODE_INTERACTIVE_SUBMENU}" ] && return ${exitcode}

    # Run cleanup procedure
    cleanup_interactive
  done
}

#===  FUNCTION  ================================================================
#         NAME:  main_script
#  DESCRIPTION:  Main subfunction (script mode)
#===============================================================================
main_script() {
  run
}

#===  FUNCTION  ================================================================
#         NAME:  msg
#  DESCRIPTION:  Log/Print error/info/warning message and optionally exit
#          ...:  See <lib_shtpl_message()> in
#                '/lib/SHtemplateLIB/lib/shtpl.0.lib.sh'
#===============================================================================
msg() {
  lib_shtpl_message "$@"
}

#===  FUNCTION  ================================================================
#         NAME:  run
#  DESCRIPTION:  Perform one certain action (cycle)
#      OUTPUTS:  Depends on <arg_action>
#      RETURNS:  Depends on <arg_action>
#===============================================================================
run() {
  case "${arg_action}" in
    #---------------------------------------------------------------------------
    #  TEMPLATE - DO NOT EDIT
    #---------------------------------------------------------------------------
    ${ARG_ACTION_ABOUT})        lib_shtpl_about --dialog ;;
    ${ARG_ACTION_EXIT})         clear; exit ;;
    ${ARG_ACTION_HELP})         help ;;

    #---------------------------------------------------------------------------
    #  CUSTOM
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    #               DONE: ADD YOUR ACTION-SPECIFIC COMMANDS HERE
    #
    #                                    |||
    #                                   \|||/
    #                                    \|/
    #---------------------------------------------------------------------------
    ${ARG_ACTION_CREATE})
      create "${arg_file_in}" "${arg_file_out}" && \
      # If there is a graphical environment open the file explorer
      if lib_core_is --not-empty "${DISPLAY}"; then
        xdg-open "${arg_file_out}"
      fi
      ;;

    ${ARG_ACTION_PRINT})        menu_print ;;
    #---------------------------------------------------------------------------
    #                                    /|\
    #                                   /|||\
    #                                    |||
    #
    #               DONE: ADD YOUR ACTION-SPECIFIC COMMANDS HERE
    #---------------------------------------------------------------------------
  esac
}

#===  FUNCTION  ================================================================
#         NAME:  trap_main
#  DESCRIPTION:  Trap (cleanup and exit) function for this script
#      GLOBALS:  trap_triggered
# PARAMETER  1:  Signal (EXIT|HUP|INT|QUIT|TERM|...)
#            2:  Kill subshells / child processes? (true|false)
#                (default: 'true')
#            3:  Subshell(s) PID directory
#                (default: '/var/run/$(basename "$0")')
#            4:  Subshell(s) PID file extension (default: 'pid')
#            5:  Operation mode (see <arg_mode> above)
#===============================================================================
trap_main() {
  local arg_signal="${1:-${trap_main_arg_signal}}"
  local arg_sub_kill="${2:-${trap_main_arg_sub_kill:-true}}"
  local arg_sub_pid_dir="${3:-${trap_main_arg_sub_pid_dir:-/var/run/$(basename "$0")}}"
  local arg_sub_pid_ext="${4:-${trap_main_arg_sub_pid_ext:-pid}}"
  local arg_mode="${5:-${trap_main_arg_mode}}"

  #-----------------------------------------------------------------------------
  #       DONE: ADD FURTHER TRAP PARAMETERS HERE (AND IN <init_first()>)
  #
  #                                     |||
  #                                    \|||/
  #                                     \|/
  #-----------------------------------------------------------------------------
  #  IMPORTANT: For each parameter please set its temporary variable (see below,
  #             in the next 'TODO' section) as the default value, e.g.
  #               local arg_myparam="${3:-${trap_main_arg_myparam}}"
  #-----------------------------------------------------------------------------
  #                                     /|\
  #                                    /|||\
  #                                     |||
  #
  #       DONE: ADD FURTHER TRAP PARAMETERS HERE (AND IN <init_first()>)
  #-----------------------------------------------------------------------------

  #-----------------------------------------------------------------------------
  #  DO NOT EDIT
  #-----------------------------------------------------------------------------
  #  Do not run trap handling immediately if it was previously blocked
  trap_triggered="true"
  if ${trap_blocked}; then
    #  Do not continue trap function but save the trap arguments for the next
    #  run (then the trap is manually triggered so probably no arguments will
    #  be passed and therefore need to be restored from the temporary variables)
    trap_main_arg_signal="${arg_signal}"
    trap_main_arg_sub_kill="${arg_sub_kill}"
    trap_main_arg_sub_pid_dir="${arg_sub_pid_dir}"
    trap_main_arg_sub_pid_ext="${arg_sub_pid_ext}"
    trap_main_arg_mode="${arg_mode}"

    #---------------------------------------------------------------------------
    #          DONE: FOR EACH ADDITIONAL TRAP PARAMETER DEFINED ABOVE
    #                    ADD ANOTHER TEMPORARY VARIABLE HERE
    #
    #                                     |||
    #                                    \|||/
    #                                     \|/
    #---------------------------------------------------------------------------
    #  Example: For <arg_myparam> add the following line:
    #             trap_main_arg_myparam="${arg_myparam}"
    #---------------------------------------------------------------------------
    #                                     /|\
    #                                    /|||\
    #                                     |||
    #
    #          DONE: FOR EACH ADDITIONAL TRAP PARAMETER DEFINED ABOVE
    #                    ADD ANOTHER TEMPORARY VARIABLE HERE
    #---------------------------------------------------------------------------

    return
  fi

  #  Get PID (if PID lock is disabled ("PIDLOCK_ENABLED"="false"), then
  #  <lib_os_ps_pidlock()> will fail.)
  local pid
  pid="$(lib_os_ps_pidlock --getpid)" || \
  lib_os_ps_get_ownpid pid
  info --syslog "Signal <${arg_signal}> received. Terminating (PID <${pid}>) ..."

  # Special Trap Handling
  case "${arg_mode}" in
    #---------------------------------------------------------------------------
    #          DONE: DEFINE MODE(S) THAT HAVE NO SPECIAL TRAP HANDLING
    #
    #                                    |||
    #                                   \|||/
    #                                    \|/
    #---------------------------------------------------------------------------
    ${ARG_MODE_DAEMON})
    #---------------------------------------------------------------------------
    #                                    /|\
    #                                   /|||\
    #                                    |||
    #
    #          DONE: DEFINE MODE(S) THAT HAVE NO SPECIAL TRAP HANDLING
    #---------------------------------------------------------------------------
      ;;

    *)
      # Modes with special trap handling
      case "${arg_signal}" in
        EXIT)
          #---------------------------------------------------------------------
          #          DONE: PUT ANY COMMANDS HERE THAT WILL BE EXECUTED
          #             IN CASE OF A NORMAL EXIT (NO OTHER SIGNAL)
          #
          #                                 |||
          #                                \|||/
          #                                 \|/
          #---------------------------------------------------------------------
          rm -f "${file_out_aux}" "${file_out_log}" "${file_tmp}"
          case "${arg_action}" in
            ${ARG_ACTION_PRINT}) rm -f "${file_out_pdf}" ;;
          esac
          #---------------------------------------------------------------------
          #                                 /|\
          #                                /|||\
          #                                 |||
          #
          #          DONE: PUT ANY COMMANDS HERE THAT WILL BE EXECUTED
          #             IN CASE OF A NORMAL EXIT (NO OTHER SIGNAL)
          #---------------------------------------------------------------------
          ;;

        *)
          #---------------------------------------------------------------------
          #          DONE: PUT ANY COMMANDS HERE THAT WILL BE EXECUTED
          #              IN CASE OF ANY INTERRUPT/TERM/... SIGNAL
          #
          #                                 |||
          #                                \|||/
          #                                 \|/
          #---------------------------------------------------------------------
          rm -f "${file_out_aux}" "${file_out_log}" "${file_out_pdf}" "${file_tmp}"
          #---------------------------------------------------------------------
          #                                 /|\
          #                                /|||\
          #                                 |||
          #
          #          DONE: PUT ANY COMMANDS HERE THAT WILL BE EXECUTED
          #              IN CASE OF ANY INTERRUPT/TERM/... SIGNAL
          #---------------------------------------------------------------------
          ;;
      esac
      ;;
  esac

  #-----------------------------------------------------------------------------
  #  DO NOT EDIT
  #-----------------------------------------------------------------------------
  if ${arg_sub_kill}; then
    # SIGINT and SIGQUIT cannot be forwarded to subshells / child processes
    # as they may run in background (asynchronously).
    local sub_signal
    case "${arg_signal}" in
      INT|QUIT) sub_signal="TERM" ;;
      *)        sub_signal="${arg_signal}" ;;
    esac

    # Kill subshells / child processes
    local file
    for file in "${arg_sub_pid_dir}"/*."${arg_sub_pid_ext}"; do
      [ -f "${file}" ] || break
      lib_os_ps_kill_by_pidfile \
        "${file}" "${sub_signal}" "false" "true" "true" "false"
    done

    # Kill (other) subshells / child processes
    local subpids
    lib_os_ps_get_descendants subpids "${pid}"
    lib_os_ps_kill_by_pid "${subpids}" "${sub_signal}" "false" "true" "true"

    # Remove subshell PID directory
    if lib_core_is --dir "${arg_sub_pid_dir}"; then
      lib_core_sudo rm -rf "${arg_sub_pid_dir}"
    fi
  fi

  #  Remove (parent) PID file
  #  If PID lock is disabled ("PIDLOCK_ENABLED"="false"), then
  #  <lib_os_ps_pidlock()> will fail but without any consequences.
  lib_os_ps_pidlock --unlock
  info --syslog "Script terminated (PID <${pid}>)."

  #  Exit - Depends on signal ...
  case "${arg_signal}" in
    EXIT)
      # ... EXIT
      exit ;;
    *)
      # ... other signals:
      # Clear EXIT trap handling, otherwise <trap_main()> would run again.
      trap - EXIT; exit 1 ;;
  esac
}

#===  FUNCTION  ================================================================
#         NAME:  warning
#  DESCRIPTION:  Log/Print warning message and optionally exit
#          ...:  See <msg()>
#===============================================================================
warning() {
  msg --warning "$@"
}

#===============================================================================
#  FUNCTIONS (TEMPLATE) (MENUS)
#===============================================================================
#===  FUNCTION  ================================================================
#         NAME:  menu_arg_action
#  DESCRIPTION:  Interactive menu for setting <arg_action> parameter
#      GLOBALS:  arg_action
#   RETURNS  0:  Parameter successfully changed
#            1:  Error or user interrupt
#===============================================================================
menu_arg_action() {
  local tag1="${ARG_ACTION_ABOUT}"
  local tag2="${ARG_ACTION_HELP}"
  local tag3="${ARG_ACTION_EXIT}"

  local title
  local text
  eval "title=\${L_TEX_${ID_LANG}_DLG_TTL_ARG_ACTION}"
  eval "text=\${L_TEX_${ID_LANG}_DLG_TXT_ARG_ACTION}"
  eval "item1=\${LIB_SHTPL_${ID_LANG}_DLG_ITM_ABOUT}"
  eval "item2=\${LIB_SHTPL_${ID_LANG}_DLG_ITM_HELP}"
  eval "item3=\${LIB_SHTPL_${ID_LANG}_DLG_ITM_EXIT}"

  local list
  list="${ARG_ACTION_LIST_INTERACTIVE}"

  local OLDIFS="$IFS"
  local IFS="$IFS"

  local dlgpairs
  local result
  local exitcode="0"
  exec 3>&1
    dlgpairs="$(for a in ${list}; do
        eval "tag=\${ARG_ACTION_${a}}"
        eval "item=\${L_TEX_${ID_LANG}_DLG_ITM_ARG_ACTION_${a}}"
        printf "%s\n%s\n" "${tag}" "${item}"
      done)"                                                                && \
    IFS="${LIB_C_STR_NEWLINE}"                                              && \
    result="$(dialog --title "${title}" --menu "${text}" 0 0 0  \
      ${dlgpairs}                                               \
      "${tag1}"  "${item1}"                                     \
      "${tag2}"  "${item2}"                                     \
      "${tag3}"  "${item3}" 2>&1 1>&3)"                                     || \
    exitcode="$?"
  exec 3>&-

  IFS="$OLDIFS"

  if [ "${exitcode}" -eq "0" ]; then arg_action="${result}"; fi
  return ${exitcode}
}

#===  FUNCTION  ================================================================
#         NAME:  menu_main
#  DESCRIPTION:  Main menu (interactive mode)
#===============================================================================
menu_main() {
  # Check for minimum terminal size (otherwise some dialogues would fail)
  lib_msg_dialog_autosize >/dev/null                                        || \
  { sleep 3; return 1; }

  # <arg_action> can be already set if script is called with <--submenu ...>
  if [ "${arg_mode}" = "${ARG_MODE_INTERACTIVE}" ]; then
    menu_arg_action || return
  fi                                                                        && \

  #  Default actions do not depend on any further parameter
  case "${arg_action}" in
    ${ARG_ACTION_ABOUT}|${ARG_ACTION_EXIT}|${ARG_ACTION_HELP}) return ;;
  esac                                                                      && \
  #-----------------------------------------------------------------------------
  #                    DONE: DEFINE YOUR MENU HANDLING HERE
  #                   (DO NOT FORGET THE TERMINATING '|| \')
  #
  #                                     |||
  #                                    \|||/
  #                                     \|/
  #-----------------------------------------------------------------------------
  case "${arg_mode}" in
    ${ARG_MODE_INTERACTIVE})
      case "${arg_action}" in
        ${ARG_ACTION_ABOUT}|${ARG_ACTION_EXIT}|${ARG_ACTION_HELP}) ;;
        *)
          menu_arg_file_in                                  && \

          case "${arg_action}" in
            ${ARG_ACTION_CREATE}) menu_arg_file_out ;;
          esac                                              && \

          menu_arg_recp_name                                && \
          menu_arg_recp_addr
          ;;
      esac
      ;;

    ${ARG_MODE_INTERACTIVE_SUBMENU})
      case "${arg_action}" in
        ${ARG_ACTION_ABOUT}|${ARG_ACTION_EXIT}|${ARG_ACTION_HELP}) ;;
        *)
          if lib_core_is --empty "${arg_file_in}"; then menu_arg_file_in; fi      && \
          if lib_core_is --empty "${arg_recp_name}"; then menu_arg_recp_name; fi  && \
          if lib_core_is --empty "${arg_recp_addr}"; then menu_arg_recp_addr; fi
          ;;
      esac
      ;;
  esac                                                                      || \
  #-----------------------------------------------------------------------------
  #                                     /|\
  #                                    /|||\
  #                                     |||
  #
  #                   DONE: DEFINE YOUR UPDATE COMMANDS HERE
  #                   (DO NOT FORGET THE TERMINATING '|| \')
  #-----------------------------------------------------------------------------

  # Make sure that <main()> loop does not break if one of the menus above
  # throws an error but also do not perform any action in <run()> function.
  arg_action=""
}

#===============================================================================
#  FUNCTIONS (CUSTOM)
#===============================================================================
#                     DONE: DEFINE YOUR OWN FUNCTIONS HERE
#
#                                      |||
#                                     \|||/
#                                      \|/
#===============================================================================
#===  FUNCTION  ================================================================
#         NAME:  create
#  DESCRIPTION:  Create '.pdf' file out of '.tex' file
# PARAMETER  1:  Input '.tex' file (full path)
#            2:  Output '.pdf' file (full path)
#   RETURNS  0:  PDF file successfully created
#            1:  Error
#===============================================================================
create() {
  local arg_file_in="$1"
  local arg_file_out="$2"

  local file_in_dir="$(lib_core_file_get --dir "${arg_file_in}")"
  local file_in_name="$(lib_core_file_get --name "${arg_file_in}")"
  local file_out_dir="$(lib_core_file_get --dir "${arg_file_out}")"
  local file_out_name="$(lib_core_file_get --name "${arg_file_out}")"

  # Determine auxiliary file paths
  file_out_aux="${file_out_dir}/${file_out_name}.aux"
  file_out_log="${file_out_dir}/${file_out_name}.log"
  file_out_pdf="${file_out_dir}/${file_out_name}.pdf"

  local exitcode="0"
  lib_core_file_touch "${file_out_aux}" "${file_out_log}" "${file_out_pdf}" && \
  { chmod 600 "${file_out_aux}" "${file_out_log}" "${file_out_pdf}"   && \

    ( # Use subshell to ensure that any modifications on variables
      # are just temporary

      # Escape (La)TeX special characters in <arg_recp_addr>, <arg_recp_name>,
      # and in any custom environment variable that has been specified
      # in <arg_vars> (contains identifiers, no values)
      #   https://tex.stackexchange.com/a/34586
      for var in arg_recp_addr arg_recp_name ${arg_vars} ; do
        # Get variable's value
        eval "val=\${${var}}"

        # Escape (La)TeX special characters
        val="$(lib_core_str_replace_substr "${val}" "\\\\" "\\\\textbackslash")"
        val="$(lib_core_str_replace_substr "${val}" "\([%\${_>#&}§<]\)" "\\\\\1")"
        val="$(lib_core_str_replace_substr "${val}" "~" "\\\\textasciitilde")"
        val="$(lib_core_str_replace_substr "${val}" "\^" "\\\\textasciicircum")"

        # (La)TeX expects '\\' instead of '\n' for newline
        val="$(lib_core_str_remove_newline "${val}" "\\\\\\")"

        # Set original variable
        eval ${var}=\"\${val}\"
      done

      # Export recipient-related variables that <arg_file_in> expects
      export arg_recp_addr arg_recp_name

      # Finally, create '.pdf' file
      cd "${file_in_dir}"
      lualatex                                    \
        --halt-on-error                           \
        --jobname="${file_out_name}"              \
        --output-directory="${file_out_dir}"      \
        "${file_in_name}"
    )                                                                 || \
    exitcode="$?"

    rm -f "${file_out_aux}" "${file_out_log}"
    if [ "${exitcode}" -ne "0" ]; then rm -f "${file_out_pdf}"; fi
  }

  return ${exitcode}
}
#===============================================================================
#                                      /|\
#                                     /|||\
#                                      |||
#
#                     DONE: DEFINE YOUR OWN FUNCTIONS HERE
#===============================================================================

#===============================================================================
#  FUNCTIONS (CUSTOM) (MENUS)
#===============================================================================
#                    DONE: DEFINE YOUR OWN DIALOG MENUS HERE
#
#                                      |||
#                                     \|||/
#                                      \|/
#===============================================================================
#===  FUNCTION  ================================================================
#         NAME:  menu_print
#  DESCRIPTION:  Create '.pdf' file out of '.tex' file and print it
#   RETURNS  0:  File successfully printed
#            1:  Error or user interrupt
#===============================================================================
menu_print() {
  local title
  local text1
  local text2
  eval "title=\${LIB_SHTPL_${ID_LANG}_DLG_TTL_ERROR}"
  eval "text1=\${L_TEX_${ID_LANG}_DLG_TXT_PRINT_1}"
  eval "text2=\${L_TEX_${ID_LANG}_DLG_TXT_PRINT_2}"

  file_out_pdf="/tmp/$(lib_core_file_get --name "${I_FILE_SH_TEX}").$(date +%s).pdf"

  local exitcode="0"
  # Step 1 - Create '.pdf' file out of '.tex' file
  { create "${arg_file_in}" "${file_out_pdf}" || \
    { exitcode="$?"
      lib_msg_print_heading -2 "${TXT_CONTINUE_ENTER}"
      read -r dummy
      dialog --title "${title}" --msgbox "${text1}" 0 0
      false
    }
  }                                                           && \

  # Step 2 - Print '.pdf' file
  while ! "${I_FILE_SH_CUPS}" --print "${file_out_pdf}"; do
    dialog --title "${title}" --yesno "${text2}" 0 0 || \
    { exitcode="$?"; break; }
  done

  rm -f "${file_out_pdf}"

  return ${exitcode}
}
#===============================================================================
#                                      /|\
#                                     /|||\
#                                      |||
#
#                    DONE: DEFINE YOUR OWN DIALOG MENUS HERE
#===============================================================================

#===============================================================================
#  FUNCTIONS (CUSTOM) (MENUS) (PARAMETERS/VARIABLES)
#===============================================================================
#               DONE: DEFINE PARAMETER/VARIABLE DIALOG MENUS HERE
#
#                                      |||
#                                     \|||/
#                                      \|/
#===============================================================================
#===  FUNCTION  ================================================================
#         NAME:  menu_arg_file_in
#  DESCRIPTION:  Interactive menu for setting <arg_file_in> parameter
#      GLOBALS:  arg_file_in
#   RETURNS  0:  Parameter successfully changed
#            1:  Error or user interrupt
#===============================================================================
menu_arg_file_in() {
  local title
  local text
  eval "title=\${L_TEX_${ID_LANG}_DLG_TTL_ARG_FILE_IN}"
  eval "text=\${L_TEX_${ID_LANG}_DLG_TXT_ARG_FILE_IN}"

  local result
  local exitcode
  exec 3>&1
    while true; do
      exitcode="0"
      dialog --title "${title}" --msgbox "${text}" 0 0                      && \
      result="$(dialog --title "${title}"                                   \
        --fselect "${result:-${arg_file_in:-${I_FILE_TEX_LETTER}}}" 0 0 2>&1 1>&3)" && \
#        --fselect "${result:-${arg_file_in:-~/}}" 0 0 2>&1 1>&3)"           && \
      result="$(lib_core_expand_tilde "${result}")"                         || \
      exitcode="$?"

      # Continue loop in case file does not exist but yet accept cancelling
      case "${exitcode}" in
        0) lib_core_is --file "${result}" && break ;;
        *) break ;;
      esac
    done
  exec 3>&-

  if [ "${exitcode}" -eq "0" ]; then arg_file_in="${result}"; fi
  return ${exitcode}
}

#===  FUNCTION  ================================================================
#         NAME:  menu_arg_file_out
#  DESCRIPTION:  Interactive menu for setting <arg_file_out> parameter
#      GLOBALS:  arg_file_out
#   RETURNS  0:  Parameter successfully changed
#            1:  Error or user interrupt
#===============================================================================
menu_arg_file_out() {
  local title
  local text
  eval "title=\${L_TEX_${ID_LANG}_DLG_TTL_ARG_FILE_OUT}"
  eval "text=\${L_TEX_${ID_LANG}_DLG_TXT_ARG_FILE_OUT}"

  local result
  local exitcode
  exec 3>&1
    while true; do
      exitcode="0"
      dialog --title "${title}" --msgbox "${text}" 0 0                      && \
      result="$(dialog --title "${title}"                                   \
        --fselect "${result:-${arg_file_out:-~/}}" 0 0 2>&1 1>&3)"          && \
      result="$(lib_core_expand_tilde "${result}")"                         || \
      exitcode="$?"

      # Continue loop in case <result> is not a valid file path
      # (or already exists) but yet accept cancelling
      case "${exitcode}" in
        0)
          touch -c "${result}" 2>/dev/null && \
          ! lib_core_is --file "${result}" && \
          break
          ;;
        *)
          break
          ;;
      esac
    done
  exec 3>&-

  if [ "${exitcode}" -eq "0" ]; then arg_file_out="${result}"; fi
  return ${exitcode}
}

#===  FUNCTION  ================================================================
#         NAME:  menu_arg_recp_addr
#  DESCRIPTION:  Interactive menu for setting <arg_recp_addr> parameter
#      GLOBALS:  arg_recp_addr
#   RETURNS  0:  Parameter successfully changed
#            1:  Error or user interrupt
#===============================================================================
menu_arg_recp_addr() {
  file_tmp="/tmp/$(lib_core_file_get --file "${I_FILE_SH_TEX}").$(date +%s).tmp"
  lib_core_file_touch "${file_tmp}"  && \
  chmod 600 "${file_tmp}"            || \
  return

  local title
  local text
  local str
  eval "title=\${L_TEX_${ID_LANG}_DLG_TTL_ARG_RECP_ADDR}"
  eval "text=\${L_TEX_${ID_LANG}_DLG_TXT_ARG_RECP_ADDR}"
  eval "str=\${L_TEX_${ID_LANG}_DLG_STR_ARG_RECP_ADDR}"

  local result
  local exitcode
  exec 3>&1
    while true; do
      exitcode="0"
      printf "%s" "${arg_recp_addr:-${str}}" > "${file_tmp}"              && \
      dialog --title "${title}" --msgbox "${text}" 0 0                    && \
      result="$(                                                          \
        dialog --title "${title}" --editbox "${file_tmp}" 0 0 2>&1 1>&3)" || \
      exitcode="$?"

      # Continue loop in case string is empty but yet accept canceling
      if lib_core_is --not-empty "${result}" || [ "${exitcode}" -ne 0 ]; then
        break
      fi
    done
  exec 3>&-

  rm -f "${file_tmp}"

  if [ "${exitcode}" -eq "0" ]; then arg_recp_addr="${result}"; fi
  return ${exitcode}
}

#===  FUNCTION  ================================================================
#         NAME:  menu_arg_recp_name
#  DESCRIPTION:  Interactive menu for setting <menu_arg_recp_name> parameter
#      GLOBALS:  menu_arg_recp_name
#   RETURNS  0:  Parameter successfully changed
#            1:  Error or user interrupt
#===============================================================================
menu_arg_recp_name() {
  local title
  local text
  local str
  eval "title=\${L_TEX_${ID_LANG}_DLG_TTL_ARG_RECP_NAME}"
  eval "text=\${L_TEX_${ID_LANG}_DLG_TXT_ARG_RECP_NAME}"
  eval "str=\${L_TEX_${ID_LANG}_DLG_STR_ARG_RECP_NAME}"

  local result
  local exitcode
  exec 3>&1
    while true; do
      exitcode="0"
      result="$(dialog --title "${title}" --inputbox "${text}" 0 0  \
        "${arg_recp_name:-${str}}" 2>&1 1>&3)"                      || \
      exitcode="$?"

      # Continue loop in case string is empty but yet accept canceling
      if lib_core_is --not-empty "${result}" || [ "${exitcode}" -ne 0 ]; then
        break
      fi
    done
  exec 3>&-

  if [ "${exitcode}" -eq "0" ]; then arg_recp_name="${result}"; fi
  return ${exitcode}
}
#===============================================================================
#                                      /|\
#                                     /|||\
#                                      |||
#
#               DONE: DEFINE PARAMETER/VARIABLE DIALOG MENUS HERE
#===============================================================================

#===============================================================================
#  MAIN
#===============================================================================
main "$@"