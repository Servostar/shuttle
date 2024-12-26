#!/bin/sh

# Escape codes
# =============================================================================
# Special control sequences used for styling text or additional utilities like
# a terminal bell as defined by ECMA-48/ISO 6429/ANSI X3.64.
# This implementation is based on the fifth edition of ECMA-48 in 1991.
#
# .............................................................................
# References:
#
#  - https://ecma-international.org/publications-and-standards/standards/ecma-48
#  - https://chrisyeh96.github.io/2020/03/28/terminal-colors.html
#
# Copyright (c) 2024
# srvstr

# Non printable escape character in hexadecimal.
ECMA48_ESC="\x1b"
# Control sequence inducer prefixing parameters.
ECMA48_CSI="${ECMA48_ESC}["

# Compose a custom escape sequence.
# Parameters:
#  - string: escape sequence
ecma48_sgr()
{
    # Wanted behavior here.
    # shellcheck disable=SC2059
    printf "${ECMA48_CSI}${1}m"
}

# Select Graphic Rendition (SGR)
# -----------------------------------------------------------------------------
# Controls sequences used to modify how the terminal renders characters.

ECMA48_SGR_RESET="$(ecma48_sgr 0)"       # Reset all previously configured SGRs.
ECMA48_SGR_BOLD="$(ecma48_sgr 1)"        # Render text with increased intensity.
ECMA48_SGR_FAINT="$(ecma48_sgr 2)"       # Render text with decreased intensity.
ECMA48_SGR_ITALIC="$(ecma48_sgr 3)"      # Render text as italic.
ECMA48_SGR_UNDERLNE="$(ecma48_sgr 4)"    # Render text with a single underline.
ECMA48_SGR_BLINK_SLOW="$(ecma48_sgr 5)"  # Render text by slowly blinking.
ECMA48_SGR_BLINK_RAPID="$(ecma48_sgr 6)" # Render text by rapid blinking.

# Export symbols
export ECMA48_SGR_RESET
export ECMA48_SGR_BOLD
export ECMA48_SGR_FAINT
export ECMA48_SGR_ITALIC
export ECMA48_SGR_UNDERLNE
export ECMA48_SGR_BLINK_SLOW
export ECMA48_SGR_BLINK_RAPID

# 8 standard colors defined by their names.
# .............................................................................

# 8 standard foreground colors mapped by color name.
# Note that these may be changed by a terminal color scheme.
ECMA48_SGR_FG_BLACK="$(ecma48_sgr 30)"
ECMA48_SGR_FG_RED="$(ecma48_sgr 31)"
ECMA48_SGR_FG_GREEN="$(ecma48_sgr 32)"
ECMA48_SGR_FG_YELLOW="$(ecma48_sgr 33)"
ECMA48_SGR_FG_BLUE="$(ecma48_sgr 34)"
ECMA48_SGR_FG_MAGENTA="$(ecma48_sgr 35)"
ECMA48_SGR_FG_CYAN="$(ecma48_sgr 36)"
ECMA48_SGR_FG_WHITE="$(ecma48_sgr 37)"

# Export symbols
export ECMA48_SGR_FG_BLACK
export ECMA48_SGR_FG_RED
export ECMA48_SGR_FG_GREEN
export ECMA48_SGR_FG_YELLOW
export ECMA48_SGR_FG_BLUE
export ECMA48_SGR_FG_MAGENTA
export ECMA48_SGR_FG_CYAN
export ECMA48_SGR_FG_WHITE

# 8 standard background colors mapped by color name.
# Note that these may be changed by a terminal color scheme.
ECMA48_SGR_BG_BLACK="$(ecma48_sgr 40)"
ECMA48_SGR_BG_RED="$(ecma48_sgr 41)"
ECMA48_SGR_BG_GREEN="$(ecma48_sgr 42)"
ECMA48_SGR_BG_YELLOW="$(ecma48_sgr 43)"
ECMA48_SGR_BG_BLUE="$(ecma48_sgr 44)"
ECMA48_SGR_BG_MAGENTA="$(ecma48_sgr 45)"
ECMA48_SGR_BG_CYAN="$(ecma48_sgr 46)"
ECMA48_SGR_BG_WHITE="$(ecma48_sgr 47)"

# Export symbols
export ECMA48_SGR_BG_BLACK
export ECMA48_SGR_BG_RED
export ECMA48_SGR_BG_GREEN
export ECMA48_SGR_BG_YELLOW
export ECMA48_SGR_BG_BLUE
export ECMA48_SGR_BG_MAGENTA
export ECMA48_SGR_BG_CYAN
export ECMA48_SGR_BG_WHITE

# .............................................................................
# Generate foreground colors with function
#
# For both 8 standard colors and non-standard 256 and RGB colors.

# Compose escape sequence for standard 8 foreground colors.
# Parameters:
#  - number: integer between 0 and 7
ecma48_fg_8()
{
    echo "${ECMA48_CSI}3${1}m"
}

# Compose escape sequence for non standard 256 foreground colors.
# Parameters:
#  - number: integer between 0 and 255
ecma48_fg_256()
{
    echo "${ECMA48_CSI}38;5;${1}m"
}

# Compose escape sequence for non standard red-green-blue (RGB) foreground
# colors.
# Parameters:
#  - red channel: integer between 0 and 255
#  - green channel: integer between 0 and 255
#  - blue channel: integer between 0 and 255
ecma48_fg_rgb()
{
    echo "${ECMA48_CSI}38;2;${1};${2};${3}m"
}

# Compose escape sequence for non standard 8 bright foreground colors.
# Parameters:
#  - number: integer between 0 and 255
ecma48_fg_bright()
{
    echo "${ECMA48_CSI}9${1}m"
}

# .............................................................................
# Generate background colors with function
#
# For both 8 standard colors and non-standard 256 and RGB colors.

# Compose escape sequence for standard 8 background colors.
# Parameters:
#  - number: integer between 0 and 7
ecma48_bg_8()
{
    echo "${ECMA48_CSI}4${1}m"
}

# Compose escape sequence for non standard 256 background colors.
# Parameters:
#  - number: integer between 0 and 255
ecma48_bg_256()
{
    echo "${ECMA48_CSI}48;5;${1}m"
}

# Compose escape sequence for non standard red-green-blue (RGB) background
# colors.
# Parameters:
#  - red channel: integer between 0 and 255
#  - green channel: integer between 0 and 255
#  - blue channel: integer between 0 and 255
ecma48_bg_rgb()
{
    echo "${ECMA48_CSI}48;2;${1};${2};${3}m"
}

# Compose escape sequence for non standard 8 bright background colors.
# Parameters:
#  - number: integer between 0 and 7
ecma48_bg_bright()
{
    echo "${ECMA48_CSI}10${1}m"
}

# Make an educated guess whether or not escape sequences are supported in the
# current sessions.
#
# Based on: https://github.com/keqingrong/supports-ansi
ecma48_supports_ansi()
{
    # Check if running in a terminal
    if ! (tty -s); then
        return 1
    fi

    # Clear positional parameters.
    set --
    # Append regular expressions matching terminals supporting escape sequences.
    set -- "$@" '^xterm'                            # xterm, PuTTY, Mintty, Kitty
    set -- "$@" '^rxvt'                             # RXVT
    set -- "$@" '^eterm'                            # Eterm
    set -- "$@" '^screen'                           # GNU screen, tmux
    set -- "$@" '^tmux'                             # tmux
    set -- "$@" '^vt100' '^vt102' '^vt220' '^vt320' # DEC VT series
    set -- "$@" 'ansi'                              # ANSI
    set -- "$@" 'scoansi'                           # SCO ANSI
    set -- "$@" 'cygwin'                            # Cygwin, MinGW
    set -- "$@" 'linux'                             # Linux console
    set -- "$@" 'konsole'                           # Konsole
    set -- "$@" 'bvterm'                            # Bitvise SSH Client
    set -- "$@" 'alacritty'                         # Alacritty

    # Match any of the above regular expressions.
    for rexp in "$@"; do
        if echo "${TERM}" | grep -qiE "${rexp}"; then
            return 0
        fi
    done

    return 1
}
