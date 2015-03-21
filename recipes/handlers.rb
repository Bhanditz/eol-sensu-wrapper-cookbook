cnf = data_bag_item("sensu", "handlers")

%w(sysopia).each do |h|
  cookbook_file "/etc/sensu/handlers/#{h}.rb" do
    source "handlers/#{h}.rb"
    mode 0755
  end

  sensu_snippet h do
    content mysqlini: cnf[h]["mysqlini"]
  end

  sensu_handler h do
    type "pipe"
    command "#{h}.rb"
  end
end
