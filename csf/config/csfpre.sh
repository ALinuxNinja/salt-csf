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

{%- if csf['firewall'] is defined -%}
{%- if csf['firewall']['ipv4'] is defined and csf['firewall']['ipv4']['rule'] is defined -%}
{%- for rule, rule_opts in csf['firewall']['ipv4']['rule']|dictsort %}
## Rule ID: {{ rule }}
## Description: {{ rule_opts['description'] }}
{% if rule_opts['type'] == 'standard' %}
/sbin/iptables -A {{ rule_opts['direction']|upper }}
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
{{ " -m state --state "}
{%- for state in rule_opts['state'] -%}
{%- if not loop.last -%}
{{ state }},
{%- else -%}
{{ state }}
{% endif %}
{%- endfor -%}
{%- endif -%}
-j {{ rule_opts['action']|upper }}
{% elif rule_opts['type'] == 'custom' %}
{%- for rule in rule_opts['rules'] -%}
/sbin/iptables {{ rule }}
{% endfor -%}
{% elif rule_opts['type'] == 'whitelist' %}
{%- for network in rule_opts['network'] -%}
/sbin/iptables -s {{ network }} -j ACCEPT
{% endfor -%}
{% elif rule_opts['type'] == 'blacklist' %}
{%- for network in rule_opts['network'] -%}
/sbin/iptables -s {{ network }} -j DROP
{% endfor -%}
{% endif -%}
{% endfor -%}
{%- endif -%}
{%- if csf['firewall']['ipv6'] is defined and csf['firewall']['ipv4']['rule'] is defined -%}
{%- for rule, rule_opts in csf['firewall']['ipv6']['rule']|dictsort %}
## Rule ID: {{ rule }}
## Description: {{ rule_opts['description'] }}

{% endfor -%}
{%- endif -%}
{%- endif %}