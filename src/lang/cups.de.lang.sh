#!/bin/sh
#
# SPDX-FileCopyrightText: Copyright (c) 2022-2024 Florian Kemser and the CUPSwrapper contributors
# SPDX-License-Identifier: GPL-3.0-or-later
#
#===============================================================================
#
#         FILE:   /src/lang/cups.de.lang.sh
#
#        USAGE:   ---
#                 (This is a constant file, so please do NOT run it.)
#
#  DESCRIPTION:   --German-- String Constants File for '/src/cups.sh'
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
readonly L_CUPS_DE_HLP_DES_ARG_ACTION_HELP="${LIB_SHTPL_DE_HLP_DES_ARG_ACTION_HELP}"

#  Log destination <ARG_LOGDEST_...>
readonly L_CUPS_DE_HLP_DES_ARG_LOGDEST="${LIB_SHTPL_DE_HLP_DES_ARG_LOGDEST}"
readonly L_CUPS_DE_HLP_DES_ARG_LOGDEST_BOTH="${LIB_SHTPL_DE_HLP_DES_ARG_LOGDEST_BOTH}"
readonly L_CUPS_DE_HLP_DES_ARG_LOGDEST_SYSLOG="${LIB_SHTPL_DE_HLP_DES_ARG_LOGDEST_SYSLOG}"
readonly L_CUPS_DE_HLP_DES_ARG_LOGDEST_TERMINAL="${LIB_SHTPL_DE_HLP_DES_ARG_LOGDEST_TERMINAL}"

#  Script operation modes <ARG_MODE_...>
readonly L_CUPS_DE_HLP_DES_ARG_MODE_DAEMON="${LIB_SHTPL_DE_HLP_DES_ARG_MODE_DAEMON}"
readonly L_CUPS_DE_HLP_DES_ARG_MODE_INTERACTIVE_SUBMENU="${LIB_SHTPL_DE_HLP_DES_ARG_MODE_INTERACTIVE_SUBMENU}"

#===============================================================================
#  PARAMETER (CUSTOM)
#===============================================================================
#-------------------------------------------------------------------------------
#  arg_file
#-------------------------------------------------------------------------------
readonly L_CUPS_DE_DLG_TTL_ARG_FILE="Dateiauswahl"
readonly L_CUPS_DE_DLG_TXT_ARG_FILE="Bitte wählen Sie die zu druckende Datei aus."

#-------------------------------------------------------------------------------
#  Last argument (parameter), see also <args_read()> in '/src/run.sh'
#-------------------------------------------------------------------------------
readonly L_CUPS_DE_HLP_DES_LASTARG="Zu druckende Datei (optional)"

#-------------------------------------------------------------------------------
#  Script actions <ARG_ACTION_...>
#-------------------------------------------------------------------------------
#  Main Menu Title/Text
readonly L_CUPS_DE_DLG_TTL_ARG_ACTION="CUPS Druckerverwaltung"
readonly L_CUPS_DE_DLG_TXT_ARG_ACTION="Was möchten Sie tun?"

#  ARG_ACTION_ADD
readonly L_CUPS_DE_DLG_ITM_ARG_ACTION_ADD="Neuen Drucker hinzufügen"

#  ARG_ACTION_CANCELJOB
readonly L_CUPS_DE_DLG_ITM_ARG_ACTION_CANCELJOB="Druckauftrag abbrechen"

#  ARG_ACTION_DEFAULT
readonly L_CUPS_DE_DLG_ITM_ARG_ACTION_DEFAULT="Standarddrucker festlegen"

#  ARG_ACTION_DEFSETTINGS
readonly L_CUPS_DE_DLG_ITM_ARG_ACTION_DEFSETTINGS="(Standard-)Druckeinstellungen festlegen"

#  ARG_ACTION_JOBSETTINGS
readonly L_CUPS_DE_DLG_ITM_ARG_ACTION_JOBSETTINGS="Druckauftrag-Einstellungen festlegen"
readonly L_CUPS_DE_HLP_DES_ARG_ACTION_JOBSETTINGS="Fordert den Nutzer interaktiv zur Auswahl des Druckers und der Druckeinstellungen auf. Die dort vorgenommenen Einstellungen werden auf der Standardausgabe (<stdout>) ausgegeben, um diese für andere Befehle, wie beispielsweise 'lp', nutzen zu können."

#  ARG_ACTION_PRINT
readonly L_CUPS_DE_DLG_ITM_ARG_ACTION_PRINT="Eine Datei drucken"
readonly L_CUPS_DE_HLP_DES_ARG_ACTION_PRINT="Führt einen Druckauftrag aus, wobei die zu druckenden Daten entweder aus einer Datei (<file>) oder dem Inhalt der Pipe <stdin> ('echo \"Zu druckender Text\" | ${L_CUPS_ABOUT_RUN} --print') stammen können."

#  ARG_ACTION_REMOVE
readonly L_CUPS_DE_DLG_ITM_ARG_ACTION_REMOVE="Bestehenden Drucker löschen"

#===============================================================================
#  GLOBAL VARIABLES (CUSTOM)
#===============================================================================
#-------------------------------------------------------------------------------
#  job_copies
#-------------------------------------------------------------------------------
readonly L_CUPS_DE_DLG_TTL_JOB_COPIES="Exemplare"
readonly L_CUPS_DE_DLG_TXT_JOB_COPIES="Wie viele Exemplare möchten Sie drucken?"

#-------------------------------------------------------------------------------
#  joblist
#-------------------------------------------------------------------------------
readonly L_CUPS_DE_DLG_TTL_JOBLIST_1="Druckerwarteschlange(n)"
readonly L_CUPS_DE_DLG_TXT_JOBLIST_1_CANCELJOB="\
Bitte wählen Sie die zu löschenden Aufträge aus.

${LIB_SHTPL_DE_DLG_TXT_CHECKLIST}"
readonly L_CUPS_DE_DLG_TXT_JOBLIST_2="Keine Druckaufträge vorhanden."

#-------------------------------------------------------------------------------
#  pr_devuri
#-------------------------------------------------------------------------------
readonly L_CUPS_DE_DLG_TTL_PR_DEVURI="Druckereinrichtung (Geräte-URI)"
readonly L_CUPS_DE_DLG_TXT_PR_DEVURI_1="Bitte wählen Sie in der nachfolgende Liste diejenige Adresse aus, die zu Ihrem Drucker gehört. Sollte Ihre Druckeradresse nicht aufgeführt sein, so wählen Sie bitte 'OTHER' am Ende der Liste."
readonly L_CUPS_DE_DLG_TXT_PR_DEVURI_2="\
Bitte geben Sie die Geräte-URI Ihres Druckers ein. Verwenden Sie dabei eines der nachfolgenden URI-Schemata:

(1) <http|ipp|ipps>://<IP_Adresse_oder_Hostname>[:<Portnummer>]/ipp/print
(1) <http|ipp|ipps>://<IP_Adresse_oder_Hostname>[:<Portnummer>]/printers/<Warteschlangenname>
(2) socket://<IP_Adresse_oder_Hostname>[:<Portnummer>]
(3) lpd://<IP_Adresse_oder_Hostname>[:<Portnummer>]/<Warteschlangenname>
(4) usb://<...>
(5) parallel:<Gerätepfad, z.B. '/dev/lp0'>
(6) serial:<Gerätepfad, z.B. '/dev/ttyS0'>?baud=<Baudrate, z.B. '115200'>

Weitere Informationen hierzu finden Sie unter:

${L_CUPS_DLG_TXT_PR_DEVURI_2}"
readonly L_CUPS_DE_DLG_ITM_PR_DEVURI_OTHER="Mein Drucker ist nicht aufgeführt, ich möchte diesen manuell hinzufügen."

#-------------------------------------------------------------------------------
#  pr_model
#-------------------------------------------------------------------------------
readonly L_CUPS_DE_DLG_TTL_PR_MODEL="Druckereinrichtung (Modell)"
readonly L_CUPS_DE_DLG_TXT_PR_MODEL="Bite geben Sie entweder

  - die Modellnummer, z.B. 'FS-1020', oder
  - den Hersteller, z.B. 'Kyocera', an,

oder eines der nachfolgenden Stichwörter (ohne ''):

  'driverless':   IPP treiberloses Drucken
                  (empfohlen - nutzt dabei den cups-filters PPD Generator)

  'everywhere':   IPP treiberloses Drucken
                  (nutzt dabei den CUPS PPD Generator)

     'generic':   Generischer PostScript (PS) oder
                  Printer Command Language (PCL) Treiber

         'raw':   Druckerwarteschlange ohne jegliches Filtersystem
                  (Druckauftrag wird direkt an den Drucker geschickt)

----------------
 BITTE BEACHTEN
----------------
Abhängig vom eingegebenen Suchbegriff dauert es eventuell einige Minuten, bis das nachfolgende Menü angezeigt wird. Sollte dieses Menü leer sein, so benötigen Sie unter Umständen zusätzliche Treiber, mehr Informationen finden Sie in der Hilfe."

#-------------------------------------------------------------------------------
#  pr_options
#-------------------------------------------------------------------------------
readonly L_CUPS_DE_DLG_TTL_PR_OPTIONS="Druckeroptionen"
readonly L_CUPS_DE_DLG_TXT_PR_OPTIONS_1="Bitte wählen Sie die Option aus, die Sie bearbeiten möchten. Zum Speichern und Fortfahren wählen Sie bitte '${LIB_SHTPL_DLG_TAG_EXIT}' am Anfang/Ende der Liste."
readonly L_CUPS_DE_DLG_TXT_PR_OPTIONS_2="Bitte wählen Sie einen der nachfolgenden Werte aus.
(Ein Stern '*' markiert die aktuelle Standardeinstellung.)"
readonly L_CUPS_DE_DLG_TXT_PR_OPTIONS_31="\
====================
 Geänderte Optionen
===================="
readonly L_CUPS_DE_DLG_TXT_PR_OPTIONS_32="(Keine Änderungen - es werden die aktuellen Standardeinstellungen verwendet.)"
readonly L_CUPS_DE_DLG_TXT_PR_OPTIONS_33="${LIB_SHTPL_DE_DLG_TXT_CONTINUE}"

#-------------------------------------------------------------------------------
#  pr_ppd
#-------------------------------------------------------------------------------
readonly L_CUPS_DE_DLG_TTL_PR_PPD="Druckereinrichtung (PPD Datei)"
readonly L_CUPS_DE_DLG_TXT_PR_PPD="Bitte wählen Sie eine der nachfolgenden PPD Dateien aus:"
readonly L_CUPS_DE_DLG_ITM_PR_PPD_OTHER="Mein Drucker ist nicht aufgeführt, ich möchte nach einem anderen Modell suchen."

#-------------------------------------------------------------------------------
#  pr_queue
#-------------------------------------------------------------------------------
readonly L_CUPS_DE_DLG_TTL_PR_QUEUE="Druckereinrichtung"
readonly L_CUPS_DE_DLG_TTL_PR_QUEUE_ADD="${L_CUPS_DE_DLG_ITM_ARG_ACTION_ADD}"
readonly L_CUPS_DE_DLG_TTL_PR_QUEUE_DEFAULT="${L_CUPS_DE_DLG_ITM_ARG_ACTION_DEFAULT}"
readonly L_CUPS_DE_DLG_TTL_PR_QUEUE_DEFSETTINGS="${L_CUPS_DE_DLG_ITM_ARG_ACTION_DEFSETTINGS}"
readonly L_CUPS_DE_DLG_TTL_PR_QUEUE_JOBSETTINGS="${L_CUPS_DE_DLG_ITM_ARG_ACTION_JOBSETTINGS}"
readonly L_CUPS_DE_DLG_TTL_PR_QUEUE_REMOVE="${L_CUPS_DE_DLG_ITM_ARG_ACTION_REMOVE}"
readonly L_CUPS_DE_DLG_TXT_PR_QUEUE_1="Bitte stellen Sie sicher, dass Ihr Drucker angeschlossen, eingeschaltet und betriebsbereit ist."
readonly L_CUPS_DE_DLG_TXT_PR_QUEUE_2="Bitte wählen Sie einen der nachfolgenden Drucker aus. Sollte Ihr Gerät nicht aufgeführt sein, so wählen Sie bitte 'OTHER' am Ende der Liste.

${LIB_SHTPL_DE_DLG_TXT_ATTENTION}
Für Dokumente mit vertraulichen Daten, wie beispielsweise Passwörtern, PINs, etc., sollten Sie ausschließlich Drucker verwenden, die entweder

  - lokal (${L_CUPS_DLG_TXT_PR_QUEUE_21}) oder
  - über eine sichere Netzwerkverbindung (${L_CUPS_DLG_TXT_PR_QUEUE_22})

an Ihren PC angebunden sind.

Andernfalls besteht die Gefahr, dass unbefugte Dritte Ihre vertraulichen Daten abfangen könnten."
readonly L_CUPS_DE_DLG_TXT_PR_QUEUE_2_DEFAULT="Bitte legen Sie Ihren Standarddrucker fest. Ihr aktueller Standarddrucker ist:"
readonly L_CUPS_DE_DLG_TXT_PR_QUEUE_3="Kein Drucker gefunden."
readonly L_CUPS_DE_DLG_TXT_PR_QUEUE_4="Bitte geben Sie einen gültigen, noch nicht vergebenen, Warteschlangennamen an. Erlaubte Zeichen: ${L_CUPS_DLG_TXT_PR_QUEUE_4}"
readonly L_CUPS_DE_DLG_ITM_PR_QUEUE_OTHER="Mein Drucker ist nicht aufgeführt bzw. ich möchte einen neuen Drucker einrichten."

#===============================================================================
#  FUNCTIONS (CUSTOM) (MENUS)
#===============================================================================
#-------------------------------------------------------------------------------
#  add
#-------------------------------------------------------------------------------
readonly L_CUPS_DE_DLG_TXT_ADD_1="Der Drucker konnte nicht hinzugefügt werden. Fehlermeldung:"
readonly L_CUPS_DE_DLG_TXT_ADD_2="Drucker wurde nicht hinzugefügt. ${LIB_SHTPL_DE_TXT_ABORTING}"

#-------------------------------------------------------------------------------
#  canceljob
#-------------------------------------------------------------------------------
readonly L_CUPS_DE_DLG_TXT_CANCELJOB_1="Druckaufträge erfolgreich abgebrochen."
readonly L_CUPS_DE_DLG_TXT_CANCELJOB_2="Ein oder mehrere Druckaufträge konnten nicht abgebrochen werden. Fehlermeldung:"

#-------------------------------------------------------------------------------
#  print
#-------------------------------------------------------------------------------
readonly L_CUPS_DE_DLG_TXT_PRINT_1="Der Druckauftrag wurde an den Drucker gesendet:"
readonly L_CUPS_DE_DLG_TXT_PRINT_2="Druckauftrag konnte nicht gesendet werden. Fehlermeldung:"

#-------------------------------------------------------------------------------
#  testpage
#-------------------------------------------------------------------------------
readonly L_CUPS_DE_DLG_TTL_TESTPAGE="Druckereinrichtung (Testseite)"
readonly L_CUPS_DE_DLG_TXT_TESTPAGE_1="Das Skript wird jetzt eine Testseite (leere Seite mit einem Punkt '.') drucken. Bitte stellen Sie sicher, dass Ihr Drucker betriebsbereit ist und drücken Sie die <Eingabetaste> um mit dem Druckvorgang zu beginnen."
readonly L_CUPS_DE_DLG_TXT_TESTPAGE_2="Wurde die Seite erfolgreich gedruckt?"

#===============================================================================
#  HELP
#===============================================================================
#-------------------------------------------------------------------------------
#  EXAMPLES
#-------------------------------------------------------------------------------
# Example 1
readonly L_CUPS_DE_HLP_TTL_EXAMPLES_1="Drucken"
readonly L_CUPS_DE_HLP_TXT_EXAMPLES_1="${L_CUPS_HLP_TXT_EXAMPLES_1}"

#-------------------------------------------------------------------------------
#  NOTES
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#  REQUIREMENTS
#-------------------------------------------------------------------------------
#  Requirements 1
readonly L_CUPS_DE_HLP_TTL_REQUIREMENTS_1="Allgemein"
readonly L_CUPS_DE_HLP_TXT_REQUIREMENTS_1="\
Benötigte Pakete:
${L_CUPS_HLP_TXT_REQUIREMENTS_1_PACKAGES}

Gruppen-Mitgliedschaft:
  Der ausführende Benutzer muss ein Mitglied der Gruppe 'lpadmin' sein:
  ${L_CUPS_HLP_TXT_REQUIREMENTS_1_GROUP_MEMBERSHIP}

Zusätzliche Druckertreiber (optional):
  Für den Fall, dass Ihr Drucker noch nicht das treiberlose Drucken (IPP)
  unterstützt, benötigen Sie unter Umständen zusätzliche Druckertreiber:

${L_CUPS_HLP_TXT_REQUIREMENTS_1_PRINTERDRIVERS}"

#  Requirements 2
readonly L_CUPS_DE_HLP_TTL_REQUIREMENTS_2="${LIB_SHTPL_DE_TXT_HELP_TTL_REQUIREMENTS_INTERACTIVE}"
readonly L_CUPS_DE_HLP_TXT_REQUIREMENTS_2="${LIB_SHTPL_DE_TXT_HELP_TXT_REQUIREMENTS_INTERACTIVE}"

#  Requirements 3
readonly L_CUPS_DE_HLP_TTL_REQUIREMENTS_3="${LIB_SHTPL_DE_TXT_HELP_TTL_REQUIREMENTS_WSL_SYSTEMD}"
readonly L_CUPS_DE_HLP_TXT_REQUIREMENTS_3="${LIB_SHTPL_DE_TXT_HELP_TXT_REQUIREMENTS_WSL_SYSTEMD}"

#-------------------------------------------------------------------------------
#  TEXTS
#-------------------------------------------------------------------------------
# Intro Description
readonly L_CUPS_DE_HLP_TXT_INTRO="Stellt interaktive Menüs zum Drucken und für die lokale(!) Druckverwaltung bereit. Dies ist kein Ersatz für die CUPS Daemon-/Server-Administration."

#-------------------------------------------------------------------------------
#  TL;DR
#-------------------------------------------------------------------------------
readonly L_CUPS_DE_HLP_TTL_TLDR_1="Anforderungen"
readonly L_CUPS_DE_HLP_TXT_TLDR_1="\
Um die benötigten Pakete zu installieren, führen Sie bitte folgenden Befehl aus:

${L_CUPS_HLP_TXT_TLDR_1_INSTALL}

Der ausführende Benutzer muss ein Mitglied der Gruppe 'lpadmin' sein:
${L_CUPS_HLP_TXT_REQUIREMENTS_1_GROUP_MEMBERSHIP}

Das Skript wurde in folgender Umgebung entwickelt und getestet:

OS:         ${L_CUPS_HLP_TXT_TLDR_1_OS}
Kernel:     ${L_CUPS_HLP_TXT_TLDR_1_KERNEL}
Pakete:     ${L_CUPS_HLP_TXT_TLDR_1_PACKAGES}"

#===============================================================================
#  CUSTOM STRINGS (used in terminal output <stdout>/<stderr>)
#===============================================================================
#  DONE: Here you can define custom language-specific strings.
#        Do not forget to "publish" them within the <init_lang()> function of
#        your destination script, e.g. 'run.sh'.
#===============================================================================