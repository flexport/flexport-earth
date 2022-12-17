#!/bin/sh

set -o nounset

cypress run --browser chrome --config video=false

echo "Cypress run for build $CYPRESS_BUILD_NUMBER completed!"
