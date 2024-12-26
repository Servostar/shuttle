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
LOG_FORMAT='"${level} | $0 | $(whoami) | $(date): ${message}"'
LOG_FILTER=${LOG_LEVEL_DEBUG}

_log_level_to_string()
{
    idx="${1}"

    # Log level as text ordered by integral level specified above.
    # Using positional parameters as drop in replacement for an array.
    set -- "trace" "debug" "info" "warn" "error" "fatal"

    # Indirect expansion.
    eval level="\$$idx"
    echo "$level"
}

_log()
{

    # Don't evaluate any logs in case the filter is greater than the current
    # log level.
    if [ "$1" -lt ${LOG_FILTER} ]; then
        return 0
    fi

    message="${2}"
    # May be used in substitution of message.
    # shellcheck disable=SC2034
    level="$(_log_level_to_string "${1}")"

    # Evaluate format to create finished log message.
    eval message="$LOG_FORMAT"

    # Must be printf instead of echo to correctly forward escape sequences.
    # NOTE: SC2059 does apply as evaluation of variables happens above.
    # shellcheck disable=SC2059
    printf "${message}\n"
}

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
