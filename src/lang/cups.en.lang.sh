#!/bin/sh
#
# SPDX-FileCopyrightText: Copyright (c) 2022-2024 Florian Kemser and the CUPSwrapper contributors
# SPDX-License-Identifier: GPL-3.0-or-later
#
#===============================================================================
#
#         FILE:   /src/lang/cups.en.lang.sh
#
#        USAGE:   ---
#                 (This is a constant file, so please do NOT run it.)
#
#  DESCRIPTION:   --English-- String Constants File for '/src/cups.sh'
#                 Used to generate help texts, interactive dialogues,
#                 and other terminal/log messages.
#
#         BUGS:   ---
#
#        NOTES:   ---
#
#         TODO:   See 'TODO:'-tagged lines below.
#===============================================================================

#===============================================================================
#  !!! IMPORTANT !!!
#===============================================================================
#  All constants (identifiers) must follow a certain naming convention,
#  see '/src/lang/run.0.lang.sh'

#===============================================================================
#  PARAMETER (TEMPLATE) - DO NOT EDIT
#===============================================================================
#  Script actions <ARG_ACTION_...>
readonly L_CUPS_EN_HLP_DES_ARG_ACTION_HELP="${LIB_SHTPL_EN_HLP_DES_ARG_ACTION_HELP}"

#  Log destination <ARG_LOGDEST_...>
readonly L_CUPS_EN_HLP_DES_ARG_LOGDEST="${LIB_SHTPL_EN_HLP_DES_ARG_LOGDEST}"
readonly L_CUPS_EN_HLP_DES_ARG_LOGDEST_BOTH="${LIB_SHTPL_EN_HLP_DES_ARG_LOGDEST_BOTH}"
readonly L_CUPS_EN_HLP_DES_ARG_LOGDEST_SYSLOG="${LIB_SHTPL_EN_HLP_DES_ARG_LOGDEST_SYSLOG}"
readonly L_CUPS_EN_HLP_DES_ARG_LOGDEST_TERMINAL="${LIB_SHTPL_EN_HLP_DES_ARG_LOGDEST_TERMINAL}"

#  Script operation modes <ARG_MODE_...>
readonly L_CUPS_EN_HLP_DES_ARG_MODE_DAEMON="${LIB_SHTPL_EN_HLP_DES_ARG_MODE_DAEMON}"
readonly L_CUPS_EN_HLP_DES_ARG_MODE_INTERACTIVE_SUBMENU="${LIB_SHTPL_EN_HLP_DES_ARG_MODE_INTERACTIVE_SUBMENU}"

#===============================================================================
#  PARAMETER (CUSTOM)
#===============================================================================
#-------------------------------------------------------------------------------
#  arg_file
#-------------------------------------------------------------------------------
readonly L_CUPS_EN_DLG_TTL_ARG_FILE="File"
readonly L_CUPS_EN_DLG_TXT_ARG_FILE="Please select the file to print."

#-------------------------------------------------------------------------------
#  Last argument (parameter), see also <args_read()> in '/src/run.sh'
#-------------------------------------------------------------------------------
readonly L_CUPS_EN_HLP_DES_LASTARG="File to print (optional)"

#-------------------------------------------------------------------------------
#  Script actions <ARG_ACTION_...>
#-------------------------------------------------------------------------------
#  Main Menu Title/Text
readonly L_CUPS_EN_DLG_TTL_ARG_ACTION="CUPS Printer Administration"
readonly L_CUPS_EN_DLG_TXT_ARG_ACTION="What would you like to do?"

#  ARG_ACTION_ADD
readonly L_CUPS_EN_DLG_ITM_ARG_ACTION_ADD="Add a new printer"

#  ARG_ACTION_CANCELJOB
readonly L_CUPS_EN_DLG_ITM_ARG_ACTION_CANCELJOB="Cancel print job(s)"

#  ARG_ACTION_DEFAULT
readonly L_CUPS_EN_DLG_ITM_ARG_ACTION_DEFAULT="Set default printer"

#  ARG_ACTION_DEFSETTINGS
readonly L_CUPS_EN_DLG_ITM_ARG_ACTION_DEFSETTINGS="Set default printing settings"

#  ARG_ACTION_JOBSETTINGS
readonly L_CUPS_EN_DLG_ITM_ARG_ACTION_JOBSETTINGS="Set print job settings"
readonly L_CUPS_EN_HLP_DES_ARG_ACTION_JOBSETTINGS="Interactively select printer and print job settings. The chosen settings will be printed to <stdout>, e.g. for further use with 'lp' command."

#  ARG_ACTION_PRINT
readonly L_CUPS_EN_DLG_ITM_ARG_ACTION_PRINT="Print a file"
readonly L_CUPS_EN_HLP_DES_ARG_ACTION_PRINT="Print, either from a given <file> or <stdin>'s (pipe) content ('echo \"Text to print\" | ${L_CUPS_ABOUT_RUN} --print'). Interactively select printer and print job settings before printing."

#  ARG_ACTION_REMOVE
readonly L_CUPS_EN_DLG_ITM_ARG_ACTION_REMOVE="Remove an existing printer"

#===============================================================================
#  GLOBAL VARIABLES (CUSTOM)
#===============================================================================
#-------------------------------------------------------------------------------
#  job_copies
#-------------------------------------------------------------------------------
readonly L_CUPS_EN_DLG_TTL_JOB_COPIES="Copies"
readonly L_CUPS_EN_DLG_TXT_JOB_COPIES="How many copies would you like to print?"

#-------------------------------------------------------------------------------
#  joblist
#-------------------------------------------------------------------------------
readonly L_CUPS_EN_DLG_TTL_JOBLIST_1="Print Queue(s)"
readonly L_CUPS_EN_DLG_TXT_JOBLIST_1_CANCELJOB="\
Please select the print jobs to be cancelled.

${LIB_SHTPL_EN_DLG_TXT_CHECKLIST}"
readonly L_CUPS_EN_DLG_TXT_JOBLIST_2="No active print jobs found."

#-------------------------------------------------------------------------------
#  pr_devuri
#-------------------------------------------------------------------------------
readonly L_CUPS_EN_DLG_TTL_PR_DEVURI="Printer Setup (Device URI)"
readonly L_CUPS_EN_DLG_TXT_PR_DEVURI_1="Please select the address that belongs to your printer. In case your printer's address is not listed please choose 'OTHER' at the end of the list."
readonly L_CUPS_EN_DLG_TXT_PR_DEVURI_2="\
Please enter your printer's device URI. Use one of the following URI schemes:

(1) <http|ipp|ipps>://<ip address or hostname>:[<port number>]/ipp/print
(1) <http|ipp|ipps>://<ip address or hostname>:[<port number>]/printers/<print queue name>
(2) socket://<ip address or hostname>:[<port number>]
(3) lpd://<ip address or hostname>:[<port number>]/<print queue name>
(4) usb://<...>
(5) parallel:<device path, e.g. '/dev/lp0'>
(6) serial:<device path, e.g. '/dev/ttyS0'>?baud=<baud rate, e.g. '115200'>

For more information please have a look at:

${L_CUPS_DLG_TXT_PR_DEVURI_2}"
readonly L_CUPS_EN_DLG_ITM_PR_DEVURI_OTHER="My printer is not listed, I would like to add it manually."

#-------------------------------------------------------------------------------
#  pr_model
#-------------------------------------------------------------------------------
readonly L_CUPS_EN_DLG_TTL_PR_MODEL="Printer Setup (Model)"
readonly L_CUPS_EN_DLG_TXT_PR_MODEL="\
Please enter either your printer's

  - model number, e.g. 'FS-1020', or
  - manufacturer, e.g. 'Kyocera',

or one of the following keywords (without ''):

  'driverless':   IPP driverless printing
                  (recommended - using cups-filters PPD generator)

  'everywhere':   IPP driverless printing
                  (using CUPS PPD generator)

     'generic':   Generic PostScript (PS) or
                  Printer Command Language (PCL) driver

         'raw':   Printer queue without any filtering system
                  (print job goes directly to the printer)

-------------
 PLEASE NOTE
-------------
Depending on your search term the following menu may take some time to show up.
In case the menu is empty you may need additional drivers. For more information please have a look at the help."

#-------------------------------------------------------------------------------
#  pr_options
#-------------------------------------------------------------------------------
readonly L_CUPS_EN_DLG_TTL_PR_OPTIONS="Printing Options"
readonly L_CUPS_EN_DLG_TXT_PR_OPTIONS_1="Please choose the option that you would like to edit. To save your changes and continue please choose '${LIB_SHTPL_DLG_TAG_EXIT}' at the beginning/end of the list."
readonly L_CUPS_EN_DLG_TXT_PR_OPTIONS_2="Please choose one of the following values.
(An asterisk ('*') indicates that this is the option's current default value.)"
readonly L_CUPS_EN_DLG_TXT_PR_OPTIONS_31="\
==================
 Changed Settings
=================="
readonly L_CUPS_EN_DLG_TXT_PR_OPTIONS_32="(No changes - the current default settings will be used.)"
readonly L_CUPS_EN_DLG_TXT_PR_OPTIONS_33="${LIB_SHTPL_EN_DLG_TXT_CONTINUE}"

#-------------------------------------------------------------------------------
#  pr_ppd
#-------------------------------------------------------------------------------
readonly L_CUPS_EN_DLG_TTL_PR_PPD="Printer Setup (PPD File)"
readonly L_CUPS_EN_DLG_TXT_PR_PPD="Please select one of the following PPD files:"
readonly L_CUPS_EN_DLG_ITM_PR_PPD_OTHER="My printer is not listed, I would like to search for another model."

#-------------------------------------------------------------------------------
#  pr_queue
#-------------------------------------------------------------------------------
readonly L_CUPS_EN_DLG_TTL_PR_QUEUE="Printer Setup"
readonly L_CUPS_EN_DLG_TTL_PR_QUEUE_ADD="${L_CUPS_EN_DLG_ITM_ARG_ACTION_ADD}"
readonly L_CUPS_EN_DLG_TTL_PR_QUEUE_DEFAULT="${L_CUPS_EN_DLG_ITM_ARG_ACTION_DEFAULT}"
readonly L_CUPS_EN_DLG_TTL_PR_QUEUE_DEFSETTINGS="${L_CUPS_EN_DLG_ITM_ARG_ACTION_DEFSETTINGS}"
readonly L_CUPS_EN_DLG_TTL_PR_QUEUE_JOBSETTINGS="${L_CUPS_EN_DLG_ITM_ARG_ACTION_JOBSETTINGS}"
readonly L_CUPS_EN_DLG_TTL_PR_QUEUE_REMOVE="${L_CUPS_EN_DLG_ITM_ARG_ACTION_REMOVE}"
readonly L_CUPS_EN_DLG_TXT_PR_QUEUE_1="Please make sure that your printer is connected and ready. Press <Return> to continue."
readonly L_CUPS_EN_DLG_TXT_PR_QUEUE_2="Please select one of the following printers. In case your device address is not listed please choose 'OTHER' at the end of the list.

${LIB_SHTPL_EN_DLG_TXT_ATTENTION}
In case you print confidential documents, e.g. with passwords, PINs, etc., it is highly recommended to only use printers that are connected either

  - locally (${L_CUPS_DLG_TXT_PR_QUEUE_21}) or
  - via a secure network connection (${L_CUPS_DLG_TXT_PR_QUEUE_22}).

Otherwise unauthorised persons may be able to access your data."
readonly L_CUPS_EN_DLG_TXT_PR_QUEUE_2_DEFAULT="Please select your default printer. Your current default printer is:"
readonly L_CUPS_EN_DLG_TXT_PR_QUEUE_3="No printer found."
readonly L_CUPS_EN_DLG_TXT_PR_QUEUE_4="Please enter a valid queue name that has not been assigned yet. Allowed characters: [a-zA-Z0-9_%-]"
readonly L_CUPS_EN_DLG_ITM_PR_QUEUE_OTHER="My printer is not listed and/or I would like to setup a new printer."

#===============================================================================
#  FUNCTIONS (CUSTOM) (MENUS)
#===============================================================================
#-------------------------------------------------------------------------------
#  add
#-------------------------------------------------------------------------------
readonly L_CUPS_EN_DLG_TXT_ADD_1="Could not add printer. Error message:"
readonly L_CUPS_EN_DLG_TXT_ADD_2="Printer was not added. ${LIB_SHTPL_EN_TXT_ABORTING}"

#-------------------------------------------------------------------------------
#  canceljob
#-------------------------------------------------------------------------------
readonly L_CUPS_EN_DLG_TXT_CANCELJOB_1="Print jobs successfully cancelled."
readonly L_CUPS_EN_DLG_TXT_CANCELJOB_2="Could not cancel print jobs. Error message:"

#-------------------------------------------------------------------------------
#  print
#-------------------------------------------------------------------------------
readonly L_CUPS_EN_DLG_TXT_PRINT_1="Print job successfully sent:"
readonly L_CUPS_EN_DLG_TXT_PRINT_2="Could not send print job. Error message:"

#-------------------------------------------------------------------------------
#  testpage
#-------------------------------------------------------------------------------
readonly L_CUPS_EN_DLG_TTL_TESTPAGE="Printer Setup (Testpage)"
readonly L_CUPS_EN_DLG_TXT_TESTPAGE_1="The script will now print a testpage (blank page with just one dot '.') to check whether the printer works correctly. Please make sure that your printer is ready and press <Return> to start printing."
readonly L_CUPS_EN_DLG_TXT_TESTPAGE_2="Was the page successfully printed?"

#===============================================================================
#  HELP
#===============================================================================
#-------------------------------------------------------------------------------
#  EXAMPLES
#-------------------------------------------------------------------------------
# Example 1
readonly L_CUPS_EN_HLP_TTL_EXAMPLES_1="Print"
readonly L_CUPS_EN_HLP_TXT_EXAMPLES_1="${L_CUPS_HLP_TXT_EXAMPLES_1}"

#-------------------------------------------------------------------------------
#  NOTES
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#  REQUIREMENTS
#-------------------------------------------------------------------------------
#  Requirements 1
readonly L_CUPS_EN_HLP_TTL_REQUIREMENTS_1="General"
readonly L_CUPS_EN_HLP_TXT_REQUIREMENTS_1="\
Required Packages:
${L_CUPS_HLP_TXT_REQUIREMENTS_1_PACKAGES}

Group Membership:
  The current user must be a member of the 'lpadmin' group:
  ${L_CUPS_HLP_TXT_REQUIREMENTS_1_GROUP_MEMBERSHIP}

Additional Printer Drivers (optional):
  In case you have an older printer that does not support
  driverless printing (IPP) yet you may need additional
  legacy drivers:

${L_CUPS_HLP_TXT_REQUIREMENTS_1_PRINTERDRIVERS}"

#  Requirements 2
readonly L_CUPS_EN_HLP_TTL_REQUIREMENTS_2="${LIB_SHTPL_EN_TXT_HELP_TTL_REQUIREMENTS_INTERACTIVE}"
readonly L_CUPS_EN_HLP_TXT_REQUIREMENTS_2="${LIB_SHTPL_EN_TXT_HELP_TXT_REQUIREMENTS_INTERACTIVE}"

#  Requirements 3
readonly L_CUPS_EN_HLP_TTL_REQUIREMENTS_3="${LIB_SHTPL_EN_TXT_HELP_TTL_REQUIREMENTS_WSL_SYSTEMD}"
readonly L_CUPS_EN_HLP_TXT_REQUIREMENTS_3="${LIB_SHTPL_EN_TXT_HELP_TXT_REQUIREMENTS_WSL_SYSTEMD}"

#-------------------------------------------------------------------------------
#  TEXTS
#-------------------------------------------------------------------------------
# Intro Description
readonly L_CUPS_EN_HLP_TXT_INTRO="Provide interactive menus to print and manage printers for local(!) usage. This is not a replacement for CUPS daemon/server administration."

#-------------------------------------------------------------------------------
#  TL;DR
#-------------------------------------------------------------------------------
readonly L_CUPS_EN_HLP_TTL_TLDR_1="Requirements"
readonly L_CUPS_EN_HLP_TXT_TLDR_1="\
To install the necessary packages on your system, simply run:

${L_CUPS_HLP_TXT_TLDR_1_INSTALL}

The current user must be a member of the 'lpadmin' group:
${L_CUPS_HLP_TXT_REQUIREMENTS_1_GROUP_MEMBERSHIP}

The script has been developed and tested on the following system:

OS:         ${L_CUPS_HLP_TXT_TLDR_1_OS}
Kernel:     ${L_CUPS_HLP_TXT_TLDR_1_KERNEL}
Packages:   ${L_CUPS_HLP_TXT_TLDR_1_PACKAGES}"

#===============================================================================
#  CUSTOM STRINGS (used in terminal output <stdout>/<stderr>)
#===============================================================================
#  DONE: Here you can define custom language-specific strings.
#        Do not forget to "publish" them within the <init_lang()> function of
#        your destination script, e.g. 'run.sh'.
#===============================================================================