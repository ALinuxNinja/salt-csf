#!/usr/bin/env bash
###############################################################################
# {{role}}.sh
# Managed by Salt, do not manually edit. Your changes will be lost.
# SLS: csf
# Author: ALinuxNinja <dev@alinux.ninja>
# URL: https://github.com/ALinuxNinja/salt-csf
###############################################################################
{% for rule in role_opts -%}
{{ rule }}
{% endfor -%}
