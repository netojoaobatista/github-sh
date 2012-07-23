#!/usr/bin/env bash
# Interactive Github Shell.
# Copyright (C) 2012 Henrique Moody <henriquemoody@gmail.com>.
#
# Authors
# =======
#   Henrique Moody <henriquemoody@gmail.com>
#
# Changelog
# =========
#   1.0.0   Base script
#

SCRIPT_NAME=$(basename "${0}")
SCRIPT_DESCRIPTION=$(sed -n 2p "${0}" |  sed -r 's/^# ?//g')
SCRIPT_VERSION=$(sed -n 11p "${0}" | awk '{print $2}')
SCRIPT_PROMPT="github> "

SCRIPT_HELP="Usage: ${SCRIPT_NAME} [OPTIONS]
${SCRIPT_DESCRIPTION}

    -h, --help      Displays this help.
    -s, --set       Defines default values for variables (\"user\", \"password\", \"project\").
    -v, --version   Displays the version of the program.
    -u, --update    Self update ${SCRIPT_NAME}.

Report bugs to: henriquemoody@gmail.com."

# Internal functions
source "inc/internal.sh"

# External functions
source "inc/external.sh"

while [ "${1}" != "" ]
do

    case "${1}" in

        -h | --help)

            echo "${SCRIPT_HELP}"
            exit 0

        ;;

        -s | --set)

            echo "${2}"  | tr ','  '\n' | while read line
            do
                key="$(echo ${line} | cut -d '=' -f 1)"
                value="$(echo ${line} | cut -d '=' -f 2-)"
                __external_set "${key}" "${value}"
            done

        ;;

        -V)

            echo "${SCRIPT_VERSION}"
            exit 0

        ;;

        -v | --version)

            echo "${SCRIPT_NAME} version ${SCRIPT_VERSION}"
            echo "${SCRIPT_DESCRIPTION}"
            exit 0

        ;;

        -u | --update)


            TEMPORARY=/tmp/github-sh_$(date +%s)
            curl -L git.io/github-sh -o ${TEMPORARY}
            chmod +x ${TEMPORARY}
            HEAD_VERSION=$(${TEMPORARY} -V)
            if [ "${HEAD_VERSION}" ==  "${SCRIPT_VERSION}" ]
            then
                echo "Nothing to update."
                echo "The last version of ${SCRIPT_NAME} is ${HEAD_VERSION}."
                rm -f ${TEMPORARY}
                exit 0
            fi

            if [ ! -w "${0}" ]
            then
                echo "You don't have permission to update ${SCRIPT_NAME}." 1>&2
                rm -f ${TEMPORARY}
                exit 3
            fi

            mv ${TEMPORARY} "${0}"
            echo "Successfully updated of ${SCRIPT_VERSION} to ${HEAD_VERSION}"
            exit 0

        ;;

        *)

            if [ "${1}" != "" ]
            then
                echo "${SCRIPT_HELP_MESSAGE}" 1>&2
                exit 2
            fi

        ;;

    esac

    shift 2

done

__shell