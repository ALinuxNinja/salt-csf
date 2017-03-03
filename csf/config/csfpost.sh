#!/usr/bin/env bash
###############################################################################
# csfpost.sh
# Managed by Salt, do not manually edit. Your changes will be lost.
# SLS: csf
# Author: ALinuxNinja ALinuxNinja
# URL: https://github.com/ALinuxNinja/salt-csf
###############################################################################
set -e
# Set traps to catch errors (prevents /etc/csf/status/csfpost from being created)
trap 'echo "csfpost.sh failed";exit $?' 1 2 3 13 15

## Run files in alphabetical order
echo "Running csfpost rules"
if [ -d /etc/csf/csfpost.d ]; then
	for file in $(ls -1 /etc/csf/csfpost.d/ | sort -V); do
		chmod u+x /etc/csf/csfpost.d/${file}
		/etc/csf/csfpost.d/${file}
	done
fi

#Indicate that everything is successfull
touch /etc/csf/status/csfpost
