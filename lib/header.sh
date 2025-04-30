#!/bin/sh

# Headers
# =============================================================================
# Functions for drawing headers.
#
# Copyright (c) 2025
# srvstr

# String inserted as paddding.
HEADER_PADDING_LEFT="="
HEADER_PADDING_RIGHT="="
# Characters encapsulating title.
HEADER_SEP_LEFT="["
HEADER_SEP_RIGHT="]"
# Configuration of padding alignment.
HEADER_ALIGN_LEFT=""
HEADER_ALIGN_RIGHT=""
# Formats
HEADER_TITLE_FORMAT=""
HEADER_LEFT_FORMAT=""
HEADER_RIGHT_FORMAT=""

# Print padded heading.
# All configurable parameter are shown below:
#
# ```
#  padding
#   |       separator-right
#   v             v
# ========[ Hello ]========
#         ^ ~~~~~
#         |   ^----- title
#   separator-left
# ```
#
# Alignment can be controlled with both HEADER_PADDING_LEFT and HEADER_PADDING_RIGHT.
# Any unsigned decimal integer number will make padding fixed on this side
# where the other can expand when given no integer value.
# Examples are given below:
#
# HEADER_PADDING_LEFT="1"
# HEADER_PADDING_RIGHT=""
# ```
# =[ Hello ]===============
# ```
#
# HEADER_PADDING_LEFT=""
# HEADER_PADDING_RIGHT="1"
# ```
# ===============[ Hello ]=
# ```
#
# HEADER_PADDING_LEFT="2"
# HEADER_PADDING_RIGHT="2"
# ```
# ==[ Hello ]==
# ```
# Parameters:
#  - string: title message
heading_line()
(
    # Precompute formatted title.
    title="$HEADER_SEP_LEFT $1 $HEADER_SEP_RIGHT"

    # Regex used for input validation.
    re='^[0-9]+$'

    # Amount of padding on left side.
    if [[ $HEADER_ALIGN_LEFT =~ $re ]]; then
        left="$HEADER_ALIGN_LEFT"
    elif [[ $HEADER_ALIGN_RIGHT =~ $re ]]; then
        left=$(($(tput cols) - ${#title} - $HEADER_ALIGN_RIGHT))
    else
        left=$((($(tput cols) - ${#title}) / 2))
    fi

    printf "$HEADER_LEFT_FORMAT"
    seq $left | sed "s/.*/$HEADER_PADDING_LEFT/" | tr -d '\n'

    # Output title.
    printf "$HEADER_TITLE_FORMAT$title"

    # Amount of padding on right side.
    if [[ $HEADER_ALIGN_RIGHT =~ $re ]]; then
        right="$HEADER_ALIGN_RIGHT"
    elif [[ $HEADER_ALIGN_LEFT =~ $re ]]; then
        right=$(($(tput cols) - ${#title} - $HEADER_ALIGN_LEFT))
    else
        # Round up in integer division.
        # Based on: https://stackoverflow.com/a/2395294
        right=$((($(tput cols) - ${#title} + 1) / 2))
    fi

    printf "$HEADER_RIGHT_FORMAT"
    seq $right | sed "s/.*/$HEADER_PADDING_RIGHT/" | tr -d '\n'

    printf "\n"
)

HEADING_BOX_CORNER_NW="╭"
HEADING_BOX_CORNER_NE="╮"
HEADING_BOX_CORNER_SW="╰"
HEADING_BOX_CORNER_SE="╯"

HEADING_BOX_BORDER_NORTH="─"
HEADING_BOX_BORDER_SOUTH="─"
HEADING_BOX_BORDER_WEST="│"
HEADING_BOX_BORDER_EAST="│"

HEADING_BOX_ALIGN_START=""
HEADING_BOX_ALIGN_END=""

HEADING_PADDING_START="3"
HEADING_PADDING_END="3"

#
# ```
#    ,- align-start
# ~~~~~~
#       +-----------------+
#       |     Heading     |
#       +-----------------+
#       ~~~~~~
#         '- padding
# ```
#
heading_box()
(
    length=$(($HEADING_PADDING_START + ${#1} + $HEADING_PADDING_END))

    # Regex used for input validation.
    re='^[0-9]+$'

    if [[ $HEADING_BOX_ALIGN_START =~ $re ]]; then
        start="$HEADING_BOX_ALIGN_START"
    elif [[ $HEADING_BOX_ALIGN_END =~ $re ]]; then
        start=$(($(tput cols) - $length - 2 - $HEADING_BOX_ALIGN_END))
    else
        start=$((($(tput cols) - $length - 2) / 2))
    fi

    printf "%-${start}s$HEADING_BOX_CORNER_NW"
    seq $length | sed "s/.*/$HEADING_BOX_BORDER_NORTH/" | tr -d '\n'
    printf "$HEADING_BOX_CORNER_NE\n"

    printf "%-${start}s$HEADING_BOX_BORDER_WEST"
    printf "%-${HEADING_PADDING_START}s$1%-${HEADING_PADDING_END}s"
    printf "$HEADING_BOX_BORDER_EAST\n"

    printf "%-${start}s$HEADING_BOX_CORNER_SW"
    seq $length | sed "s/.*/$HEADING_BOX_BORDER_SOUTH/" | tr -d '\n'
    printf "$HEADING_BOX_CORNER_SE\n"
)
