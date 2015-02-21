cnf = data_bag_item("sensu", "config")
master_address = cnf["master_address"] || node["ipaddress"]
node.override["sensu"]["roles"] = (cnf[node.name] && cnf[node.name]["roles"]) || []
node.override["sensu"]["rabbitmq"]["host"] = master_address
node.override["sensu"]["redis"]["host"] = master_address
node.override["sensu"]["api"]["host"] = master_address

include_recipe "sensu::default"

if node["ipaddress"] == master_address
  include_recipe "sensu::rabbitmq"
  include_recipe "sensu::redis"
  
  sensu_checks = data_bag("sensu_checks").map do |item| 
    data_bag_item("sensu_checks", item)
  end

  sensu_checks.each do |check|
    sensu_check check["id"] do
      type check["type"]
      command check["command"]
      subscribers check["subscribers"]
      interval check["interval"]
      handlers check["handlers"]
      additional check["additional"]
    end
  end

  include_recipe "sensu::server_service"
  include_recipe "sensu::api_service"
  include_recipe "uchiwa"
end

sensu_client node.name do
  address node["ipaddress"]
  subscriptions node["sensu"]["roles"] + ["all"]
end

%w[check-disk.rb
   check-load.rb
   check-mem-pcnt.sh
   mysql-replication-status.rb
].each do |default_plugin|
  cookbook_file "/etc/sensu/plugins/#{default_plugin}" do
    source "plugins/#{default_plugin}"
    mode 0755
  end
end

include_recipe "sensu::client_service"
