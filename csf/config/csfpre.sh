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
{% if rule['groups'] is defined and rule['groups'] -%}
## Group Rules
{%- for group in rule['groups'] %}
### Group: {{group}}
{%- for rule in pillar['csf']['rule'][group] %}
{{ rule }}
{%- endfor %}
{%- endfor -%}
{%- endif %}
{% if rule['contents'] is defined and rule['contents'] -%}
## Manual Rules
{%- for rule in rule['contents'] %}
{{ rule }}
{%- endfor %}
{%- endif %}
