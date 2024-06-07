#!/bin/sh
#
# SPDX-FileCopyrightText: Copyright (c) 2023-2024 Florian Kemser and the TeXLetterCreator contributors
# SPDX-License-Identifier: GPL-3.0-or-later
#
#===============================================================================
#
#         FILE:   /src/lang/tex.en.lang.sh
#
#        USAGE:   ---
#                 (This is a constant file, so please do NOT run it.)
#
#  DESCRIPTION:   --English-- String Constants File for '/src/tex.sh'
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
#  PARAMETER (TEMPLATE)
#===============================================================================
#  Script actions <ARG_ACTION_...>
readonly L_TEX_EN_HLP_DES_ARG_ACTION_HELP="${LIB_SHTPL_EN_HLP_DES_ARG_ACTION_HELP}"

#  Log destination <ARG_LOGDEST_...>
readonly L_TEX_EN_HLP_DES_ARG_LOGDEST="${LIB_SHTPL_EN_HLP_DES_ARG_LOGDEST}"
readonly L_TEX_EN_HLP_DES_ARG_LOGDEST_BOTH="${LIB_SHTPL_EN_HLP_DES_ARG_LOGDEST_BOTH}"
readonly L_TEX_EN_HLP_DES_ARG_LOGDEST_SYSLOG="${LIB_SHTPL_EN_HLP_DES_ARG_LOGDEST_SYSLOG}"
readonly L_TEX_EN_HLP_DES_ARG_LOGDEST_TERMINAL="${LIB_SHTPL_EN_HLP_DES_ARG_LOGDEST_TERMINAL}"

#  Script operation modes <ARG_MODE_...>
readonly L_TEX_EN_HLP_DES_ARG_MODE_DAEMON="${LIB_SHTPL_EN_HLP_DES_ARG_MODE_DAEMON}"
readonly L_TEX_EN_HLP_DES_ARG_MODE_INTERACTIVE_SUBMENU="${LIB_SHTPL_EN_HLP_DES_ARG_MODE_INTERACTIVE_SUBMENU}"

#===============================================================================
#  PARAMETER (CUSTOM)
#===============================================================================
#-------------------------------------------------------------------------------
#  arg_file_in
#-------------------------------------------------------------------------------
readonly L_TEX_EN_DLG_TTL_ARG_FILE_IN="Source File (LaTeX Template)"
readonly L_TEX_EN_DLG_TXT_ARG_FILE_IN="Please select a template file (.tex) to use."
readonly L_TEX_EN_HLP_DES_ARG_FILE_IN="LaTeX template file (.tex) to use"

#-------------------------------------------------------------------------------
#  arg_file_out
#-------------------------------------------------------------------------------
readonly L_TEX_EN_DLG_TTL_ARG_FILE_OUT="Output File (PDF)"
readonly L_TEX_EN_DLG_TXT_ARG_FILE_OUT="Please specify a path where the created letter (.pdf) will be stored."
readonly L_TEX_EN_HLP_DES_ARG_FILE_OUT="Output file (.pdf)"

#-------------------------------------------------------------------------------
#  arg_recp_addr
#-------------------------------------------------------------------------------
readonly L_TEX_EN_DLG_TTL_ARG_RECP_ADDR="Recipient (Address)"
readonly L_TEX_EN_DLG_TXT_ARG_RECP_ADDR="Please enter the recipient's delivery address, without the recipient's name."
readonly L_TEX_EN_DLG_STR_ARG_RECP_ADDR="\
123 Main Street
Anytown, CA 12345
USA"
readonly L_TEX_EN_HLP_DES_ARG_RECP_ADDR="Recipient's delivery address (without name)"

#-------------------------------------------------------------------------------
#  arg_recp_name
#-------------------------------------------------------------------------------
readonly L_TEX_EN_DLG_TTL_ARG_RECP_NAME="Recipient (Name)"
readonly L_TEX_EN_DLG_TXT_ARG_RECP_NAME="Please enter the recipient's name."
readonly L_TEX_EN_DLG_STR_ARG_RECP_NAME="Jane Doe"
readonly L_TEX_EN_HLP_DES_ARG_RECP_NAME="Recipient's name"

#-------------------------------------------------------------------------------
#  Last argument (parameter), see also <args_read()> in '/src/run.sh'
#-------------------------------------------------------------------------------
readonly L_TEX_EN_HLP_DES_LASTARG="${L_TEX_EN_HLP_DES_ARG_FILE_IN}"

#-------------------------------------------------------------------------------
#  Script actions <ARG_ACTION_...>
#-------------------------------------------------------------------------------
#  Main Menu Title/Text
readonly L_TEX_EN_DLG_TTL_ARG_ACTION="${L_ABOUT_PROJECT}"
readonly L_TEX_EN_DLG_TXT_ARG_ACTION="What would you like to do?"

#  ARG_ACTION_CREATE
readonly L_TEX_EN_DLG_ITM_ARG_ACTION_CREATE="Create letter and save as PDF file"
readonly L_TEX_EN_HLP_DES_ARG_ACTION_CREATE="${L_TEX_EN_DLG_ITM_ARG_ACTION_CREATE}"

#  ARG_ACTION_PRINT
readonly L_TEX_EN_DLG_ITM_ARG_ACTION_PRINT="Create letter and print"
readonly L_TEX_EN_HLP_DES_ARG_ACTION_PRINT="${L_TEX_EN_DLG_ITM_ARG_ACTION_PRINT}"

#===============================================================================
#  GLOBAL VARIABLES (CUSTOM)
#===============================================================================

#===============================================================================
#  FUNCTIONS (CUSTOM) (MENUS)
#===============================================================================
#-------------------------------------------------------------------------------
#  print
#-------------------------------------------------------------------------------
readonly L_TEX_EN_DLG_TXT_PRINT_1="Could not generate PDF file from TeX sources. ${LIB_SHTPL_EN_TXT_ABORTING}"
readonly L_TEX_EN_DLG_TXT_PRINT_2="Could not complete printing process successfully. ${LIB_SHTPL_EN_DLG_TXT_ERROR_TRYAGAIN}"

#===============================================================================
#  HELP
#===============================================================================
#-------------------------------------------------------------------------------
#  EXAMPLES
#-------------------------------------------------------------------------------
#  Example 1
readonly L_TEX_EN_HLP_TTL_EXAMPLES_1="Call main menu"
readonly L_TEX_EN_HLP_TXT_EXAMPLES_1="${L_TEX_HLP_TXT_EXAMPLES_1}"

#  Example 2
readonly L_TEX_EN_HLP_TTL_EXAMPLES_2="Print a letter based on template 'letter.tex', interactively ask for recipient"
readonly L_TEX_EN_HLP_TXT_EXAMPLES_2="${L_TEX_HLP_TXT_EXAMPLES_2}"

#  Example 3
readonly L_TEX_EN_HLP_TTL_EXAMPLES_3="Create letter with pre-defined recipient and save it as '~/letter.pdf'"
readonly L_TEX_EN_HLP_TXT_EXAMPLES_3="${L_TEX_HLP_TXT_EXAMPLES_3}"

#-------------------------------------------------------------------------------
#  NOTES
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#  REQUIREMENTS
#-------------------------------------------------------------------------------
#  Requirements 1
readonly L_TEX_EN_HLP_TTL_REQUIREMENTS_1="TeX (Environment)"
readonly L_TEX_EN_HLP_TXT_REQUIREMENTS_1="\
Required Packages:
${L_TEX_HLP_TXT_REQUIREMENTS_1_REQUIRED}

Depending on your LaTeX template you may need to install additional LaTeX packages."

#  Requirements 2
readonly L_TEX_EN_HLP_TTL_REQUIREMENTS_2="TeX (Letter Template)"
readonly L_TEX_EN_HLP_TXT_REQUIREMENTS_2="\
Please make sure that your TeX template is capable of using the system's environment variables. This script will provide the following additional environment variables to the template:

  arg_recp_addr :   Recipient's address (multiline, without name)
  arg_recp_name :   Recipient's name (one line)

This repository is shipped with a sample template, a customized version of 'GerLaTeXLetter', which you can find within '/$(basename "${I_DIR_TEX}")'. Please note that this template requires additional LaTeX packages. For more information please have a look at: ${L_TEX_HLP_TXT_REFERENCES_5}"

#  Requirements 3
readonly L_TEX_EN_HLP_TTL_REQUIREMENTS_3="Printing Support"
readonly L_TEX_EN_HLP_TXT_REQUIREMENTS_3="\
For printing support you may need additional packages. Please run './$(basename "${I_FILE_SH_CUPS}") --help' for further information."

#  Requirements 4
readonly L_TEX_EN_HLP_TTL_REQUIREMENTS_4="${LIB_SHTPL_EN_TXT_HELP_TTL_REQUIREMENTS_INTERACTIVE}"
readonly L_TEX_EN_HLP_TXT_REQUIREMENTS_4="${LIB_SHTPL_EN_TXT_HELP_TXT_REQUIREMENTS_INTERACTIVE}"

#-------------------------------------------------------------------------------
#  TEXTS
#-------------------------------------------------------------------------------
#  Intro Description
readonly L_TEX_EN_HLP_TXT_INTRO="A collection of shell scripts to interactively create and print TeX-based form letters."

#-------------------------------------------------------------------------------
#  TL;DR
#-------------------------------------------------------------------------------
# TL;DR 1
readonly L_TEX_EN_HLP_TTL_TLDR_1="Requirements (TeX environment)"
readonly L_TEX_EN_HLP_TXT_TLDR_1="\
To install the necessary packages on your system, simply run:

${L_TEX_HLP_TXT_TLDR_1_INSTALL}

Depending on your LaTeX template you may need to install additional LaTeX packages.

The script has been developed and tested on the following system:

OS:         ${L_TEX_HLP_TXT_TLDR_1_OS}
Kernel:     ${L_TEX_HLP_TXT_TLDR_1_KERNEL}
Packages:   ${L_TEX_HLP_TXT_TLDR_1_PACKAGES}"

# TL;DR 2
readonly L_TEX_EN_HLP_TTL_TLDR_2="Requirements (TeX Letter Template)"
readonly L_TEX_EN_HLP_TXT_TLDR_2="${L_TEX_EN_HLP_TXT_REQUIREMENTS_2}"

# TL;DR 3
readonly L_TEX_EN_HLP_TTL_TLDR_3="Requirements (Printing)"
readonly L_TEX_EN_HLP_TXT_TLDR_3="${L_TEX_EN_HLP_TXT_REQUIREMENTS_3}"


#===============================================================================
#  CUSTOM STRINGS (used in terminal output <stdout>/<stderr>)
#===============================================================================
#  TODO: Here you can define custom language-specific strings.
#        Do not forget to "publish" them within the <init_lang()> function of
#        your destination script, e.g. 'run.sh'.
#===============================================================================