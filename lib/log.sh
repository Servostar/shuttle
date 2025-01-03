#!/bin/sh

# Logging
# =============================================================================
# Functions to log information with configurable format and outputs.
#
# Copyright (c) 2024
# srvstr

LOG_LEVEL_TRACE=1
LOG_LEVEL_DEBUG=2
LOG_LEVEL_INFO=3
LOG_LEVEL_WARN=4
LOG_LEVEL_ERROR=5
LOG_LEVEL_FATAL=6

# Defer evaluation of substitutions to _log().
# shellcheck disable=SC2016
LOG_FORMAT='"${level} | $0 | $(whoami) | $(date --rfc-3339 s): ${message}"'
LOG_FILTER=${LOG_LEVEL_DEBUG}

_log_level_to_string()
(
    # Don't continue in case the index is out of range or no log level was
    # supplied.
    if [ -z "$1" ] || [ "$1" -lt 1 ] || [ "$1" -gt 6 ]; then
        return 1
    fi

    idx="${1}"

    # Log level as text ordered by integral level specified above.
    # Using positional parameters as drop in replacement for an array.
    set -- "trace" "debug" "info" "warn" "error" "fatal"

    # Indirect expansion.
    eval level="\$$idx"
    echo "$level"
)

_log()
(
    # Avoid indirect positional parmater expansion in case the index is out of
    # range or no argument was supplied.
    if [ -z "$1" ] || [ "$1" -lt 1 ] || [ "$1" -gt 6 ]; then
        return 1
    fi

    # Don't evaluate any logs in case the filter is greater than the current
    # log level or the message is empty.
    if [ "$1" -lt ${LOG_FILTER} ] || [ -z "$2" ]; then
        return 0
    fi

    # May be used in substitution of the entry format.
    # shellcheck disable=SC2034
    message="${2}"
    # May be used in substitution of the entry format.
    # shellcheck disable=SC2034
    level="$(_log_level_to_string "${1}" || echo "unknown")"

    # Evaluate format to create finished log message.
    if ! eval entry="$LOG_FORMAT"; then
        # Temporarily save erroneous format.
        invalid_format="$LOG_FORMAT"
        # Overwrite with fallback entry format.
        # shellcheck disable=SC2016
        LOG_FORMAT='"${level} | $0 | $(whoami) | $(date): ${message}"'
        # Notify about error in log.
        error "Invalid log format detected: '$invalid_format'"
        # Format original message with fallback format.
        eval entry="$LOG_FORMAT"
        # Restore format.
        LOG_FORMAT="$invalid_format"
    fi

    # Must be printf instead of echo to correctly forward escape sequences.
    # NOTE: SC2059 does not apply as evaluation of variables happens above.
    # shellcheck disable=SC2059,SC2154
    printf "${entry}\n"
)

trace()
{
    _log ${LOG_LEVEL_TRACE} "${1}"
}

debug()
{
    _log ${LOG_LEVEL_DEBUG} "${1}"
}

info()
{
    _log ${LOG_LEVEL_INFO} "${1}"
}

warn()
{
    _log ${LOG_LEVEL_WARN} "${1}"
}

error()
{
    _log ${LOG_LEVEL_ERROR} "${1}"
}

fatal()
{
    _log ${LOG_LEVEL_FATAL} "${1}"
}
