{% if 'mysql' in grains['roles'] %}
include:
  - .mysql-server
{% endif %}
