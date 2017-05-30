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
    - clean: True
/etc/csf/csfpost.d:
  file.directory:
    - makedirs: True
    - user: root
    - group: root
    - mode: 0755
    - clean: True
{% if csf.service.csf == True %}
{% for conf, conf_val in csf.config.iteritems() %}
{% if conf == 'main' %}
/etc/csf/csf.conf:
  augeas.change:
    - lens: simplevars.lns
    - context: /files/etc/csf/csf.conf
    - changes:
{% for setting, setting_val in conf_val.iteritems() %}
      - set {{ setting }} "{{ setting_val }}"
{% endfor %}
    - onchanges_in:
      - cmd: csf_reload
{% else %}
/etc/csf/csf.{{conf}}:
  file.managed:
    - source: salt://csf/config/csf.standardconf
    - mode: 0644
    - template: jinja
    - context:
      conf: {{ conf_val }}
      conf_name: {{ conf }}
    - onchanges_in:
      - cmd: csf_reload
{% endif %}
{% endfor %}
/etc/csf/csfpre.sh:
  file.managed:
    - source: salt://csf/config/csfpre.sh
    - mode: 0755
    - user: root
    - group: root
    - onchanges_in:
      - cmd: csf_reload
{% for role,role_opts in csf.rule.pre.iteritems() %}
/etc/csf/csfpre.d/{{role}}.sh:
  file.managed:
    - source: salt://csf/config/csf_role_rule.sh
    - mode: 0755
    - user: root
    - group: root
    - template: jinja
    - context:
      role: {{role}}
      role_opts: {{role_opts}}
    - onchanges_in:
      - cmd: csf_reload
{% endfor %}
/etc/csf/csfpost.sh:
  file.managed:
    - source: salt://csf/config/csfpost.sh
    - mode: 0755
    - user: root
    - group: root
    - onchanges_in:
      - cmd: csf_reload
{% for role,role_opts in csf.rule.post.iteritems() %}
/etc/csf/csfpost.d/{{role}}.sh:
  file.managed:
    - source: salt://csf/config/csf_role_rule.sh
    - mode: 0755
    - user: root
    - group: root
    - template: jinja
    - context:
      role: {{role}}
      role_opts: {{role_opts}}
    - onchanges_in:
      - cmd: csf_reload
{% endfor %}
{% endif %}
