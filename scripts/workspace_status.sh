#!/bin/bash
echo "CURRENT_TIME $(date +%s)"
echo "STABLE_GIT_COMMIT $(git rev-parse HEAD)"
echo "STABLE_USER_NAME $USER"
