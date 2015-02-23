override["sensu"]["use_embedded_ruby"] = true
override["sensu"]["version"] = "0.16.0-1"
override['uchiwa']['version'] = '0.4.0-1'

default["eol_sensu_wrapper"]["roles"] = []
default["eol_sensu_wrapper"]["sensu_plugin_version"] = "1.1.0"
default["eol_sensu_wrapper"]["plugins"] = %w(
  check-disk.rb
  check-http.rb
  check-load.rb
  check-mem-pcnt.sh
  check-mysql-alive.rb
  check-mysql-replication.rb
  metrics-system.rb
)
