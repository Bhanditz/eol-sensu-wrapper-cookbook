config = data_bag_item("sensu", "config")
master_address = config["master_address"]
master_node = config["master_name"]
node.override["sensu"]["rabbitmq"]["host"] = master_address
node.override["sensu"]["redis"]["host"] = master_address
node.override["sensu"]["api"]["host"] = master_address

include_recipe "sensu::default"

if node["name"] == master_node
  include_recipe "sensu::rabbitmq"
  include_recipe "sensu::redis"
  include_recipe "sensu::server_service"
  include_recipe "sensu::api_service"
  include_recipe "uchiwa"
end

include_recipe "eol-sensu::client"
