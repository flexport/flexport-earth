#!/bin/sh

set -o nounset


echo "Starting Xvfb..."

/usr/bin/Xvfb :99 -screen 0 "${CYPRESS_VIEWPORT_WIDTH}x${CYPRESS_VIEWPORT_HEIGHT}x24+32" &
export DISPLAY=:99

echo "Xvfb started on port 99!"

cypress run --browser chrome --config video=false

echo "Cypress run for build $CYPRESS_BUILD_NUMBER completed!"
