#!/usr/bin/env bash
set -e
###############################################################################
# Managed by Salt, do not manually edit. Your changes will be lost.
# SLS: csf
# Author: ALinuxNinja
# URL: https://github.com/ALinuxNinja/salt-csf
###############################################################################
# Copyright 2006-2016, Way to the Web Limited
# URL: http://www.configserver.com
# Email: sales@waytotheweb.com
###############################################################################
{%- if rule is defined -%}
{% if rule['rulesets'] is defined and rule['rulesets'] -%}
## Ruleset Rules
{%- for ruleset in rule['rulesets'] %}
### Ruleset: {{ruleset}}
{%- for rule in pillar['csf']['ruleset'][ruleset] %}
{{ rule }}
{%- endfor %}
{%- endfor -%}
{%- endif %}
{% if rule['customrules'] is defined and rule['customrules'] -%}
## Manual Rules
{%- for rule in rule['customrules'] %}
{{ rule }}
{%- endfor %}
{%- endif -%}
{%- endif %}

## Source files in alphabetical order
echo "Running additional csfpre.d scripts"
if [ -d /etc/csf/csfpre.d ]; then
	for file in $(ls -1 /etc/csf/csfpre.d/ | sort -V); do
		/etc/csf/csfpre.d/${file}
	done
fi
trap 'exit $?' ERR
