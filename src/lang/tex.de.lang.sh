#!/bin/sh
#
# SPDX-FileCopyrightText: Copyright (c) 2023-2024 Florian Kemser and the TeXLetterCreator contributors
# SPDX-License-Identifier: GPL-3.0-or-later
#
#===============================================================================
#
#         FILE:   /src/lang/tex.de.lang.sh
#
#        USAGE:   ---
#                 (This is a constant file, so please do NOT run it.)
#
#  DESCRIPTION:   --German-- String Constants File for '/src/tex.sh'
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
readonly L_TEX_DE_HLP_DES_ARG_ACTION_HELP="${LIB_SHTPL_DE_HLP_DES_ARG_ACTION_HELP}"

#  Log destination <ARG_LOGDEST_...>
readonly L_TEX_DE_HLP_DES_ARG_LOGDEST="${LIB_SHTPL_DE_HLP_DES_ARG_LOGDEST}"
readonly L_TEX_DE_HLP_DES_ARG_LOGDEST_BOTH="${LIB_SHTPL_DE_HLP_DES_ARG_LOGDEST_BOTH}"
readonly L_TEX_DE_HLP_DES_ARG_LOGDEST_SYSLOG="${LIB_SHTPL_DE_HLP_DES_ARG_LOGDEST_SYSLOG}"
readonly L_TEX_DE_HLP_DES_ARG_LOGDEST_TERMINAL="${LIB_SHTPL_DE_HLP_DES_ARG_LOGDEST_TERMINAL}"

#  Script operation modes <ARG_MODE_...>
readonly L_TEX_DE_HLP_DES_ARG_MODE_DAEMON="${LIB_SHTPL_DE_HLP_DES_ARG_MODE_DAEMON}"
readonly L_TEX_DE_HLP_DES_ARG_MODE_INTERACTIVE_SUBMENU="${LIB_SHTPL_DE_HLP_DES_ARG_MODE_INTERACTIVE_SUBMENU}"

#===============================================================================
#  PARAMETER (CUSTOM)
#===============================================================================
#-------------------------------------------------------------------------------
#  arg_file_in
#-------------------------------------------------------------------------------
readonly L_TEX_DE_DLG_TTL_ARG_FILE_IN="Quelldatei (LaTeX-Vorlage)"
readonly L_TEX_DE_DLG_TXT_ARG_FILE_IN="Bitte wählen Sie eine bestehende Vorlagendatei (.tex) aus."
readonly L_TEX_DE_HLP_DES_ARG_FILE_IN="Zu verwendende LaTeX-Vorlagendatei (.tex). Sofern in der Datei weitere Umgebungsvariablen verwendet werden, sollten diese mit '${L_TEX_HLP_PAR_ARG_VARS}' angegeben werden. Dies stellt sicher, dass Zeichen mit \"besonderer Bedeutung\" wie beispielsweise '\$' maskiert ('\') werden, sofern der Inhalt der Variablen solche enthält."

#-------------------------------------------------------------------------------
#  arg_file_out
#-------------------------------------------------------------------------------
readonly L_TEX_DE_DLG_TTL_ARG_FILE_OUT="Ausgabedatei (.pdf)"
readonly L_TEX_DE_DLG_TXT_ARG_FILE_OUT="${LIB_SHTPL_DE_DLG_TXT_FILE_OUT_NOOVERRIDE}"
readonly L_TEX_DE_HLP_DES_ARG_FILE_OUT="Ausgabedatei (.pdf)"

#-------------------------------------------------------------------------------
#  arg_recp_addr
#-------------------------------------------------------------------------------
readonly L_TEX_DE_DLG_TTL_ARG_RECP_ADDR="Empfänger (Adresse)"
readonly L_TEX_DE_DLG_TXT_ARG_RECP_ADDR="Bitte geben Sie die Postadresse des Empfängers (ohne Namen) an."
readonly L_TEX_DE_DLG_STR_ARG_RECP_ADDR="\
Musterstraße 9
12345 Musterstadt"
readonly L_TEX_DE_HLP_DES_ARG_RECP_ADDR="Empfängeradresse (ohne Name)"

#-------------------------------------------------------------------------------
#  arg_recp_name
#-------------------------------------------------------------------------------
readonly L_TEX_DE_DLG_TTL_ARG_RECP_NAME="Empfänger (Name)"
readonly L_TEX_DE_DLG_TXT_ARG_RECP_NAME="Bitte geben Sie den Namen des Empfängers an."
readonly L_TEX_DE_DLG_STR_ARG_RECP_NAME="Erika Mustermann"
readonly L_TEX_DE_HLP_DES_ARG_RECP_NAME="Name des Empfängers"

#-------------------------------------------------------------------------------
#  arg_vars
#-------------------------------------------------------------------------------
readonly L_TEX_DE_HLP_DES_ARG_VARS="Variablen(namen), die im aufrufenden Skript bzw. Terminal exportiert wurden, zur weiteren Verwendung in der LaTeX-Vorlagendatei ('${L_TEX_HLP_PAR_ARG_FILE_IN}'). Mehrere Variablen werden durch Leerzeichen (' ') getrennt."

#-------------------------------------------------------------------------------
#  Last argument (parameter), see also <args_read()> in '/src/run.sh'
#-------------------------------------------------------------------------------
readonly L_TEX_DE_HLP_DES_LASTARG="${L_TEX_DE_HLP_DES_ARG_FILE_IN}"

#-------------------------------------------------------------------------------
#  Script actions <ARG_ACTION_...>
#-------------------------------------------------------------------------------
#  Main Menu Title/Text
readonly L_TEX_DE_DLG_TTL_ARG_ACTION="TeXLetterCreator"
readonly L_TEX_DE_DLG_TXT_ARG_ACTION="Was möchten Sie tun?"

#  ARG_ACTION_CREATE
readonly L_TEX_DE_DLG_ITM_ARG_ACTION_CREATE="Brief generieren und als PDF-Datei speichern"
readonly L_TEX_DE_HLP_DES_ARG_ACTION_CREATE="${L_TEX_DE_DLG_ITM_ARG_ACTION_CREATE}"

#  ARG_ACTION_PRINT
readonly L_TEX_DE_DLG_ITM_ARG_ACTION_PRINT="Brief generieren und drucken"
readonly L_TEX_DE_HLP_DES_ARG_ACTION_PRINT="${L_TEX_DE_DLG_ITM_ARG_ACTION_PRINT}"

#===============================================================================
#  GLOBAL VARIABLES (CUSTOM)
#===============================================================================

#===============================================================================
#  FUNCTIONS (CUSTOM) (MENUS)
#===============================================================================
#-------------------------------------------------------------------------------
#  print
#-------------------------------------------------------------------------------
readonly L_TEX_DE_DLG_TXT_PRINT_1="PDF-Datei konnte nicht aus TeX-Vorlage generiert werden. ${LIB_SHTPL_DE_TXT_ABORTING}"
readonly L_TEX_DE_DLG_TXT_PRINT_2="Der Druckvorgang konnte nicht erfolgreich abgeschlossen werden. ${LIB_SHTPL_DE_DLG_TXT_ERROR_TRYAGAIN}"

#===============================================================================
#  HELP
#===============================================================================
#-------------------------------------------------------------------------------
#  EXAMPLES
#-------------------------------------------------------------------------------
#  Example 1
readonly L_TEX_DE_HLP_TTL_EXAMPLES_1="Interaktiver Modus | Hauptmenü aufrufen"
readonly L_TEX_DE_HLP_TXT_EXAMPLES_1="${L_TEX_HLP_TXT_EXAMPLES_1}"

#  Example 2
readonly L_TEX_DE_HLP_TTL_EXAMPLES_2="Interaktiver Modus | Einen Brief anhand der Vorlage 'letter.tex' drucken, dabei nach dem Empfänger fragen"
readonly L_TEX_DE_HLP_TXT_EXAMPLES_2="${L_TEX_HLP_TXT_EXAMPLES_2}"

#  Example 3
readonly L_TEX_DE_HLP_TTL_EXAMPLES_3="Skript-Modus | Einen Brief mit vordefiniertem Empfänger erstellen und unter '~/letter.pdf' speichern"
readonly L_TEX_DE_HLP_TXT_EXAMPLES_3="${L_TEX_HLP_TXT_EXAMPLES_3}"

#-------------------------------------------------------------------------------
#  NOTES
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#  REQUIREMENTS
#-------------------------------------------------------------------------------
#  Requirements 1
readonly L_TEX_DE_HLP_TTL_REQUIREMENTS_1="TeX (Umgebung)"
readonly L_TEX_DE_HLP_TXT_REQUIREMENTS_1="\
Benötigte Pakete:
${L_TEX_HLP_TXT_REQUIREMENTS_1_REQUIRED}

Abhängig von der verwendeten TeX-Vorlage benötigen Sie unter Umständen weitere TeX-Pakete."

#  Requirements 2
readonly L_TEX_DE_HLP_TTL_REQUIREMENTS_2="TeX (Vorlage)"
readonly L_TEX_DE_HLP_TXT_REQUIREMENTS_2="\
Bitte stellen Sie sicher, dass Ihre TeX-Vorlage Umgebungsvariablen des Betriebssystems lesen kann. Dieses Skript stellt die folgenden zusätzlichen Umgebungsvariablen bereit:

  arg_recp_addr :   Empfängeradresse (mehrzeilig, ohne Name)
  arg_recp_name :   Empfängername (einzeilig)

Dieses Repository beinhaltet eine Beispielvorlage ('/test/tex/letter.tex'), eine angepasste Version von 'GerLaTeXLetter'. Diese Vorlage benötigt zusätzliche LaTeX-Pakete. Weitere Informationen hierzu finden Sie unter: ${L_TEX_HLP_TXT_REQUIREMENTS_2_SEEALSO}"

#  Requirements 3
readonly L_TEX_DE_HLP_TTL_REQUIREMENTS_3="Druckerunterstützung"
readonly L_TEX_DE_HLP_TXT_REQUIREMENTS_3="\
Zur Unterstützung der Druckfunktion benötigen Sie unter Umständen zusätzliche Pakete. Führen Sie './$(basename "${I_FILE_SH_CUPS}") --help' aus, um weitere Informationen zu erhalten."

#  Requirements 4
readonly L_TEX_DE_HLP_TTL_REQUIREMENTS_4="${LIB_SHTPL_DE_TXT_HELP_TTL_REQUIREMENTS_INTERACTIVE}"
readonly L_TEX_DE_HLP_TXT_REQUIREMENTS_4="${LIB_SHTPL_DE_TXT_HELP_TXT_REQUIREMENTS_INTERACTIVE}"

#-------------------------------------------------------------------------------
#  TEXTS
#-------------------------------------------------------------------------------
#  Intro Description
readonly L_TEX_DE_HLP_TXT_INTRO="Eine Sammlung von Shell-Skripts zum interaktiven Erstellen und Drucken von Briefen basierend auf einer TeX-Vorlage."

#-------------------------------------------------------------------------------
#  TL;DR
#-------------------------------------------------------------------------------
# TL;DR 1
readonly L_TEX_DE_HLP_TTL_TLDR_1="Anforderungen (TeX-Umgebung)"
readonly L_TEX_DE_HLP_TXT_TLDR_1="\
Um die benötigten Pakete zu installieren, führen Sie bitte folgenden Befehl aus:

${L_TEX_HLP_TXT_TLDR_1_INSTALL}

Abhängig von der verwendeten LaTeX-Vorlage benötigen Sie unter Umständen weitere LaTeX-Pakete.

Das Skript wurde in folgender Umgebung entwickelt und getestet:

OS:         ${L_TEX_HLP_TXT_TLDR_1_OS}
Kernel:     ${L_TEX_HLP_TXT_TLDR_1_KERNEL}
Pakete:     ${L_TEX_HLP_TXT_TLDR_1_PACKAGES}"

# TL;DR 2
readonly L_TEX_DE_HLP_TTL_TLDR_2="Anforderungen (TeX-Vorlage)"
readonly L_TEX_DE_HLP_TXT_TLDR_2="${L_TEX_DE_HLP_TXT_REQUIREMENTS_2}"

# TL;DR 3
readonly L_TEX_DE_HLP_TTL_TLDR_3="Anforderungen (Drucken)"
readonly L_TEX_DE_HLP_TXT_TLDR_3="${L_TEX_DE_HLP_TXT_REQUIREMENTS_3}"

#===============================================================================
#  CUSTOM STRINGS (used in terminal output <stdout>/<stderr>)
#===============================================================================
#  DONE: Here you can define custom language-specific strings.
#        Do not forget to "publish" them within the <init_lang()> function of
#        your destination script, e.g. 'run.sh'.
#===============================================================================