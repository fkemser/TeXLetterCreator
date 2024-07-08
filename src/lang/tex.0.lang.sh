#!/bin/sh
#
# SPDX-FileCopyrightText: Copyright (c) 2023-2024 Florian Kemser and the TeXLetterCreator contributors
# SPDX-License-Identifier: GPL-3.0-or-later
#
#===============================================================================
#
#         FILE:   /src/lang/tex.0.lang.sh
#
#        USAGE:   ---
#                 (This is a constant file, so please do NOT run it.)
#
#  DESCRIPTION:   String Constants Files for '/src/tex.sh'
#                 Used to generate help texts, interactive dialogues,
#                 and other  terminal/log messages.
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
readonly L_TEX_ABOUT_AUTHORS="Florian Kemser and the TeXLetterCreator contributors"

#  (Optional) Project description, should be a oneliner describing what the
#  project does. Please start with a low letter and leave the terminating
#  '.' out.
readonly L_TEX_ABOUT_DESCRIPTION="a collection of shell scripts to interactively create and print TeX-based form letters"

#  (Optional) Institution (multiple lines allowed)
readonly L_TEX_ABOUT_INSTITUTION=""

#  (Optional) Project license (SPDX-License-Identifier)
#
#  For the full SPDX license list please have a look at
#  'https://spdx.org/licenses/'. However, only some licenses
#  are supported, see </lib/SHtemplateLIB/lib/licenses> folder.
#
#  If you are not sure which license to choose
#  just have a look at e.g. 'https://choosealicense.com'.
readonly L_TEX_ABOUT_LICENSE="GPL-3.0-or-later"

#  (Optional) ASCII logo to display when running the script in interactive ('dialog') mode
readonly L_TEX_ABOUT_LOGO=""

#  Project title, e.g. 'My Project'
readonly L_TEX_ABOUT_PROJECT="TeXLetterCreator"

#  DO NOT EDIT
readonly L_TEX_ABOUT_RUN="./$(basename "$0")"

#  (Optional) Release/Version number, e.g. '1.1.0'
readonly L_TEX_ABOUT_VERSION="1.0.0"

#  (Optional) Project year(s), e.g. '2023', '2023-2024'
readonly L_TEX_ABOUT_YEARS="2023-2024"

#===============================================================================
#  PARAMETER (TEMPLATE) - DO NOT EDIT
#===============================================================================
#  Script actions <ARG_ACTION_...>
readonly L_TEX_HLP_PAR_ARG_ACTION_HELP="${LIB_SHTPL_HLP_PAR_ARG_ACTION_HELP}"

#  Other parameters <arg_...>
readonly L_TEX_HLP_PAR_ARG_LOGDEST="${LIB_SHTPL_HLP_PAR_ARG_LOGDEST}"

#  Script operation modes <ARG_MODE_...>
readonly L_TEX_HLP_PAR_ARG_MODE_DAEMON="${LIB_SHTPL_HLP_PAR_ARG_MODE_DAEMON}"
readonly L_TEX_HLP_PAR_ARG_MODE_INTERACTIVE_SUBMENU="${LIB_SHTPL_HLP_PAR_ARG_MODE_INTERACTIVE_SUBMENU}"

#===============================================================================
#  PARAMETER (CUSTOM)
#===============================================================================
#-------------------------------------------------------------------------------
#  Script actions <ARG_ACTION_...>
#-------------------------------------------------------------------------------
readonly L_TEX_HLP_PAR_ARG_ACTION_CREATE="--create"
readonly L_TEX_HLP_PAR_ARG_ACTION_PRINT="--print"

#-------------------------------------------------------------------------------
#  Other parameters <arg_...>
#-------------------------------------------------------------------------------
readonly L_TEX_HLP_PAR_ARG_FILE_IN="-i|--in <file_in>"
readonly L_TEX_HLP_PAR_ARG_FILE_OUT="-o|--out <file_out>"
readonly L_TEX_HLP_PAR_ARG_RECP_ADDR="-a|--address <address>"
readonly L_TEX_HLP_PAR_ARG_RECP_NAME="-n|--name <name>"
readonly L_TEX_HLP_PAR_ARG_VARS="-v|--vars <vars>"

#-------------------------------------------------------------------------------
#  Last argument (parameter), see also <args_read()> in '/src/run.sh'
#-------------------------------------------------------------------------------
readonly L_TEX_HLP_PAR_LASTARG="[ <file_in> ]"

#===============================================================================
#  HELP
#===============================================================================
#-------------------------------------------------------------------------------
#  EXAMPLES
#-------------------------------------------------------------------------------
readonly L_TEX_HLP_TXT_EXAMPLES_1="> ${L_TEX_ABOUT_RUN}"
readonly L_TEX_HLP_TXT_EXAMPLES_2="> ${L_TEX_ABOUT_RUN} --submenu print \"../test/tex/letter.tex\""
readonly L_TEX_HLP_TXT_EXAMPLES_3="\
> addr=\"\\
123 Main Street
Anytown, CA 12345
USA\"
> name=\"Jane Doe\"
> ${L_TEX_ABOUT_RUN} --create --address \"\${addr}\" --name \"\${name}\" --out \"~/letter.pdf\" \"../test/tex/letter.tex\""

#-------------------------------------------------------------------------------
#  NOTES
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#  REFERENCES
#-------------------------------------------------------------------------------
readonly L_TEX_HLP_TXT_REFERENCES_1="https://www.tug.org/texlive/"
readonly L_TEX_HLP_TXT_REFERENCES_2="https://www.latex-project.org/"
readonly L_TEX_HLP_TXT_REFERENCES_3="https://www.luatex.org/"
readonly L_TEX_HLP_TXT_REFERENCES_4="https://github.com/fkemser/CUPSwrapper"
readonly L_TEX_HLP_TXT_REFERENCES_5="https://github.com/fkemser/GerLaTeXLetter"
readonly L_TEX_HLP_TXT_REFERENCES_6="https://github.com/fkemser/SHtemplate"
readonly L_TEX_HLP_TXT_REFERENCES_7="https://github.com/fkemser/TeXLetterCreator"

#-------------------------------------------------------------------------------
#  REQUIREMENTS
#-------------------------------------------------------------------------------
readonly L_TEX_HLP_TXT_REQUIREMENTS_1_REQUIRED="\
  General: TeX Live: LaTeX recommended packages, TeX Live: LuaTeX packages
   Debian: > sudo apt install texlive-latex-recommended texlive-luatex"
readonly L_TEX_HLP_TXT_REQUIREMENTS_2_SEEALSO="https://github.com/fkemser/GerLaTeXLetter#customization"

#-------------------------------------------------------------------------------
#  TEXTS
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#  TL;DR
#-------------------------------------------------------------------------------
readonly L_TEX_HLP_TXT_TLDR_1_INSTALL="\
Debian
> sudo apt install dialog texlive-latex-recommended texlive-luatex"
readonly L_TEX_HLP_TXT_TLDR_1_KERNEL="5.15.90.1-microsoft-standard-WSL2"
readonly L_TEX_HLP_TXT_TLDR_1_OS="Debian GNU/Linux 12 (bookworm)"
readonly L_TEX_HLP_TXT_TLDR_1_PACKAGES="\
Dialog (1.3-20230209-1),
            TeX Live: LaTeX recommended packages (2022.20230122-3),
            TeX Live: LuaTeX packages (2022.20230122-3)"