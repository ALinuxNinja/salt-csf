{% from "csf/map.jinja" import csf with context %}

include:
  - csf
  - csf.service
/etc/csf/csfpre.d:
  file.directory:
    - makedirs: True
    - user: root
    - group: root
    - mode: 0755
/etc/csf/csfpost.d:
  file.directory:
    - makedirs: True
    - user: root
    - group: root
    - mode: 0755
{% if csf.service.csf == True %}
{% for conf, conf_val in csf.config.iteritems() %}
{% if conf == 'main' %}
/etc/csf/csf.conf:
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
/etc/csf/csf.{{conf}}:
  file.managed:
    - source: salt://csf/config/csf.{{conf}}
    - mode: 644
    - template: jinja
    - context:
      conf: {{ conf_val }}
    - watch_in:
      - cmd: csf_reload
{% endif %}
{% endfor %}
/etc/csf/csfpre.sh:
  file.managed:
    - source: salt://csf/config/csfpre.sh
    - mode: 755
    - template: jinja
    - context:
      {% if csf.rule is defined and csf.rule and csf.rule.pre is defined %}
      rule: {{ csf.rule.pre }}
      {% endif %}
      csf: {{ csf }}
    - watch_in:
      - cmd: csf_reload
/etc/csf/csfpost.sh:
  file.managed:
    - source: salt://csf/config/csfpost.sh
    - mode: 755
    - template: jinja
    - context:
      {% if csf.rule is defined and csf.rule and  csf.rule.post is defined %}
      rule: {{ csf.rule.post }}
      {% endif %}
      csf: {{ csf }}
    - watch_in:
      - cmd: csf_reload
{% endif %}
