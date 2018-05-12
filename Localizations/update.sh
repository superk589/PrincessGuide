#!/usr/bin/env bash
set -e

$(dirname "$0")/export.sh
$(dirname "$0")/import.sh
$(dirname "$0")/export.sh # re-export to update the XLIFF files
