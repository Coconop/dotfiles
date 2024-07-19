#!/bin/bash

# (c)  https://stackoverflow.com/a/246128
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

for LINKME in $(find ${SCRIPT_DIR} -type f -name "linkme.sh"); do
    bash ${LINKME}
done
