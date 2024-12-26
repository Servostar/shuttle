#!/bin/bash

echo "Processing file $1"

iter=0
cnt=1

input="$(realpath "$1")"

cd "$(dirname "$1")" || exit 1

until [ -z "$cnt" ]; do
    echo "Revision $iter"
    cnt=0

    match=$(awk '/\. ".*"/{print $0; exit;}' "$input")

    if [ -n "$match" ]; then
        source=$(echo "$match" | awk '{print $2}' | sed 's/"//g')

        echo "Inlining $source"

        escaped_match="${match//\//\\/}"
        escaped_match="${escaped_match//\"/\\\"}"
        escaped_match="${escaped_match//\./\\\.}"

        # Remove shebang from source file to inline.
        sed "/#!.*/d" -i "$source"

        sed -e "/$escaped_match/ {" -e "r $source" -e "d" -e "}" -i "$input"
    else
        break
    fi

    iter=$(("$iter" + 1))
done

# Final cleanup of script.
shfmt -p -s -mn -w "$input"
