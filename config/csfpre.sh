#!/bin/bash
####################################################
## csfpre.sh                                      ##
## Part of CSF Firewall                           ##
## File is managed by Salt, do not manually edit. ##
## SLS for CSF Firewall created by ALinuxNinja    ##
####################################################

{%- if csf['firewall']['advanced'] is defined -%}
{%- if csf['firewall']['advanced']['ipv4'] -%}
{%- for rule, rule_opts in csf['firewall']['advanced']['ipv4'].iter() %}
## Rule ID: rule
## Description: {{ rule_opts['desc'] }}
{% for ipt_rule in rule_opts['custom'] %}
/sbin/iptables {{ ipt_rule }}
{%- endfor -%}
{%- endfor -%}
{%- for rule, rule_opts in csf['firewall']['advanced']['ipv6'].iter() %}
## Rule ID: rule
## Description: {{ rule_opts['desc'] }}
{% for ipt_rule in rule_opts['custom'] %}
/sbin/iptables {{ ipt_rule }}
{%- endfor -%}
{%- endfor -%}
{%- endif -%}
{%- endif %}
