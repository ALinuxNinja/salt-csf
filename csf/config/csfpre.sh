#!/bin/bash
############################################################# 
## csfpre.sh                                               ##
## CSF Firewall (http://configserver.com/cp/csf.html)      ##
#############################################################
## Configuration managed by SaltStack, do NOT manually edit #
#############################################################
## SLS: csf (https://github.com/ALinuxNinja/salt-csf)      ##
## Author: ALinuxNinja (https://github.com/ALinuxNinja)    ##
#############################################################

{%- if csf['firewall']['advanced'] is defined -%}
{%- if csf['firewall']['advanced']['ipv4'] and csf['firewall']['advanced']['ipv4']['rule'] is defined and csf['firewall']['advanced']['ipv4']['rule'] -%}
{%- for rule, rule_opts in csf['firewall']['advanced']['ipv4']['rule']|dictsort %}
## Rule ID: {{ rule }}
## Description: {{ rule_opts['desc'] }}
{% for ipt_rule in rule_opts['custom'] %}
/sbin/iptables {{ ipt_rule }}
{%- endfor -%}
{%- endfor -%}
{%- if csf['firewall']['advanced']['ipv6'] and csf['firewall']['advanced']['ipv6']['rule'] is defined and csf['firewall']['advanced']['ipv6']['rule']-%}
{%- for rule, rule_opts in csf['firewall']['advanced']['ipv6']['rule']|dictsort %}
## Rule ID: {{ rule }}
## Description: {{ rule_opts['desc'] }}
{% for ipt_rule in rule_opts['custom'] %}
/sbin/ip6tables {{ ipt_rule }}
{%- endfor -%}
{%- endfor -%}
{%- endif -%}
{%- endif -%}
{%- endif %}
