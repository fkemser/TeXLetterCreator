#!/bin/sh
#
# SPDX-FileCopyrightText: Copyright (c) 2022-2024 Florian Kemser and the CUPSwrapper contributors
# SPDX-License-Identifier: GPL-3.0-or-later
#
#===============================================================================
#
#         FILE:   /src/cups.sh
#
#        USAGE:   Run <cups.sh -h> for more information
#
#  DESCRIPTION:   CUPSwrapper Run File
#
#      OPTIONS:   Run <cups.sh -h> for more information
#
# REQUIREMENTS:   Run <cups.sh -h> for more information
#
#         BUGS:   ---
#
#        NOTES:   Please edit the configuration file (/etc/cups.cfg.sh)
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
readonly ARG_LOGDEST_SYSLOG="syslog"              # System log
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
readonly ARG_ACTION_ADD="add"
readonly ARG_ACTION_CANCELJOB="canceljob"
readonly ARG_ACTION_DEFAULT="default"
readonly ARG_ACTION_DEFSETTINGS="defsettings"
readonly ARG_ACTION_JOBSETTINGS="jobsettings"
readonly ARG_ACTION_PRINT="print"
readonly ARG_ACTION_REMOVE="remove"
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
# Argument that either takes an argument
# or, if not set, <stdin>'s content, see <args_read()>
arg_arg_or_stdin=""

arg_file=""                 # File (to print)
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
# Print jobs
joblist=""

# Number of (print job) copies
readonly JOB_COPIES_MIN="1"
readonly JOB_COPIES_MAX="999"
job_copies="1"

# Printer (device uri)
readonly PR_DEVURI_OTHER="OTHER"
pr_devuri=""

# Printer (model)
readonly PR_MODEL_DRIVERLESS="driverless"
readonly PR_MODEL_EVERYWHERE="everywhere"
readonly PR_MODEL_PPD_GENERIC_PPD="drv:///sample.drv/gener"
readonly PR_MODEL_PPD_GENERIC_STR="generic"
readonly PR_MODEL_RAW="raw"
pr_model=""

# Printer (options)
pr_options=""

# Printer (PPD file)
readonly PR_PPD_OTHER="OTHER"
pr_ppd=""

# Printer (queue name)
readonly PR_QUEUE_OTHER="OTHER"
pr_queue=""
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
readonly ARG_ACTION_LIST_INTERACTIVE="\
ADD CANCELJOB DEFAULT DEFSETTINGS REMOVE PRINT"
# Classic script mode
readonly ARG_ACTION_LIST_SCRIPT="HELP JOBSETTINGS PRINT"
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
readonly LIST_ARG=""

#-------------------------------------------------------------------------------
#  Lists of parameters to clear/reset (interactive mode only)
#-------------------------------------------------------------------------------
#  List of arguments that have to be cleared or reset to their default values
#  after running <run()> function (interactive mode only).
#  To assign a default value to a parameter please define a constant (above)
#  with the suffix '_DEFAULT', e.g. <ARG_STR_DEFAULT> for <arg_str>.
#  !!! Use the variable's name as defined, so usually lowercase letters !!!
readonly LIST_ARG_CLEANUP_INTERACTIVE="\
arg_arg_or_stdin arg_file joblist pr_devuri pr_model pr_options pr_ppd pr_queue"
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
        [ "${arg_mode}" = "${ARG_MODE_SCRIPT}" ]; then

    # Script mode
    true

  fi                                                                        && \

  #-----------------------------------------------------------------------------
  #  Check argument types / value ranges
  #-----------------------------------------------------------------------------
  #  For more available checks, please have a look at the functions
  #  <lib_core_is()> and <lib_core_regex()> in '/lib/SHlib/lib/core.lib.sh'
  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  #  arg_file
  #-----------------------------------------------------------------------------
  if lib_core_is --not-empty "${arg_file}"; then
    lib_core_is --file "${arg_file}" || lib_shtpl_arg_error "arg_file"
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
#
#      GLOBALS:  arg_action   arg_mode
#                arg_file     arg_arg_or_stdin
#
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
        arg_action="$2"; [ $# -ge 1 ] && { shift; }
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
      #  (all actions that automatically run in submenu mode)
      --${ARG_ACTION_JOBSETTINGS}|--${ARG_ACTION_PRINT})
        arg_mode="${ARG_MODE_INTERACTIVE_SUBMENU}"
        arg_action="${1#--}"

        case "$1" in
          --${ARG_ACTION_PRINT})
              if [ $# -gt 1 ]; then
                if lib_core_is --file "$(lib_core_expand_tilde "$2")"; then
                  arg_file="$(lib_core_expand_tilde "$2")"
                else
                  arg_arg_or_stdin="$2"
                fi
                shift
              else
                arg_arg_or_stdin="$(xargs)"
              fi
              ;;
        esac
        ;;
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
          arg_file="$(lib_core_expand_tilde "$1")"
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

  #  Further cleanup steps
  arg_action=""

  #-----------------------------------------------------------------------------
  #         DONE: DEFINE YOUR CLEANUP COMMANDS (INTERACTIVE MODE) HERE
  #
  #                                     |||
  #                                    \|||/
  #                                     \|/
  #-----------------------------------------------------------------------------
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
> ${L_CUPS_ABOUT_RUN}

${txt_script}:
> ${L_CUPS_ABOUT_RUN} [ ${ttl_option} ]... ${ttl_action}${par_lastarg:+ ${par_lastarg}}"

  #  SYNOPSIS (long) version
  synopsis="\
${synopsis_tldr}

${ttl_action} := $(lib_msg_print_list_ptr "${ARG_ACTION_LIST_SCRIPT}" "${ptr_prefix}_HLP_PAR_ARG_ACTION_")"
#
#${ttl_option} := $(lib_msg_print_list_ptr "${LIST_ARG}" "${ptr_prefix}_HLP_PAR_" "" "true")"

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
  #    '/lib/SHtemplateLIB/shtpl.0.lib.sh'.
  #-----------------------------------------------------------------------------
  lib_msg_print_propvalue "--left" "--left" "2" "" " "                                                                \
    "$(lib_shtpl_arg --par "ARG_ACTION_HELP")"               "$(lib_shtpl_arg --des "ARG_ACTION_HELP")" " " ""        \
    "$(lib_shtpl_arg --par "ARG_MODE_INTERACTIVE_SUBMENU")"  "$(lib_shtpl_arg --des "ARG_MODE_INTERACTIVE_SUBMENU")

<menu>$(lib_shtpl_arg --list-ptr "arg_action" "INTERACTIVE")" " " ""                                                  \
    "$(lib_shtpl_arg --par "ARG_ACTION_JOBSETTINGS")"        "$(lib_shtpl_arg --des "ARG_ACTION_JOBSETTINGS")" " " "" \
    "$(lib_shtpl_arg --par "ARG_ACTION_PRINT")"              "$(lib_shtpl_arg --des "ARG_ACTION_PRINT")"
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
  # eval lib_msg_print_heading -211 \"\${LIB_SHTPL_${ID_LANG}_TXT_HELP_TTL_SYNOPSIS_OPTION}\"
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
  #    '/lib/SHtemplateLIB/shtpl.0.lib.sh'.
  #-----------------------------------------------------------------------------
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
  lib_core_is --cmd "cancel" "lp" "lpadmin" "lpinfo" "lpoptions" "lpstat"   && \
  lib_os_user_is_member_of "lpadmin"                                        && \

  local nobreak="true"                                                      && \
  local s                                                                   && \
  local services                                                            && \
  case "$(lib_os_get --id)" in
    ${LIB_C_ID_DIST_ALPINE}) services="avahi-daemon cupsd" ;;
    *) services="avahi-daemon cups" ;;
  esac                                                                      && \
  for s in ${services}; do
    if ! service ${s} status >/dev/null 2>&1; then
      lib_core_sudo service ${s} start || { nobreak="false"; break; }
    fi
  done                                                                      && \
  ${nobreak}                                                                || \
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
      lib_msg_message --terminal --error "${TXT_INVALID_ARG_1} <${arg_logdest}> ${TXT_INVALID_ARG_2} [${L_CUPS_HLP_PAR_ARG_LOGDEST}]. ${LIB_SHTPL_EN_TXT_HELP} ${LIB_SHTPL_EN_TXT_ABORTING}"
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
  # eval "readonly TXT_DUMMY=\${L_CUPS_${ID_LANG}_TXT_DUMMY}"
  #-----------------------------------------------------------------------------
  #                                     /|\
  #                                    /|||\
  #                                     |||
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
      ${ARG_ACTION_ADD}|${ARG_ACTION_CANCELJOB}|${ARG_ACTION_DEFAULT}|\
      ${ARG_ACTION_DEFSETTINGS}|${ARG_ACTION_JOBSETTINGS}|${ARG_ACTION_PRINT}|\
      ${ARG_ACTION_REMOVE})
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
    ${ARG_ACTION_ADD})          menu_add ;;
    ${ARG_ACTION_CANCELJOB})    menu_canceljob ;;
    ${ARG_ACTION_DEFAULT})      menu_default ;;
    ${ARG_ACTION_DEFSETTINGS})  menu_defsettings ;;
    ${ARG_ACTION_JOBSETTINGS})  menu_jobsettings ;;
    ${ARG_ACTION_PRINT})        menu_print ;;
    ${ARG_ACTION_REMOVE})       menu_remove ;;
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
  eval "title=\${L_CUPS_${ID_LANG}_DLG_TTL_ARG_ACTION}"
  eval "text=\${L_CUPS_${ID_LANG}_DLG_TXT_ARG_ACTION}"
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
        eval "item=\${L_CUPS_${ID_LANG}_DLG_ITM_ARG_ACTION_${a}}"
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
  case "${arg_action}" in
    ${ARG_ACTION_PRINT})
      if lib_core_is --empty "${arg_file}" "${arg_arg_or_stdin}"; then
        menu_arg_file
      fi
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
#         NAME:  menu_add
#  DESCRIPTION:  Set up new printer / Select existing printer
#   RETURNS  0:  Printer successfully selected / set up
#            1:  Error or user interrupt
#===============================================================================
menu_add() {
  local title1
  local text1
  eval "title1=\${LIB_SHTPL_${ID_LANG}_DLG_TTL_ERROR}"
  eval "text1=\${L_CUPS_${ID_LANG}_DLG_TXT_ADD_1}"
  eval "text2=\${L_CUPS_${ID_LANG}_DLG_TXT_ADD_2}"

  menu_pr_queue                                                             && \

  # Setup new queue/printer if it does not exist
  if ! lpstat -p "${pr_queue}" >/dev/null 2>&1; then
    #---------------------------------------------------------------------------
    #  New printer
    #---------------------------------------------------------------------------
    # Set device URI
    menu_pr_devuri                                                          && \

    # Set model
    { while { pr_model=""; menu_pr_model || return 1; }; do
        case "${pr_model}" in
          ${PR_MODEL_DRIVERLESS}|${PR_MODEL_EVERYWHERE}|${PR_MODEL_RAW}) break ;;
          *)
            case "${pr_model}" in
              ${PR_MODEL_PPD_GENERIC_STR})
                pr_model="${PR_MODEL_PPD_GENERIC_PPD}" ;;
            esac                                                            && \

            # Set PPD file
            menu_pr_ppd                                                     && \
            case "${pr_ppd}" in
              ${PR_PPD_OTHER}) ;;
              *) break ;;
            esac
            ;;
        esac                                                                || \
        return 1
      done
    }                                                                       && \

    # Finally setup printer
    { local msg
      case "${pr_model}" in
        ${PR_MODEL_DRIVERLESS})
          # IPP driverless printing (cups-filters PPD generator)
          msg="$(lpadmin                    \
            -p "${pr_queue}"                \
            -v "${pr_devuri}"               \
            -m "${pr_model}":"${pr_devuri}" \
            -E 2>&1)"
          ;;
        ${PR_MODEL_EVERYWHERE}|${PR_MODEL_RAW})
          # IPP driverless (CUPS PPD generator)
          # Raw mode
          msg="$(lpadmin                    \
            -p "${pr_queue}"                \
            -v "${pr_devuri}"               \
            -m "${pr_model}"                \
            -E 2>&1)"
          ;;
        *)
          # Certain driver (PPD file)
          msg="$(lpadmin                    \
            -p "${pr_queue}"                \
            -v "${pr_devuri}"               \
            -m "${pr_ppd}"                  \
            -E 2>&1)"
          ;;
      esac || \

      { msg="$(printf "%s\n\n%s" "${text1}" "${msg}")"
        dialog --no-collapse --title "${title1}" --msgbox "${msg}" 0 0
        false
      }
    }                                                                       && \

    {
      # Set default settings
      menu_pr_options                                   && \
      if lib_core_is --not-empty "${pr_options}"; then
        lpoptions -p "${pr_queue}" ${pr_options}
      fi                                                && \

      # Print testpage
      menu_testpage                                     || \

      # Delete printer if not successful
      { lpadmin -x "${pr_queue}"
        dialog --no-collapse --title "${title1}" --msgbox "${text2}" 0 0
        false
      }
    }
  fi                                                                        && \

  # Choose default printer
  arg_action="${ARG_ACTION_DEFAULT}"                                        && \
  menu_default
}

#===  FUNCTION  ================================================================
#         NAME:  menu_default
#  DESCRIPTION:  Set default printer
#   RETURNS  0:  Default printer successfully set
#            1:  Error or user interrupt
#===============================================================================
menu_default() {
  menu_pr_queue                                                             && \
  lpoptions -d "${pr_queue}" >/dev/null 2>&1
}

#===  FUNCTION  ================================================================
#         NAME:  menu_defsettings
#  DESCRIPTION:  Set default printer settings
#   RETURNS  0:  Settings successfully changed
#            1:  Error or user interrupt
#===============================================================================
menu_defsettings() {
  menu_pr_queue                                                             && \
  menu_pr_options                                                           && \
  if lib_core_is --not-empty "${pr_options}"; then
    lpoptions -p "${pr_queue}" ${pr_options}
  fi
}

#===  FUNCTION  ================================================================
#         NAME:  menu_canceljob
#  DESCRIPTION:  Cancel one or multiple print jobs
#   RETURNS  0:  Job(s) successfully cancelled
#            1:  Error or user interrupt
#===============================================================================
menu_canceljob() {
  local title1
  local title2
  local text1
  local text2
  eval "title1=\${LIB_SHTPL_${ID_LANG}_DLG_TTL_INFO}"
  eval "title2=\${LIB_SHTPL_${ID_LANG}_DLG_TTL_ERROR}"
  eval "text1=\${L_CUPS_${ID_LANG}_DLG_TXT_CANCELJOB_1}"
  eval "text2=\${L_CUPS_${ID_LANG}_DLG_TXT_CANCELJOB_2}"

  # Request user to select active print jobs
  menu_joblist                                                        || \
  return

  local exitcode="0"
  local msg
  if lib_core_is --not-empty "${joblist}"; then
    # Only if user has selected at least one active print job
    msg="$(cancel ${joblist} 2>&1)" && \
    dialog --no-collapse --title "${title1}" --msgbox "${text1}" 0 0
  fi                                                                  || \

  { exitcode="$?"
    msg="$(printf "%s\n\n%s" "${text2}" "${msg}")"
    dialog --no-collapse --title "${title2}" --msgbox "${msg}" 0 0
    return ${exitcode}
  }
}

#===  FUNCTION  ================================================================
#         NAME:  menu_jobsettings
#  DESCRIPTION:  Generate printing settings that can be used by another
#                another command to print
#      OUTPUTS:  lp arguments to stdout in the form of
#                '-d <printer queue> -o <opt1>=<val1> -o <opt2>=<val2> ...'
#   RETURNS  0:  Settings successfully generated
#            1:  Error or user interrupt
#===============================================================================
menu_jobsettings() {
  menu_pr_queue                                                             && \
  menu_pr_options                                                           && \
  menu_job_copies                                                           && \
  printf "%s" "-d ${pr_queue} -n ${job_copies}${pr_options:+ }${pr_options}"
}

#===  FUNCTION  ================================================================
#         NAME:  menu_print
#  DESCRIPTION:  Interactively ask user to select a printer and print
#                either <arg_file>'s or (alternatively) <stdin>'s content
#   RETURNS  0:  Print job sent
#            1:  Error or user interrupt
#===============================================================================
menu_print() {
  local title1
  local title2
  local text1
  local text2
  eval "title1=\${LIB_SHTPL_${ID_LANG}_DLG_TTL_INFO}"
  eval "title2=\${LIB_SHTPL_${ID_LANG}_DLG_TTL_ERROR}"
  eval "text1=\${L_CUPS_${ID_LANG}_DLG_TXT_PRINT_1}"
  eval "text2=\${L_CUPS_${ID_LANG}_DLG_TXT_PRINT_2}"

  # Request user to select printer, printing options, and number of job copies
  menu_pr_queue                                                             && \
  menu_pr_options                                                           && \
  menu_job_copies                                                           || \
  return

  local exitcode="0"
  local msg
  { if lib_core_is --not-empty "${arg_file}"; then
      # Print file
      msg="$(lp -d "${pr_queue}" -n "${job_copies}" ${pr_options} \
        "${arg_file}" 2>&1)"
    else
      # Print text from <stdin> or a passed argument
      msg="$(printf "%s" "${arg_arg_or_stdin}" \
        | lp -d "${pr_queue}" -n "${job_copies}" ${pr_options} 2>&1)"
    fi
  }                                                                         && \
  msg="$(printf "%s\n\n%s" "${text1}" "${msg}")"                            && \
  dialog --no-collapse --title "${title1}" --msgbox "${msg}" 0 0            || \

  { exitcode="$?"
    msg="$(printf "%s\n\n%s" "${text2}" "${msg}")"
    dialog --no-collapse --title "${title2}" --msgbox "${msg}" 0 0
    return ${exitcode}
  }
}

#===  FUNCTION  ================================================================
#         NAME:  menu_remove
#  DESCRIPTION:  Delete existing printer
#   RETURNS  0:  Printer successfully deleted
#            1:  Error or user interrupt
#===============================================================================
menu_remove() {
  menu_pr_queue                                                             && \
  lpadmin -x "${pr_queue}"
}

#===  FUNCTION  ================================================================
#         NAME:  menu_testpage
#  DESCRIPTION:  Print a testpage and interactively ask user if
#                page was printed successfully
#   RETURNS  0:  Testpage successfully printed
#            1:  Error or user interrupt
#===============================================================================
menu_testpage() {
  local title
  local text1
  local text2
  eval "title=\${L_CUPS_${ID_LANG}_DLG_TTL_TESTPAGE}"
  eval "text1=\${L_CUPS_${ID_LANG}_DLG_TXT_TESTPAGE_1}"
  eval "text2=\${L_CUPS_${ID_LANG}_DLG_TXT_TESTPAGE_2}"

  local result
  local exitcode="0"
  exec 3>&1
    dialog \
      --title "${title}" --msgbox "${text1}" 0 0                            && \
    printf "%s" "."                                                         \
      | lp -d "${pr_queue}"                                                 && \
    dialog --yesno "${text2}" 0 0                                           || \
    exitcode="$?"
  exec 3>&-

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
#         NAME:  menu_arg_file
#  DESCRIPTION:  Interactive menu for setting <arg_file> parameter
#      GLOBALS:  arg_file
#   RETURNS  0:  Parameter successfully changed
#            1:  Error or user interrupt
#===============================================================================
menu_arg_file() {
  local title
  local text1
  eval "title=\${L_CUPS_${ID_LANG}_DLG_TTL_ARG_FILE}"
  eval "text1=\${L_CUPS_${ID_LANG}_DLG_TXT_ARG_FILE}"

  local result
  local exitcode
  exec 3>&1
    # Select file
    while true; do
      exitcode="0"

      dialog --title "${title}" --msgbox "${text1}" 0 0                       && \
      result="$(dialog --title "${title}"                                     \
        --fselect "${result:-${arg_file:-~/}}" 0 0 2>&1 1>&3)"                && \
      result="$(lib_core_expand_tilde "${result}")"                           || \
      exitcode="$?"

      # Check if file exists
      case "${exitcode}" in
        0) if lib_core_is --file "${result}"; then break; fi ;;
        *) break ;;
      esac
    done
  exec 3>&-

  if [ "${exitcode}" -eq "0" ]; then arg_file="${result}"; fi
  return ${exitcode}
}

#===  FUNCTION  ================================================================
#         NAME:  menu_job_copies
#  DESCRIPTION:  Interactive menu for setting <job_copies> variable
#      GLOBALS:  job_copiess
#   RETURNS  0:  Variable successfully changed
#            1:  Error or user interrupt
#===============================================================================
menu_job_copies() {
  local title
  local text
  eval "title=\${L_CUPS_${ID_LANG}_DLG_TTL_JOB_COPIES}"
  eval "text=\${L_CUPS_${ID_LANG}_DLG_TXT_JOB_COPIES}"

  local result
  local exitcode="0"
  exec 3>&1
    result="$(dialog --title "${title}" --rangebox "${text}" 0 0  \
      ${JOB_COPIES_MIN} ${JOB_COPIES_MAX} ${job_copies} 2>&1 1>&3)"         || \
    exitcode="$?"
  exec 3>&-

  if [ "${exitcode}" -eq "0" ]; then job_copies="${result}"; fi
  return ${exitcode}
}


#===  FUNCTION  ================================================================
#         NAME:  menu_joblist
#  DESCRIPTION:  Interactive menu for setting <joblist> variable
#   RETURNS  0:  Settings successfully changed
#            1:  Error or user interrupt
#===============================================================================
menu_joblist() {
  local title1
  local title2
  local extra
  local text1
  local text2
  eval "title1=\${L_CUPS_${ID_LANG}_DLG_TTL_JOBLIST_1}"
  eval "title2=\${LIB_SHTPL_${ID_LANG}_DLG_TTL_ERROR}"
  eval "extra=\${LIB_SHTPL_${ID_LANG}_TXT_SELECTALL}"
  text1="$(lib_core_str_to --const "L_CUPS_${ID_LANG}_DLG_TXT_JOBLIST_1_${arg_action}")"
  eval "text1=\${${text1}}"
  eval "text2=\${L_CUPS_${ID_LANG}_DLG_TXT_JOBLIST_2}"

  local OLDIFS="$IFS"
  local IFS="${LIB_C_STR_NEWLINE}"

  local alljobs
  local jobs
  local result
  local exitcode="0"
  exec 3>&1
    # Get list of active print jobs
    { jobs="$(lpstat -o | tr -s ' ')"   && \
      lib_core_is --not-empty "${jobs}" || \
      { dialog --no-collapse --title "${title2}" --msgbox "${text2}" 0 0
        false
      }
    }                                                                       && \
    alljobs="$(printf "%s" "${jobs}" | cut -d' ' -f1)"                      && \
    alljobs="$(lib_core_str_remove_newline "${alljobs}")"                   && \

    # Request user to select one or several print jobs
    jobs="$(for a in ${jobs}; do
        tag="$(printf "%s" "$a" | cut -d' ' -f1)"
        item="$(printf "%s" "$a" | cut -d' ' -f2-)"
        status="off"
        printf "%s\n%s\n%s\n" "${tag}" "${item}" "${status}"
      done)"                                                                && \
    result="$(dialog --extra-button --extra-label "${extra}"  \
      --title "${title1}" --checklist "${text1}" 0 0 0        \
      ${jobs} 2>&1 1>&3)"                                                   || \

    exitcode="$?"
  exec 3>&-

  IFS="$OLDIFS"

  # 3: Extra button pressed => Select all jobs
  case "${exitcode}" in
    0)  joblist="${result}" ;;
    3)  joblist="${alljobs}"; exitcode="0" ;;
  esac

  return ${exitcode}
}

#===  FUNCTION  ================================================================
#         NAME:  menu_pr_devuri
#  DESCRIPTION:  Interactive menu for setting <pr_devuri> variable
#      GLOBALS:  pr_devuri
#   RETURNS  0:  Variable successfully changed
#            1:  Error or user interrupt
#===============================================================================
menu_pr_devuri() {
  local tag1="${PR_DEVURI_OTHER}"

  local title
  local text1
  local item1
  local text2
  eval "title=\${L_CUPS_${ID_LANG}_DLG_TTL_PR_DEVURI}"
  eval "text1=\${L_CUPS_${ID_LANG}_DLG_TXT_PR_DEVURI_1}"
  eval "item1=\${L_CUPS_${ID_LANG}_DLG_ITM_PR_DEVURI_OTHER}"
  eval "text2=\${L_CUPS_${ID_LANG}_DLG_TXT_PR_DEVURI_2}"

  local OLDIFS="$IFS"
  local IFS="${LIB_C_STR_NEWLINE}"

  local uris
  local result
  local exitcode
  exec 3>&1
    while true; do
      exitcode="0"

      # Get possible device URIs
      uris="$(for a in $(lpinfo -v); do
          tag="$(printf "%s" "$a" | cut -d' ' -f2-)"
          item="$(printf "%s" "$a" | cut -d' ' -f1)"
          printf "%s\n%s\n" "${tag}" "${item}"
        done)"                                                          && \

      # Show dialogue with device URIs and a special
      # "OTHER" entry to add an individual device URI
      result="$(dialog --title "${title}" --menu "${text1}" 0 0 0       \
        ${uris} "${tag1}" "${item1}" 2>&1 1>&3)"                        && \

      case "${result}" in
        ${tag1})
          # OTHER
          result="$(dialog --title "${title}" --inputbox "${text2}" 0 0 \
            "${pr_devuri}" 2>&1 1>&3)"
          ;;
      esac                                                              || \
      exitcode="$?"

      # Check input
      case "${exitcode}" in
        0) if lib_core_regex --cups-devuri "${result}"; then break; fi ;;
        *) if lib_core_is --empty "${result}"; then break; fi ;;
      esac
    done
  exec 3>&-

  IFS="$OLDIFS"

  if [ "${exitcode}" -eq "0" ]; then pr_devuri="${result}"; fi
  return ${exitcode}
}

#===  FUNCTION  ================================================================
#         NAME:  menu_pr_model
#  DESCRIPTION:  Interactive menu for setting <pr_model> variable
#      GLOBALS:  pr_model
#   RETURNS  0:  Variable successfully changed
#            1:  Error or user interrupt
#===============================================================================
menu_pr_model() {
  local title
  local text
  eval "title=\${L_CUPS_${ID_LANG}_DLG_TTL_PR_MODEL}"
  eval "text=\${L_CUPS_${ID_LANG}_DLG_TXT_PR_MODEL}"

  local result
  local exitcode="0"
  exec 3>&1
    result="$(dialog --title "${title}" --inputbox "${text}" 0 0  \
      "${pr_model}" 2>&1 1>&3)"                                   || \
    exitcode="$?"
  exec 3>&-

  if [ "${exitcode}" -eq "0" ]; then pr_model="${result}"; fi
  return ${exitcode}
}

#===  FUNCTION  ================================================================
#         NAME:  menu_pr_options
#  DESCRIPTION:  Interactive menu for setting <pr_options> variable
#      GLOBALS:  pr_options
#   RETURNS  0:  Variable successfully changed
#            1:  Error or user interrupt
#===============================================================================
menu_pr_options() {
  local tag1="${LIB_SHTPL_DLG_TAG_EXIT}"

  local title
  local extra
  local text1
  local text2
  local text31
  local text32
  local text33
  local item1
  eval "title=\${L_CUPS_${ID_LANG}_DLG_TTL_PR_OPTIONS}"
  eval "extra=\${LIB_SHTPL_${ID_LANG}_TXT_GOBACK}"
  eval "text1=\${L_CUPS_${ID_LANG}_DLG_TXT_PR_OPTIONS_1}"
  eval "text2=\${L_CUPS_${ID_LANG}_DLG_TXT_PR_OPTIONS_2}"
  eval "text31=\${L_CUPS_${ID_LANG}_DLG_TXT_PR_OPTIONS_31}"
  eval "text32=\${L_CUPS_${ID_LANG}_DLG_TXT_PR_OPTIONS_32}"
  eval "text33=\${L_CUPS_${ID_LANG}_DLG_TXT_PR_OPTIONS_33}"
  eval "item1=\${LIB_SHTPL_${ID_LANG}_DLG_ITM_EXIT_MENU_SAVE}"

  local opts
  local opt
  local vals
  local val
  local result
  local exitcode
  exec 3>&1
    while true; do
      exitcode="0"

      # Get options
      opts="$(lpoptions -p "${pr_queue}" -l 2>/dev/null \
        | while IFS= read -r a || [ -n "$a" ]; do
            tag="$(printf "%s" "$a" | cut -d':' -f1 | cut -d'/' -f1)"
            item="."
            printf "%s\n%s\n" "${tag}" "${item}"
          done)"                                                          && \

      # Show (first) dialogue with options and a special "exit" entry
      # at the top and the bottom of the menu
      opt="$(dialog --title "${title}" --menu "${text1}" 0 0 0            \
        ${opts:+"${tag1}" "${item1}"}                                     \
        ${opts} "${tag1}" "${item1}" 2>&1 1>&3)"                          && \

      case "${opt}" in
        ${tag1})
          # "exit": Show changes and ask user to continue
          text="$(printf  "%s\n\n%s\n%s"              \
                          "${text31}"                 \
                          "${result:-${text32}}"      \
                          "${text33}"                 \
                )" && \
          if dialog --title "${title}" --yesno "${text}" 0 0; then
            break
          else
            continue
          fi
          ;;
      esac                                                                && \

      # Get possible values for previously chosen option <opt>
      vals="$(for a in $(lpoptions -p "${pr_queue}" -l 2>/dev/null \
        | grep -e "^${opt}[/:]" | cut -d':' -f2); do
            tag="$a"
            item="."
            printf "%s\n%s\n" "${tag}" "${item}"
          done)"                                                          && \

      # Show (second) dialog with possible values
      val="$(dialog --extra-button --extra-label "${extra}" \
        --title "${title} <${opt}>" --menu "${text2}" 0 0 0 \
        ${vals} 2>&1 1>&3)"                                               && \
      case "${result}" in
        *"-o ${opt}="*)
          # <result> already contains the option to be changed (<opt>)
          case "${val}" in
            \**)
              # <val> is the (previous) default value => just remove <opt>=<val> pair
              result="$(printf "%s" "${result}" | sed -e "s/-o ${opt}=[^[:blank:]]*//")"
              ;;
            *)
              # <val> is not(!) the (previous) default value => replace <val>
              result="$(printf "%s" "${result}" | sed -e "s/-o ${opt}=[^[:blank:]]*/-o ${opt}=${val}/")"
              ;;
          esac
          ;;
        *)
          # <opt> has not been changed yet
          case "${val}" in
            \**) ;;
            *) result="${result}${result:+ }-o ${opt}=${val}" ;;
          esac
          ;;
      esac                                                                  || \
      exitcode="$?"

      case "${exitcode}" in
        0|3)
          # Value selected (0) or extra (go back) button pressed (3)
          # => Stay in loop
          ;;
        *)
          # 'dialog' interrupted => Break
          break
          ;;
      esac
    done
  exec 3>&-

  if [ "${exitcode}" -eq "0" ]; then pr_options="${result}"; fi
  return ${exitcode}
}

#===  FUNCTION  ================================================================
#         NAME:  menu_pr_ppd
#  DESCRIPTION:  Interactive menu for setting <pr_ppd> variable
#      GLOBALS:  pr_ppd
#   RETURNS  0:  Variable successfully changed
#            1:  Error or user interrupt
#===============================================================================
menu_pr_ppd() {
  local tag1="${PR_PPD_OTHER}"

  local title
  local text
  local item1
  eval "title=\${L_CUPS_${ID_LANG}_DLG_TTL_PR_PPD}"
  eval "text=\${L_CUPS_${ID_LANG}_DLG_TXT_PR_PPD}"
  eval "item1=\${L_CUPS_${ID_LANG}_DLG_ITM_PR_PPD_OTHER}"

  local OLDIFS="$IFS"
  local IFS="${LIB_C_STR_NEWLINE}"

  local dlgpairs
  local result
  local exitcode="0"
  exec 3>&1
    dlgpairs="$(for a in $(lpinfo -m | grep -i "${pr_model}"); do
        tag="$(printf "%s" "$a" | cut -d' ' -f1)"
        item="$(printf "%s" "$a" | cut -d' ' -f2-)"
        printf "%s\n%s\n" "${tag}" "${item}"
      done)"                                                                && \
    result="$(dialog --title "${title}" --menu "${text}" 0 0 0  \
      ${dlgpairs} "${tag1}" "${item1}" 2>&1 1>&3)"                          || \
    exitcode="$?"
  exec 3>&-

  IFS="$OLDIFS"

  if [ "${exitcode}" -eq "0" ]; then pr_ppd="${result}"; fi
  return ${exitcode}
}

#===  FUNCTION  ================================================================
#         NAME:  menu_pr_queue
#  DESCRIPTION:  Interactive menu for setting <pr_queue> variable
#      GLOBALS:  pr_queue
#   RETURNS  0:  Variable successfully changed
#            1:  Error or user interrupt
#===============================================================================
menu_pr_queue() {
  local tag1="${PR_QUEUE_OTHER}"

  local title
  local title3
  local text1
  local item1
  local text2
  local text3
  local text4
  eval "text2=\${L_CUPS_${ID_LANG}_DLG_TXT_PR_QUEUE_2}"

  case "${arg_action}" in
    ${ARG_ACTION_ADD})
      eval "title=\${L_CUPS_${ID_LANG}_DLG_TTL_PR_QUEUE_ADD}"
      ;;
    ${ARG_ACTION_DEFAULT})
      eval "title=\${L_CUPS_${ID_LANG}_DLG_TTL_PR_QUEUE_DEFAULT}"
      eval "text2=\${L_CUPS_${ID_LANG}_DLG_TXT_PR_QUEUE_2_DEFAULT}"
      ;;
    ${ARG_ACTION_REMOVE})
      eval "title=\${L_CUPS_${ID_LANG}_DLG_TTL_PR_QUEUE_REMOVE}"
      ;;
    ${ARG_ACTION_DEFSETTINGS})
      eval "title=\${L_CUPS_${ID_LANG}_DLG_TTL_PR_QUEUE_DEFSETTINGS}"
      ;;
    ${ARG_ACTION_JOBSETTINGS}|${ARG_ACTION_PRINT})
      eval "title=\${L_CUPS_${ID_LANG}_DLG_TTL_PR_QUEUE_JOBSETTINGS}"
      ;;
  esac

  eval "text1=\${L_CUPS_${ID_LANG}_DLG_TXT_PR_QUEUE_1}"
  eval "item1=\${L_CUPS_${ID_LANG}_DLG_ITM_PR_QUEUE_OTHER}"
  eval "title3=\${LIB_SHTPL_${ID_LANG}_DLG_TTL_ERROR}"
  eval "text3=\${L_CUPS_${ID_LANG}_DLG_TXT_PR_QUEUE_3}"
  eval "text4=\${L_CUPS_${ID_LANG}_DLG_TXT_PR_QUEUE_4}"

  local queues
  local result
  local exitcode
  exec 3>&1
    while true; do
      exitcode="0"

      case "${arg_action}" in
        ${ARG_ACTION_ADD}|${ARG_ACTION_JOBSETTINGS}|${ARG_ACTION_PRINT})
          #---------------------------------------------------------------------
          #  Modes that request user to connect the printer
          #---------------------------------------------------------------------
          dialog --no-collapse --title "${title}" --msgbox "${text1}" 0 0
          ;;
        *) ;;
      esac                                                                  && \

      # Get available printer (queues)
      queues="$(lpstat -v 2>/dev/null | sed -ne "s/^.\{1,\}[[:space:]]\{1,\}\([^[:space:]]\{1,\}\):[[:space:]]\{1,\}\(.\{1,\}\)$/\1\n\2/p")" && \

      case "${arg_action}" in
        ${ARG_ACTION_ADD}|${ARG_ACTION_JOBSETTINGS}|${ARG_ACTION_PRINT}) ;;
        *)
          #---------------------------------------------------------------------
          #  Modes where a printer queue has to exist before continuing
          #---------------------------------------------------------------------
          lib_core_is --not-empty "${queues}" || \
          { dialog  --no-collapse --title "${title3}" --msgbox "${text3}" 0 0
            false
          }
          ;;
      esac                                                                  && \

      case "${arg_action}" in
        ${ARG_ACTION_ADD}|${ARG_ACTION_JOBSETTINGS}|${ARG_ACTION_PRINT})
          #---------------------------------------------------------------------
          #  Modes that request user to either select an existing printer
          #  queue or setup a new one.
          #---------------------------------------------------------------------
          if eval [ \${${INSTANCES}} -gt 1 ]; then
            # Skip the dialog in case that the script was recursively called
            # (see below).
            result="${tag1}"
          else
            result="$(dialog --title "${title}" --menu "${text2}" 0 0 0 \
              ${queues} "${tag1}" "${item1}"                            \
              2>&1 1>&3)"
          fi                                                                && \

          case "${result}" in
            ${tag1})
              #-----------------------------------------------------------------
              #  New printer queue
              #-----------------------------------------------------------------
              case "${arg_action}" in
                ${ARG_ACTION_ADD})
                  #-------------------------------------------------------------
                  #  Ask the user to enter a new queue name and validate it.
                  #-------------------------------------------------------------
                  result="$(dialog --title "${title}" --inputbox "${text4}" \
                    0 0 "${pr_queue}" 2>&1 1>&3)"                           && \
                  { lib_core_regex --cups-queue "${result}"   && \
                    ! lpstat -p "${result}" >/dev/null 2>&1   || \
                    result=""
                  }
                  ;;

                ${ARG_ACTION_JOBSETTINGS}|${ARG_ACTION_PRINT})
                  #-------------------------------------------------------------
                  #  In case the user wants to print something but the printer
                  #  queue has not been set up yet:
                  #  Call the script recursively with "add" submenu
                  #-------------------------------------------------------------
                  "$0" --submenu add
                  continue
                  ;;
              esac
              ;;
            *)
              #-----------------------------------------------------------------
              #  Existing printer queue
              #-----------------------------------------------------------------
              ;;
          esac
          ;;

        ${ARG_ACTION_DEFAULT})
          #---------------------------------------------------------------------
          #  Default mode
          #---------------------------------------------------------------------
          local pr_default                                                  && \
          pr_default="$(lib_core_str_remove_leading                         \
            " " "$(lpstat -d 2>&1 | cut -d':' -f2-)")"                      && \

          result="$(dialog --title "${title}"                               \
            --menu "${text2} <${pr_default}>" 0 0 0 ${queues} 2>&1 1>&3)"
          ;;

        *)
          #---------------------------------------------------------------------
          #  Modes that request user to select an existing printer queue
          #---------------------------------------------------------------------
          result="$(dialog --title "${title}" --menu "${text2}" 0 0 0       \
            ${queues} 2>&1 1>&3)"
          ;;
      esac                                                                  || \
      exitcode="$?"

      case "${exitcode}" in
        0) if lib_core_is --not-empty "${result}"; then break; fi ;;
        *) if lib_core_is --empty "${result}"; then break; fi ;;
      esac
    done
  exec 3>&-

  if [ "${exitcode}" -eq "0" ]; then pr_queue="${result}"; fi
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