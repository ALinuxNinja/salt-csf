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
{% for conf, conf_val in csf['host'][grains['id']].iteritems() %}
{% if conf == 'conf' %}
csf_config:
  augeas.change:
    - lens: simplevars.lns
    - context: /files/etc/csf/csf.conf
    - changes:
{% for setting, setting_val in conf_val.iteritems() %}
      - set {{ setting }} '"{{ setting_val }}"'
{% endfor %}
{% elif conf == 'rule' %}
{# Make csfpre rules here #}
{% else %}
csf_config-{{conf}}:
  file.managed:
    - name: /etc/csf/csf.{{conf}}
    - source: salt://csf/config/csf.{{conf}}
    - mode: 644
    - template: jinja
    - context:
      conf: {{ conf_val }}
{% endif %}
{% endfor %}
