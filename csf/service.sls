{% from "csf/map.jinja" import csf with context %}

include:
  - csf

csf_service:
{% if csf.service.csf == True %}
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
{% if csf.service.lfd == True %}
  service.running:
    - name: lfd
    - enable: True
{% else %}
  service.dead:
    - name: lfd
    - enable: False
{% endif %}
