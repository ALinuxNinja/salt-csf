{% from "csf/map.jinja" import csf with context %}
csf_install:
  cmd.run:
    - name: wget http://www.configserver.com/free/csf.tgz && tar xvf csf.tgz && cd csf && bash ./install.sh && rm -rf /tmp/csf.tgz && rm -rf /tmp/csf
    - cwd: /tmp
    - creates: /etc/csf

csf:
  pkg.installed:
    - pkgs: {{ csf['packages'] }}
    - require_in:
      - '*'
{% if csf['enable'] == True %}
  service.running:
    - enable: True
    - watch:
      - augeas: csf_config
      - file: /etc/csf/csfpre.sh
      - file: /etc/csf/csfpost.sh
{% else %}
  service.dead:
    - enable: False
{% endif %}
lfd:
{% if csf['lfd']['enable'] == True %}
  service.running:
    - enable: True
{% else %}
  service.dead:
    - enable: False
{% endif %}
{# CSF Option Configuration #}
csf_config:
  augeas.change:
    - lens: simplevars.lns
    - context: /files/etc/csf/csf.conf
    - changes:
{% if csf['testing']['enabled'] == False %}
      - set TESTING '"0"'
{% elif csf['testing']['enabled'] == True %} %}
      - set TESTING '"1"'
{% endif %}
      - set TESTING_INTERVAL '"{{ csf['testing']['interval'] }}"'
      - set RESTRICT_SYSLOG '"{{ csf['syslog']['restrict'] }}"'
      - set RESTRICT_SYSLOG_GROUP '"{{ csf['syslog']['group'] }}"'
{% if csf['autoupdate'] == False %}
      - set AUTO_UPDATES '"0"'
{% elif csf['autoupdate'] == True %}
      - set AUTO_UPDATES '"1"'
{% endif %}
{% if csf['firewall']['conntrack'] == True %}
      - set USE_CONNTRACK '"1"'
{% elif csf['firewall']['conntrack'] == False %}
      - set USE_CONNTRACK '"0"'
{% endif %}
{% if csf['firewall']['faststart'] == False %}
      - set FASTSTART '"0"'
{% elif csf['firewall']['faststart'] == True %}
      - set FASTSTART '"1"'
{% endif %}
{% if csf['firewall']['drop_invalid'] == False %}
      - set PACKET_FILTER '"0"'
{% elif csf['firewall']['drop_invalid'] == True %}
      - set PACKET_FILTER '"1"'
{% endif %}
      - set ETH_DEVICE '"{{ csf['firewall']['interface']['filter_on']['ipv4_interface'] }}"'
      - set ETH6_DEVICE '"{{ csf['firewall']['interface']['filter_on']['ipv6_interface'] }}"'
      - set ETH_DEVICE_SKIP '"
{%- if csf['firewall']['interface']['skip'] -%}
{%- for interface in csf['firewall']['interface']['skip'] -%}
{%- if not loop.last -%}
{{ interface }},
{%- else -%}
{{ interface }}
{%- endif -%}
{%- endfor -%}
{%- endif -%}"'
{% if csf['firewall']['ipv4']['icmp']['in']['allowed'] == False %}
      - set ICMP_IN '"0"'
{% elif csf['firewall']['ipv4']['icmp']['in']['allowed'] == True %}
      - set ICMP_IN '"1"'
{% endif %}
      - set ICMP_IN_RATE '"{{ csf['firewall']['ipv4']['icmp']['in']['rate-limit'] }}"'
{% if csf['firewall']['ipv4']['icmp']['out']['allowed'] == False %}
      - set ICMP_OUT '"0"'
{% elif csf['firewall']['ipv4']['icmp']['out']['allowed'] == True %}
      - set ICMP_OUT '"1"'
{% endif %}
      - set ICMP_OUT_RATE '"{{ csf['firewall']['ipv4']['icmp']['out']['rate-limit'] }}"'
{% if csf['firewall']['ipv4']['spi'] == True %}
      - set LF_SPI '"1"'
{% elif csf['firewall']['ipv4']['spi'] == False %}
      - set LF_SPI '"0"'
{% endif %}
      - set TCP_IN '"
{%- if csf['firewall']['ipv4']['tcp']['in'] -%}
{%- for port in csf['firewall']['ipv4']['tcp']['in'] -%}
{%- if not loop.last -%}
{{ port }},
{%- else -%}
{{ port }}
{%- endif -%}
{%- endfor -%}
{%- endif -%}"'
      - set TCP_OUT '"
{%- if csf['firewall']['ipv4']['tcp']['out'] -%}
{%- for port in csf['firewall']['ipv4']['tcp']['out'] -%}
{%- if not loop.last -%}
{{ port }},
{%- else -%}
{{ port }}
{%- endif -%}
{%- endfor -%}
{%- endif -%}"'
      - set UDP_IN '"
{%- if csf['firewall']['ipv4']['udp']['in'] -%}
{%- for port in csf['firewall']['ipv4']['udp']['in'] -%}
{%- if not loop.last -%}
{{ port }},
{%- else -%}
{{ port }}
{%- endif -%}
{%- endfor -%}
{%- endif -%}"'
      - set UDP_OUT '"
{%- if csf['firewall']['ipv4']['udp']['out'] -%}
{%- for port in csf['firewall']['ipv4']['udp']['out'] -%}
{%- if not loop.last -%}
{{ port }},
{%- else -%}
{{ port }}
{%- endif -%}
{%- endfor -%}
{%- endif -%}"'
{% if csf['firewall']['ipv6']['enabled'] == True %}
      - set IPV6 '"1"'
{% elif csf['firewall']['ipv6']['enabled'] == False %}
      - set IPV6 '"0"'
{% endif %}
{% if csf['firewall']['ipv6']['strict'] == True %}
      - set IPV6_ICMP_STRICT '"1"'
{% elif csf['firewall']['ipv6']['strict'] == False %}
      - set IPV6_ICMP_STRICT '"0"'
{% endif %}
{% if csf['firewall']['ipv6']['spi'] == True %}
      - set IPV6_SPI '"1"'
{% elif csf['firewall']['ipv6']['spi'] == False %}
      - set IPV6_SPI '"0"'
{% endif %}
      - set TCP6_IN '"
{%- if csf['firewall']['ipv6']['tcp']['in'] -%}
{%- for port in csf['firewall']['ipv6']['tcp']['in'] -%}
{%- if not loop.last -%}
{{ port }},
{%- else -%}
{{ port }}
{%- endif -%}
{%- endfor -%}
{%- endif -%}"'
      - set TCP6_OUT '"
{%- if csf['firewall']['ipv6']['tcp']['out'] -%}
{%- for port in csf['firewall']['ipv6']['tcp']['out'] -%}
{%- if not loop.last -%}
{{ port }},
{%- else -%}
{{ port }}
{%- endif -%}
{%- endfor -%}
{%- endif -%}"'
      - set UDP6_IN '"
{%- if csf['firewall']['ipv6']['udp']['in'] -%}
{%- for port in csf['firewall']['ipv6']['udp']['in'] -%}
{%- if not loop.last -%}
{{ port }},
{%- else -%}
{{ port }}
{%- endif -%}
{%- endfor -%}
{%- endif -%}"'
      - set UDP6_OUT '"
{%- if csf['firewall']['ipv6']['udp']['out'] -%}
{%- for port in csf['firewall']['ipv6']['udp']['out'] -%}
{%- if not loop.last -%}
{{ port }},
{%- else -%}
{{ port }}
{%- endif -%}
{%- endfor -%}
{%- endif -%}"'

{# Additional Firewall Rules #}
csf_csfpre:
  file.managed:
    - source: salt://csf/config/csfpre.sh
    - name: /etc/csf/csfpre.sh
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
      csf: {{ csf }}
csf_csfpost:
  file.managed:
    - source: salt://csf/config/csfpost.sh
    - name: /etc/csf/csfpost.sh
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
      csf: {{ csf }}
csf_csfredirect:
  file.managed:
    - source: salt://csf/config/csf.redirect
    - name: /etc/csf/csf.redirect
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
      csf: {{ csf }}
