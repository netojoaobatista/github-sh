# _set VARIABLE [ VALUE ]
_set()
{
    local label="${1}"
    local value="${2}"

    if [ "${label}" == "password" ] && [ "${value}" == "" ]; then
        read -s -p "Type your password: " value
        _echo ""
    elif [ "${value}" == "" ]; then
        read -e -p "Value for ${label}: " value
    fi

    case "${label}" in 

        username)
            GITHUB_USERNAME="${value}"
        ;;

        password)
            GITHUB_PASSWORD="${value}"
        ;;

        repository)
            GITHUB_REPOSITORY="${value}"
        ;;

        *)
          _echo -e "[31]Invalid variable [34]${label}[0]"
          return 2

    esac

    GITHUB_PROMPT="${SCRIPT_PROMPT}"
    if [ -z "${GITHUB_USERNAME}" ]; then
        GITHUB_PROMPT="${GITHUB_PROMPT}:**"
    else
        GITHUB_PROMPT="${GITHUB_PROMPT}:${GITHUB_USERNAME}"
    fi

    if [ ! -z "${GITHUB_REPOSITORY}" ]; then
        GITHUB_PROMPT="${GITHUB_PROMPT}/${GITHUB_REPOSITORY}"
    fi

    GITHUB_PROMPT="${GITHUB_PROMPT}${SCRIPT_PROMPT_CHAR}"

    return 0
}
