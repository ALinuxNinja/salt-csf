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
    - clean: False
    - onchanges_in:
      - cmd: csf_reload
/etc/csf/csfpost.d:
  file.directory:
    - makedirs: True
    - user: root
    - group: root
    - mode: 0755
    - clean: True
    - onchanges_in:
      - cmd: csf_reload
{% if csf.service.csf == True %}
{% for conf, conf_val in csf.config.iteritems() %}
{% if conf == 'main' and conf_val != "" %}
{% for setting, setting_val in conf_val.iteritems() %}
csf_config-{{setting}}:
  file.replace:
    - name: /etc/csf/csf.conf
    - pattern: {{ setting }} \=.*
    - repl: "{{ setting }} = \"{{ setting_val }}\""
    - onchanges_in:
      - cmd: csf_reload
{% endfor %}
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
{% set csfpre_files = salt['file.find']('/etc/csf/csfpre.d',type='f',print='name') %}
{% for csfpre_file in csfpre_files %}
{% if csfpre_file.split('.sh')[0] not in csf.rule.pre %}
csfpre_clean-{{ csfpre_file }}:
  file.absent:
    - name: /etc/csf/csfpre.d/{{csfpre_file}}
{% endif %}
{% endfor %}
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
    - require:
      - file: /etc/csf/csfpre.d
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
    - require:
      - file: /etc/csf/csfpost.d
{% endfor %}
{% endif %}
