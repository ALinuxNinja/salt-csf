#!/usr/bin/env bash
###############################################################################
# csfpre.sh
# Managed by Salt, do not manually edit. Your changes will be lost.
# SLS: csf
# Author: ALinuxNinja
# URL: https://github.com/ALinuxNinja/salt-csf
set -e
set -o errtrace
trap 'exit $?' ERR

## Source files in alphabetical order
echo "Running csfpre rules"
if [ -d /etc/csf/csfpre.d ]; then
	for file in $(ls -1 /etc/csf/csfpre.d/ | sort -V); do
		/etc/csf/csfpre.d/${file}
	done
fi

## Completed successfully
touch /etc/csf/status/csfpre
