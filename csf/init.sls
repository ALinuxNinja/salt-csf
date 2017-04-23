{% from "csf/map.jinja" import csf with context %}
csf_packages:
  pkg.installed:
    - pkgs: {{ csf.packages }}
    - require_in:
      - '*'
csf_install:
  cmd.run:
    - name: wget https://download.configserver.com/csf.tgz && tar xvf csf.tgz && cd csf && bash ./install.sh && rm -rf /tmp/csf.tgz && rm -rf /tmp/csf && /usr/sbin/csf -x
    - cwd: /tmp
    - creates: /etc/csf

