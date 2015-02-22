cnf = data_bag_item("sensu", "config")
master_address = cnf["master_address"] || node["ipaddress"]

if cnf[node.name] && cnf[node.name]["roles"]
  node.override["eol_sensu_wrapper"]["roles"] = cnf[node.name]["roles"]
end

node.override["sensu"]["rabbitmq"]["host"] = master_address
node.override["sensu"]["redis"]["host"] = master_address
node.override["sensu"]["api"]["host"] = master_address

if cnf["uchiva_user"]
  node.override["uchiwa"]["settings"]["user"] = cnf["uchiva_user"]
end

if cnf["uchiva_password"]
  node.override["uchiwa"]["settings"]["password"] =
    cnf["uchiva_password"]
end

if cnf["uchiva_port"]
  node.override["uchiwa"]["settings"]["port"] = cnf["uchiva_port"]
end

sensu_gem "sensu-plugin" do
  version node["eol_sensu_wrapper"]["sensu_plugin_version"]
end
if node["eol_sensu_wrapper"]["roles"].include?("mysql")
  sensu_gem "mysql"
  sensu_gem "inifile"
end

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
  subscriptions node["eol_sensu_wrapper"]["roles"] + ["all"]
end

node["eol_sensu_wrapper"]["plugins"].each do |plugin|
  cookbook_file "/etc/sensu/plugins/#{plugin}" do
    source "plugins/#{plugin}"
    mode 0755
  end
end

include_recipe "sensu::client_service"
