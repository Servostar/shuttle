#!/bin/sh

# Styles
# =============================================================================
# Configurable environment variables and functions used to apply styles to
# strings printed to a pseudo terminal. This module is a wrapper around the
# ecma48 module providing the necessary escape sequences.
#
# Styling is done by using any `STYLE_*` environment variables:
#  - STYLE_RESET
#  - STYLE_BOLD
#  - STYLE_FAINT
#  - STYLE_ITALIC
#  - STYLE_UNDERLNE
#  - STYLE_BLINK_SLOW
#  - STYLE_BLINK_RAPID
#  - STYLE_FG_BLACK
#  - STYLE_FG_RED
#  - STYLE_FG_GREEN
#  - STYLE_FG_YELLOW
#  - STYLE_FG_BLUE
#  - STYLE_FG_MAGENTA
#  - STYLE_FG_CYAN
#  - STYLE_FG_WHITE
#  - STYLE_BG_BLACK
#  - STYLE_BG_RED
#  - STYLE_BG_GREEN
#  - STYLE_BG_YELLOW
#  - STYLE_BG_BLUE
#  - STYLE_BG_MAGENTA
#  - STYLE_BG_CYAN
#  - STYLE_BG_WHITE
# or custom functions such as:
#  - style_fg_8
#  - style_fg_256
#  - style_fg_rgb
#  - style_fg_bright
#  - style_bg_8
#  - style_bg_256
#  - style_bg_rgb
#  - style_bg_bright
#
# Configuration
# .............................................................................
# All of the above functions and variables can be dynamically enabled or
# disabled by setting $STYLE_ACTIVE to either true or false. In case the
# underlying implementation (based on ECMA-48) does not support the styling
# the variable will be empty even if $STYLE_ACTIVE is set to true.
# Styling can either be forced on or off by setting $STYLE_FORCE to true or
# false. Disable any forcing by unsetting $STYLE_FORCE.
#
# Copyright (c) 2024
# srvstr

# Enable styling variables.
STYLE_ACTIVE="true"

style_enabled()
{
    # Styling can be forced either on or off.
    # Unset by default as to make styling depend on lousy support detection.
    if [ -n "$STYLE_FORCE" ]; then
        if "$STYLE_FORCE"; then
            echo "enforced"
            return 0
        else
            return 1
        fi
    # Styling is enabled in case ECMA-48 is supported and its acivated by the
    # user.
    elif [ -n "$ECMA48_SUPPORTED" ] && "$STYLE_ACTIVE"; then
        echo "$ECMA48_SUPPORTED"
        return 0
    # Neither forcing a value nor optionally enableling it.
    else
        return 1
    fi
}

STYLE_ENABLED="$(style_enabled)"
export STYLE_ENABLED

# Special styling and actions.
# .............................................................................

STYLE_RESET="${STYLE_ENABLED:+${ECMA48_SGR_RESET}}"
STYLE_BOLD="${STYLE_ENABLED:+${ECMA48_SGR_BOLD}}"
STYLE_FAINT="${STYLE_ENABLED:+${ECMA48_SGR_FAINT}}"
STYLE_ITALIC="${STYLE_ENABLED:+${ECMA48_SGR_ITALIC}}"
STYLE_UNDERLNE="${STYLE_ENABLED:+${ECMA48_SGR_UNDERLNE}}"
STYLE_BLINK_SLOW="${STYLE_ENABLED:+${ECMA48_SGR_BLINK_SLOW}}"
STYLE_BLINK_RAPID="${STYLE_ENABLED:+${ECMA48_SGR_BLINK_RAPID}}"

export STYLE_RESET
export STYLE_BOLD
export STYLE_FAINT
export STYLE_ITALIC
export STYLE_UNDERLNE
export STYLE_BLINK_SLOW
export STYLE_BLINK_RAPID

# 8 standard colors defined by their names.
# .............................................................................

STYLE_FG_BLACK="${STYLE_ENABLED:+${ECMA48_SGR_FG_BLACK}}"
STYLE_FG_RED="${STYLE_ENABLED:+${ECMA48_SGR_FG_RED}}"
STYLE_FG_GREEN="${STYLE_ENABLED:+${ECMA48_SGR_FG_GREEN}}"
STYLE_FG_YELLOW="${STYLE_ENABLED:+${ECMA48_SGR_FG_YELLOW}}"
STYLE_FG_BLUE="${STYLE_ENABLED:+${ECMA48_SGR_FG_BLUE}}"
STYLE_FG_MAGENTA="${STYLE_ENABLED:+${ECMA48_SGR_FG_MAGENTA}}"
STYLE_FG_CYAN="${STYLE_ENABLED:+${ECMA48_SGR_FG_CYAN}}"
STYLE_FG_WHITE="${STYLE_ENABLED:+${ECMA48_SGR_FG_WHITE}}"

export STYLE_FG_BLACK
export STYLE_FG_RED
export STYLE_FG_GREEN
export STYLE_FG_YELLOW
export STYLE_FG_BLUE
export STYLE_FG_MAGENTA
export STYLE_FG_CYAN
export STYLE_FG_WHITE

STYLE_BG_BLACK="${STYLE_ENABLED:+${ECMA48_SGR_BG_BLACK}}"
STYLE_BG_RED="${STYLE_ENABLED:+${ECMA48_SGR_BG_RED}}"
STYLE_BG_GREEN="${STYLE_ENABLED:+${ECMA48_SGR_BG_GREEN}}"
STYLE_BG_YELLOW="${STYLE_ENABLED:+${ECMA48_SGR_BG_YELLOW}}"
STYLE_BG_BLUE="${STYLE_ENABLED:+${ECMA48_SGR_BG_BLUE}}"
STYLE_BG_MAGENTA="${STYLE_ENABLED:+${ECMA48_SGR_BG_MAGENTA}}"
STYLE_BG_CYAN="${STYLE_ENABLED:+${ECMA48_SGR_BG_CYAN}}"
STYLE_BG_WHITE="${STYLE_ENABLED:+${ECMA48_SGR_BG_WHITE}}"

export STYLE_BG_BLACK
export STYLE_BG_RED
export STYLE_BG_GREEN
export STYLE_BG_YELLOW
export STYLE_BG_BLUE
export STYLE_BG_MAGENTA
export STYLE_BG_CYAN
export STYLE_BG_WHITE

# .............................................................................
# Generate foreground colors with function
#
# For both 8 standard colors and non-standard 256 and RGB colors.

style_fg_8()
{
    echo "${STYLE_ENABLED:+$(ecma48_fg_8 "$1")}"
}

style_fg_256()
{
    echo "${STYLE_ENABLED:+$(ecma48_fg_256 "$1")}"
}

style_fg_rgb()
{
    echo "${STYLE_ENABLED:+$(ecma48_fg_rgb "$1" "$2" "$3")}"
}

style_fg_bright()
{
    echo "${STYLE_ENABLED:+$(ecma48_fg_bright "$1")}"
}

# .............................................................................
# Generate background colors with function
#
# For both 8 standard colors and non-standard 256 and RGB colors.

style_bg_8()
{
    echo "${STYLE_ENABLED:+$(ecma48_bg_8 "$1")}"
}

style_bg_256()
{
    echo "${STYLE_ENABLED:+$(ecma48_bg_256 "$1")}"
}

style_bg_rgb()
{
    echo "${STYLE_ENABLED:+$(ecma48_bg_rgb "$1" "$2" "$3")}"
}

style_bg_bright()
{
    echo "${STYLE_ENABLED:+$(ecma48_bg_bright "$1")}"
}
