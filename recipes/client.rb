include_recipe "sensu::default"

sensu_client node.name do
  subscriptions node["roles"] + ["all"]
end

include_recipe "sensu::client_service"
