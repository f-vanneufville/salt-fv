{% from "linux/dbserver/mysql-server.map.jinja" import mysql with context %}

Installation packages MySQL:
  pkg.installed:
    - names:
{% for pkg in mysql.pkgs %}
      - {{ pkg }}
{% endfor %}


{% set repls = [
    { 'port': mysql.port },
    { 'datadir': mysql.data },
    { 'socket': mysql.data + "/mysql.sock" }
  ] %}

{% for repl in repls %}
{% for key,value in repl.items() %}

Configuration service MySQL ({{ key }}):
  file.replace:
    - name: {{ mysql.cfg }}
    - pattern: ^{{ key }}[ ]*=.*
    - repl: {{ key }} = {{ value }}
    - append_if_not_found: True
    - not_found_content: {{ key }} = {{ value }}
    - require:
      - pkg: Installation packages MySQL
{% endfor %}
{% endfor %}

{#
Suppression base de test MySQL:
  mysql_database.absent:
    - name: test
    - require:
      -service: {{ mysql.svc }}
#}

Ouverture {{ mysql.port }} sur firewalld:
  firewalld.present:
    - name: public
    - ports:
      - {{ mysql.port }}/tcp
    - prune_services: False
    - require:
      - pkg: Installation packages MySQL

Demarrage service MySQL:
  service.running:
    - name: {{ mysql.svc }}
    - enable: True
    - watch:
      - pkg: Installation packages MySQL
