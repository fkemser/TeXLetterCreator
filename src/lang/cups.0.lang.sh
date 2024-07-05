#!/bin/sh
#
# SPDX-FileCopyrightText: Copyright (c) 2022-2024 Florian Kemser and the CUPSwrapper contributors
# SPDX-License-Identifier: GPL-3.0-or-later
#
#===============================================================================
#
#         FILE:   /src/lang/cups.0.lang.sh
#
#        USAGE:   ---
#                 (This is a constant file, so please do NOT run it.)
#
#  DESCRIPTION:   String Constants Files for '/src/cups.sh'
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
#  NAMING CONVENTION
#===============================================================================
#  Please make sure that your constants follow the naming convention below.
#  This ensures that <help()> and 'dialog' menus can be created more or less
#  automatically.
#
#===============================================================================
#  Language-independent constants, to be stored within THIS file
#===============================================================================
#-------------------------------------------------------------------------------
#  Used in help, section "ABOUT" and welcome dialogue
#-------------------------------------------------------------------------------
#  Constant                       Description
#  (Example)
#  -----------------------------------------------------------------------------
#  L_<S>_ABOUT_...                See 'ABOUT THIS REPOSITORY' section below.
#
#-------------------------------------------------------------------------------
#  Used in help, section "SYNOPSIS"
#-------------------------------------------------------------------------------
#  Constant                       Description             Example (value)
#  (Example)
#  -----------------------------------------------------------------------------
#  L_<S>_HLP_PAR_<REF>            Parameter cmd switch    -i|--int <int>
#  (L_RUN_HLP_PAR_ARG_INT)
#
#-------------------------------------------------------------------------------
#  Used in help, sections "REFERENCES"
#-------------------------------------------------------------------------------
#  Constant                       Description         Example (value)
#  (Example)
#  -----------------------------------------------------------------------------
#  L_<S>_HLP_TXT_REFERENCES_<I>   Reference           https://www.example.com
#  (L_RUN_HLP_TXT_REFERENCES_1)
#
#===============================================================================
#  Language-specific constants, to be stored within ANOTHER file,
#  e.g. within 'run.en.sh' for English, 'run.de.sh' for German, etc.
#===============================================================================
#-------------------------------------------------------------------------------
#  Used in interactive ('dialog') menus
#  (For more information on dialog please run 'dialog --help' or 'man dialog')
#-------------------------------------------------------------------------------
#  Constant                             Description       Parameter (dialog)
#  (Example)
#  -----------------------------------------------------------------------------
#  L_<S>_<LL>_DLG_ITM_<REF>             List item         <item1>...
#  (L_RUN_EN_DLG_ITM_ARG_ITEM_ITEM1)
#
#  L_<S>_<LL>_DLG_TTL_<REF>             Title             [--title <title>]
#  (L_RUN_EN_DLG_TTL_ARG_ITEM)
#
#  L_<S>_<LL>_DLG_TXT_<REF>             Text              <text>
#  (L_RUN_EN_DLG_TXT_ARG_ITEM)
#
#-------------------------------------------------------------------------------
#  Used in help, section "SYNOPSIS"
#-------------------------------------------------------------------------------
#  Constant                   Description             Example (value)
#  (Example)
#  -----------------------------------------------------------------------------
#  L_<S>_<LL>_HLP_DES_<REF>   Parameter description   Help <arg_int>
#  (L_RUN_EN_HLP_DES_ARG_INT)
#
#  L_<S>_<LL>_HLP_REF_<REF>   Reference description   Use '-i|--int <int>' to
#  (L_RUN_EN_HLP_REF_ARG_INT)                         specify <arg_int>'s value.
#
#-------------------------------------------------------------------------------
#  Used in help, sections "EXAMPLES" "NOTES" "REFERENCES" "REQUIREMENTS" "TLDR"
#-------------------------------------------------------------------------------
#  Constant                             Description       Example (value)
#  (Example)
#  -----------------------------------------------------------------------------
#  L_<S>_<LL>_HLP_TTL_EXAMPLES_<I>      Example (Title)   Show Help
#  (L_RUN_EN_HLP_TTL_EXAMPLES_1)
#
#  L_<S>_<LL>_HLP_TXT_EXAMPLES_<I>      Example (Text)    ./run.sh --help
#  (L_RUN_EN_HLP_TXT_EXAMPLES_1)
#
#  L_<S>_<LL>_HLP_TXT_NOTES_<I>         Note (Text)       This is the first note.
#  (L_RUN_EN_HLP_TXT_NOTES_1)
#
#  L_<S>_<LL>_HLP_TTL_REQUIREMENTS_<I>  Requirements (Title)  General
#  (L_RUN_EN_HLP_TTL_REQUIREMENTS_1)
#
#  L_<S>_<LL>_HLP_TXT_REQUIREMENTS_<I>  Requirements (Text)   To run this ...
#  (L_RUN_EN_HLP_TXT_REQUIREMENTS_1)
#
#  L_<S>_<LL>_HLP_TTL_TLDR_<I>          TL;DR (Title)     Requirements
#  (L_RUN_EN_HLP_TTL_TLDR_1)
#
#  L_<S>_<LL>_HLP_TXT_TLDR_<I>          TL;DR (Text)      Please install ...
#  (L_RUN_EN_HLP_TXT_TLDR_1)
#
#-------------------------------------------------------------------------------
#  Used in terminal output (<stdout>/<stderr>)
#-------------------------------------------------------------------------------
#  Constant             Description                               Example (value)
#  (Example)
#  -----------------------------------------------------------------------------
#  L_<S>_<LL>_TXT_<T>   Custom language-specific text constants   Text 1 (English)
#  (L_RUN_EN_TXT_TEXT1)
#
#===============================================================================
#  Reference
#===============================================================================
#  <...>  Description                                           Example(s)
#  -----------------------------------------------------------------------------
#  <I>    Index/Counter, starting from 1                        1
#
#  <LL>   Language ID (ISO 639-1)                               EN
#
#  <REF>  Function, parameter, or parameter list value          HELP
#         this constant refers to                               ARG_ACTION
#                                                               ARG_ACTION_HELP
#
#  <S>    "Reverse" script name without '.sh'                   RUN
#
#  <T>    Identifier that describes what the string is about    ERR_NOT_FOUND
#===============================================================================

#===============================================================================
#  ABOUT THIS REPOSITORY
#===============================================================================
#  Author name and mail address (multiple authors separated by newline)
readonly L_CUPS_ABOUT_AUTHORS="Florian Kemser and the CUPSwrapper contributors"

#  (Optional) Project description, should be a oneliner describing what the
#  project does. Please start with a low letter and leave the terminating
#  '.' out.
readonly L_CUPS_ABOUT_DESCRIPTION="a collection of shell scripts to interactively print and manage printers for local usage"

#  (Optional) Institution (multiple lines allowed)
readonly L_CUPS_ABOUT_INSTITUTION=""

#  (Optional) Project license (SPDX-License-Identifier)
#
#  For the full SPDX license list please have a look at
#  'https://spdx.org/licenses/'. However, only some licenses
#  are supported, see </lib/SHtemplateLIB/lib/licenses> folder.
#
#  If you are not sure which license to choose
#  just have a look at e.g. 'https://choosealicense.com'.
readonly L_CUPS_ABOUT_LICENSE="GPL-3.0-or-later"

#  (Optional) ASCII logo to display when running the script in interactive ('dialog') mode
readonly L_CUPS_ABOUT_LOGO=""

#  Project title, e.g. 'My Project'
readonly L_CUPS_ABOUT_PROJECT="CUPSwrapper"

#  DO NOT EDIT
readonly L_CUPS_ABOUT_RUN="./$(basename "$0")"

#  (Optional) Release/Version number, e.g. '1.1.0'
readonly L_CUPS_ABOUT_VERSION="1.0.0"

#  (Optional) Project year(s), e.g. '2023', '2023-2024'
readonly L_CUPS_ABOUT_YEARS="2022-2024"

#===============================================================================
#  PARAMETER (TEMPLATE) - DO NOT EDIT
#===============================================================================
#  Script actions <ARG_ACTION_...>
readonly L_CUPS_HLP_PAR_ARG_ACTION_HELP="${LIB_SHTPL_HLP_PAR_ARG_ACTION_HELP}"

#  Log destination <ARG_LOGDEST_...>
readonly L_CUPS_HLP_PAR_ARG_LOGDEST="${LIB_SHTPL_HLP_PAR_ARG_LOGDEST}"

#  Script operation modes <ARG_MODE_...>
readonly L_CUPS_HLP_PAR_ARG_MODE_DAEMON="${LIB_SHTPL_HLP_PAR_ARG_MODE_DAEMON}"
readonly L_CUPS_HLP_PAR_ARG_MODE_INTERACTIVE_SUBMENU="${LIB_SHTPL_HLP_PAR_ARG_MODE_INTERACTIVE_SUBMENU}"

#===============================================================================
#  PARAMETER (CUSTOM)
#===============================================================================
#-------------------------------------------------------------------------------
#  Script actions <ARG_ACTION_...>
#-------------------------------------------------------------------------------
readonly L_CUPS_HLP_PAR_ARG_ACTION_JOBSETTINGS="--jobsettings"
readonly L_CUPS_HLP_PAR_ARG_ACTION_PRINT="--print [<file>]"

#-------------------------------------------------------------------------------
#  Other parameters <arg_...>
#-------------------------------------------------------------------------------
readonly L_CUPS_HLP_PAR_ARG_FILE="<file>"

#-------------------------------------------------------------------------------
#  Last argument (parameter), see also <args_read()> in '/src/run.sh'
#-------------------------------------------------------------------------------
readonly L_CUPS_HLP_PAR_LASTARG="[${L_CUPS_HLP_PAR_ARG_FILE}]"

#===============================================================================
#  GLOBAL VARIABLES (CUSTOM)
#===============================================================================
#-------------------------------------------------------------------------------
#  pr_devuri
#-------------------------------------------------------------------------------
readonly L_CUPS_DLG_TXT_PR_DEVURI_2="\
(1) https://www.cups.org/doc/network.html#IPP
(2) https://www.cups.org/doc/network.html#SOCKET
(3) https://www.cups.org/doc/network.html#LPD
(4) https://wiki.debian.org/CUPSPrintQueues#deviceuri
(5) https://opensource.apple.com/source/cups/cups-86/doc/sdd.shtml
(6) https://opensource.apple.com/source/cups/cups-86/doc/sdd.shtml"

#-------------------------------------------------------------------------------
#  pr_queue
#-------------------------------------------------------------------------------
readonly L_CUPS_DLG_TXT_PR_QUEUE_21="(parallel|serial|usb)://<...>"
readonly L_CUPS_DLG_TXT_PR_QUEUE_22="ipps://<...>"
readonly L_CUPS_DLG_TXT_PR_QUEUE_4="[a-zA-Z0-9_%-]"

#===============================================================================
#  HELP
#===============================================================================
#-------------------------------------------------------------------------------
#  EXAMPLES
#-------------------------------------------------------------------------------
readonly L_CUPS_HLP_TXT_EXAMPLES_1="\
> ${L_CUPS_ABOUT_RUN} --print letter.pdf     # Print a PDF file named 'letter.pdf'
> echo Hello | ${L_CUPS_ABOUT_RUN} --print   # Print a command's output, here 'echo Hello'"

#-------------------------------------------------------------------------------
#  NOTES
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#  REFERENCES
#-------------------------------------------------------------------------------
readonly L_CUPS_HLP_TXT_REFERENCES_1="https://www.cups.org/doc/network.html"
readonly L_CUPS_HLP_TXT_REFERENCES_2="https://wiki.debian.org/CUPSPrintQueues"
readonly L_CUPS_HLP_TXT_REFERENCES_3="https://opensource.apple.com/source/cups/cups-86/doc/sdd.shtml"

#-------------------------------------------------------------------------------
#  REQUIREMENTS
#-------------------------------------------------------------------------------
readonly L_CUPS_HLP_TXT_REQUIREMENTS_1_PACKAGES="\
  General
  Avahi mDNS/DNS-SD-Daemon, Common UNIX Printing System(tm)

  Alpine
  > echo \"https://dl-cdn.alpinelinux.org/alpine/v\$(cut -d'.' -f1,2 /etc/alpine-release)/community/\" \\
    | sudo tee -a /etc/apk/repositories
  > echo \"@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing/\" | sudo tee -a /etc/apk/repositories
  > sudo apk update
  > sudo apk add avahi cups cups-filters cups-pdf@testing

  Debian
  > sudo apt install avahi-daemon cups"
readonly L_CUPS_HLP_TXT_REQUIREMENTS_1_GROUP_MEMBERSHIP="\
> sudo usermod -a -G lpadmin $(id -un)"
readonly L_CUPS_HLP_TXT_REQUIREMENTS_1_PRINTERDRIVERS="\
  Alpine
  > sudo apk add gutenprint-cups@testing

  Debian
  > sudo apt install printer-driver-all"

#-------------------------------------------------------------------------------
#  TEXTS
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#  TL;DR
#-------------------------------------------------------------------------------
readonly L_CUPS_HLP_TXT_TLDR_1_INSTALL="\
Alpine
> echo \"https://dl-cdn.alpinelinux.org/alpine/v\$(cut -d'.' -f1,2 /etc/alpine-release)/community/\" \\
  | sudo tee -a /etc/apk/repositories
> echo \"@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing/\" | sudo tee -a /etc/apk/repositories
> sudo apk update
> sudo apk add avahi dialog cups cups-filters cups-pdf@testing gutenprint-cups@testing

Debian
> sudo apt install avahi-daemon dialog cups printer-driver-all"
readonly L_CUPS_HLP_TXT_TLDR_1_KERNEL="5.15.133.1-microsoft-standard-WSL2"
readonly L_CUPS_HLP_TXT_TLDR_1_OS="Debian GNU/Linux 12 (bookworm)"
readonly L_CUPS_HLP_TXT_TLDR_1_PACKAGES="\
Avahi mDNS/DNS-SD-Daemon (0.8-10),
            Dialog (1.3-20230209-1),
            Common UNIX Printing System(tm) (2.4.2-3+deb12u5),
            printer drivers metapackage (0.20210903)"