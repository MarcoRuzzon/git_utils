#!/bin/bash

currentver=$(cmake --version | head -n1 | cut -d' ' -f3)
requiredver="3.10.2"

if [ "$(printf '%s\n' "$requiredver" "$currentver" | sort -V | head -n1)" = "$requiredver" ]; then
        echo "Greater than or equal to ${requiredver}"
else
        echo "Less than ${requiredver}"
fi
