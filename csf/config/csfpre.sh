#!/bin/bash
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
{%- endif %}
