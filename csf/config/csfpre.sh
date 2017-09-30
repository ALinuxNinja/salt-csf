#!/usr/bin/env bash
###############################################################################
# csfpre.sh
# Managed by Salt, do not manually edit. Your changes will be lost.
# SLS: csf
# Author: ALinuxNinja ALinuxNinja
# URL: https://github.com/ALinuxNinja/salt-csf
###############################################################################
set -e
# Clear status files
rm /etc/csf/status/*
# Set traps to catch errors (prevents /etc/csf/status/csfpre from being created)
trap 'echo "csfpre.sh failed";exit $?' 1 2 3 13 15

## Runs files in alphabetical order
echo "Running csfpre rules"
if [ -d /etc/csf/csfpre.d ]; then
	for file in $(ls -1 /etc/csf/csfpre.d/ | sort -V); do
		chmod u+x /etc/csf/csfpre.d/${file}
		/etc/csf/csfpre.d/${file}
	done
fi

## Completed successfully
touch /etc/csf/status/csfpre
