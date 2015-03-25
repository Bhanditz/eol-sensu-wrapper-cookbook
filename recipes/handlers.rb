cnf = data_bag_item("sensu", "handlers")

%w(sysopia ponymailer).each do |h|

  log "Handler: #{h}"

  cookbook_file "/etc/sensu/handlers/#{h}.rb" do
    source "handlers/#{h}.rb"
    mode 0755
  end

  case h
  when "sysopia"
    sensu_snippet h do
      content mysqlini: cnf[h]["mysqlini"]
    end
  when "ponymailer"
    sensu_snippet h do
      content ponymailer: cnf[h]
    end
  end

  sensu_handler h do
    type "pipe"
    command "#{h}.rb"
  end
end
