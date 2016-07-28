{% from "csf/map.jinja" import csf with context %}
csf_install:
  cmd.run:
    - name: wget http://www.configserver.com/free/csf.tgz && tar xvf csf.tgz && cd csf && bash ./install.sh && rm -rf /tmp/csf.tgz && rm -rf /tmp/csf
    - cwd: /tmp
    - creates: /etc/csf

csf_packages:
  pkg.installed:
    - pkgs: {{ csf['packages'] }}
    - require_in:
      - '*'
csf_service:
{% if csf['service']['csf'] == True %}
  service.running:
    - name: csf
    - enable: True
  cmd.run:
    - name: csf -e
csf_reload:
  cmd.wait:
    - name: csf -r
{% else %}
  service.dead:
    - name: csf
    - enable: False
  cmd.run:
    - name: csf -x
{% endif %}
lfd_service:
{% if csf['service']['lfd'] == True %}
  service.running:
    - name: lfd
    - enable: True
{% else %}
  service.dead:
    - name: lfd
    - enable: False
{% endif %}
{% for conf, conf_val in csf['config'].iteritems() %}
{% if conf == 'main' %}
csf_config:
  augeas.change:
    - lens: simplevars.lns
    - context: /files/etc/csf/csf.conf
    - changes:
{% for setting, setting_val in conf_val.iteritems() %}
      - set {{ setting }} '"{{ setting_val }}"'
{% endfor %}
    - watch_in:
      - cmd: csf_reload
{% else %}
csf_config-{{conf}}:
  file.managed:
    - name: /etc/csf/csf.{{conf}}
    - source: salt://csf/config/csf.{{conf}}
    - mode: 644
    - template: jinja
    - context:
      conf: {{ conf_val }}
    - watch_in:
      - cmd: csf_reload
{% endif %}
{% endfor %}
{% if csf['rule'] is defined and csf['rule'] %}
{% if csf['rule']['pre'] is defined and csf['rule']['pre'] %}
csf_rule-pre:
  file.managed:
    - name: /etc/csf/csfpre.sh
    - source: salt://csf/config/csfpre.sh
    - mode: 755
    - template: jinja
    - context:
      rule: {{ csf['rule']['pre'] }}
    - watch_in:
      - cmd: csf_reload
{% elif csf['rule']['post'] is defined and csf['rule']['post'] %}
csf_rule-post:
  file.managed:
    - name: /etc/csf/csfpost.sh
    - source: salt://csf/config/csfpost.sh
    - mode: 755
    - template: jinja
    - context:
      rule: {{ csf['rule']['post'] }}
    - watch_in:
      - cmd: csf_reload
{% endif %}
{% endif %}
