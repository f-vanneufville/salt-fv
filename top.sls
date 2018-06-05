base:
  '*':
    - helloworld
  'G@roles:webserver and G@kernel:Linux':
    - match: compound
    - linux.webserver
  'G@roles:dbserver and G@kernel:linux':
    - linux.dbserver
