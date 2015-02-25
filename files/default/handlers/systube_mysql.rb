#!/opt/sensu/embedded/bin/ruby

require 'sensu-handler'
require 'json'
require 'mysql'
require 'inifile'

class SysTubeMysql < Sensu::Handler
  # override filters from Sensu::Handler. not appropriate for metric handlers
  def filter; end

  def handle
    # mysql settings
    mysql_ini = settings['systube']['mysql_ini']
    ini = IniFile.load(mysql_ini)
    section = ini['client']
    db_user = section['user']
    db_pass = section['password']
    db_host = section['database']
    
    open("/tmp/systube", 'w') do |f|
      f.write(@event)
    end
    # # event values
    # client_id = @event['client']['name']
    # check_name = @event['check']['name']
    # check_issued = @event['check']['issued']
    # check_output = @event['check']['output']
    # check_status = @event['check']['status']
    #
    # begin
    #   con = Mysql.new mysql_hostname, mysql_username, mysql_password
    #   con.query("INSERT INTO "\
    #             "sensumetrics.sensu_historic_metrics("\
    #             "client_id, check_name, issue_time, "\
    #             "output, status) "\
    #             "VALUES ('#{client_id}', '#{check_name}', "\
    #             "#{check_issued}, '#{check_output}', #{check_status})")
    # rescue Mysql::Error => e
    #   puts e.errno
    #   puts e.error
    # ensure
    #   con.close if con
    # end
  end
end
