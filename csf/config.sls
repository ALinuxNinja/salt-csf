{% from "csf/map.jinja" import csf with context %}

include:
  - csf
{% if csf['service']['csf'] == True %}
{% for conf, conf_val in csf['config'].iteritems() %}
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
{% if csf['rule'] is defined and csf['rule'] %}
{% if csf['rule']['pre'] is defined and csf['rule']['pre'] %}
/etc/csf/csfpre.sh:
  file.managed:
    - source: salt://csf/config/csfpre.sh
    - mode: 755
    - template: jinja
    - context:
      rule: {{ csf['rule']['pre'] }}
    - watch_in:
      - cmd: csf_reload
{% elif csf['rule']['post'] is defined and csf['rule']['post'] %}
/etc/csf/csfpost.sh:
  file.managed:
    - source: salt://csf/config/csfpost.sh
    - mode: 755
    - template: jinja
    - context:
      rule: {{ csf['rule']['post'] }}
    - watch_in:
      - cmd: csf_reload
{% endif %}
{% endif %}
{% endif %}
