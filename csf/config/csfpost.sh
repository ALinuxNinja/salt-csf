#!/usr/bin/env bash
###############################################################################
# csfpre.sh
# Managed by Salt, do not manually edit. Your changes will be lost.
# SLS: csf
# Author: ALinuxNinja ALinuxNinja <dev@alinux.ninja>
# URL: https://github.com/ALinuxNinja/salt-csf
###############################################################################
set -e
set -o errtrace
trap 'exit $?' ERR

## Source files in alphabetical order
echo "Running csfpre rules"
if [ -d /etc/csf/csfpre.d ]; then
	for file in $(ls -1 /etc/csf/csfpost.d/ | sort -V); do
		/etc/csf/csfpre.d/${file}
	done
fi

#Indicate that everything is successfull
touch /etc/csf/status/csfpost
