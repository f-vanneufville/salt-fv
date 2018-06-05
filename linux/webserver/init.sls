{% if 'apache' in grains['roles'] %}
include:
  - .apache
{% endif %}
