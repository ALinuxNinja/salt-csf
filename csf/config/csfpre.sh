#!/bin/bash
##############################################################
## csfpre.sh                                                ##
## CSF Firewall (http://configserver.com/cp/csf.html)       ##
##############################################################
## Configuration managed by SaltStack, do NOT manually edit ##
##############################################################
## SLS: csf (https://github.com/ALinuxNinja/salt-csf)       ##
## Author: ALinuxNinja (https://github.com/ALinuxNinja)     ##
##############################################################
{% if csf['firewall'] is defined -%}
{%- if csf['firewall']['rule'] is defined -%}
{%- for rule, rule_opts in csf['firewall']['rule']|dictsort %}
{%- if rule_opts['ip_version'] is defined -%}
{%- if rule_opts['ip_version'] == "ipv4" -%}
{%- set iptables_cmd = "/sbin/iptables" -%}
{%- elif rule_opts['ip_version'] == 'ipv6' -%}
{%- set iptables_cmd = "/sbin/ip6tables" -%}
{%- else -%}
{%- set iptables_cmd = "/sbin/iptables" -%}
{%- endif -%}
{%- else -%}
{%- set iptables_cmd = "/sbin/iptables" -%}
{%- endif -%}
## Rule ID: {{ rule }}
## Description: {{ rule_opts['description'] }}
{% if rule_opts['type'] == 'standard' -%}
{{ iptables_cmd }} -A {{ rule_opts['direction']|upper }}
{%- if rule_opts['protocol'] is defined -%}
{{ " -p "+rule_opts['protocol'] }}
{%- endif -%}
{%- if rule_opts['interface'] is defined -%}
{%- if rule_opts['interface']['incoming'] is defined -%}
{{ " -i "+rule_opts['interface']['incoming'] }}
{%- endif -%}
{%- if rule_opts['interface']['outgoing'] is defined -%}
{{ " -o "+rule_opts['interface']['outgoing'] }}
{%- endif -%}
{%- endif -%}
{%- if rule_opts['destination'] is defined -%}
{%- if rule_opts['destination']['networks'] is defined -%}
{{ " -d " }}
{%- for network in rule_opts['destination']['networks'] -%}
{%- if not loop.last -%}
{{ network+"," }}
{%- else -%}
{{ network }}
{%- endif -%}
{%- endfor -%}
{%- endif -%}
{%- if rule_opts['destination']['ports'] is defined -%}
{{ " -m multiport --dports " }}
{%- for port in rule_opts['destination']['ports'] -%}
{%- if not loop.last -%}
{{ port+"," }}
{%- else -%}
{{ port }}
{%- endif -%}
{%- endfor -%}
{%- endif -%}
{%- endif -%}
{%- if rule_opts['source'] is defined -%}
{%- if rule_opts['source']['networks'] is defined -%}
{{ " -s " }}
{%- for network in rule_opts['source']['networks'] -%}
{%- if not loop.last -%}
{{ network+"," }}
{%- else -%}
{{ network }}
{%- endif -%}
{%- endfor -%}
{%- endif -%}
{%- if rule_opts['source']['ports'] is defined -%}
{{ " -m multiport --sports " }}
{%- for port in rule_opts['source']['ports'] -%}
{%- if not loop.last -%}
{{ port+"," }}
{%- else -%}
{{ port }}
{%- endif -%}
{%- endfor -%}
{%- endif -%}
{%- endif -%}
{%- if rule_opts['state'] is defined -%}
{{ " -m state --state " }}
{%- for state in rule_opts['state'] -%}
{%- if not loop.last -%}
{{ state }},
{%- else -%}
{{ state }}
{% endif %}
{%- endfor -%}
{%- endif -%}
{{ " -j "+rule_opts['action']|upper }}
{% elif rule_opts['type'] == 'custom' -%}
{%- for rule in rule_opts['rules'] -%}
{{ iptables_cmd }} {{ rule }}
{% endfor -%}
{% elif rule_opts['type'] == 'whitelist' -%}
{%- for network in rule_opts['network'] -%}
{{ iptables_cmd }} -A INPUT -s {{ network }} -j ACCEPT
{{ iptables_cmd }} -A OUTPUT -d {{ network }} -j ACCEPT
{{ iptables_cmd }} -A FORWARD -s {{ network }} -j ACCEPT
{% endfor -%}
{% elif rule_opts['type'] == 'blacklist' -%}
{%- for network in rule_opts['network'] -%}
{{ iptables_cmd }} -A INPUT -s {{ network }} -j DROP
{{ iptables_cmd }} -A OUTPUT -d {{ network }} -j DROP
{{ iptables_cmd }} -A FORWARD -s {{ network }} -j DROP
{% endfor -%}
{% endif -%}
{% endfor -%}
{%- endif -%}
{%- endif %}
