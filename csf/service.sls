{% from "csf/map.jinja" import csf with context %}
include:
  - csf
/etc/csf/status:
  file.directory:
    - user: root
    - group: root
    - mode: 0755
    - clean: False
csf_service:
{% if csf.service.csf == True %}
  service.running:
    - name: csf
    - enable: True
{% if grains['csf_enabled'] is not defined or (grains['csf_enabled'] is defined and grains['csf_enabled']) != True %}
  cmd.run:
    - name: csf -e
    - require_in:
        - module: csf_service
  module.run:
    - name: grains.setval
    - key: csf_enabled
    - val: True
{% endif %}
csf_reload:
  cmd.run:
    - name: csf -r
    - creates:
      - /etc/csf/status/csfpost
      - /etc/csf/status/csfpre
{% else %}
  service.dead:
    - name: csf
    - enable: False
{% if grains['csf_enabled'] is not defined or (grains['csf_enabled'] is defined and grains['csf_enabled'] != False) %}
  cmd.run:
    - name: csf -x
    - require_in:
        - module: csf_service
  module.run:
    - name: grains.setval
    - key: csf_enabled
    - val: False
{% endif %}
{% endif %}
lfd_service:
{% if csf.service.lfd == True %}
  service.running:
    - name: lfd
    - enable: True
{% else %}
  service.dead:
    - name: lfd
    - enable: False
{% endif %}
