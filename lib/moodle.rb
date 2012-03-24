require 'models/wiki.rb'
require 'models/wiki_entry.rb'
require 'models/wiki_page.rb'

class Moodle
  def initialize(name)
    establish_connection(name)
  end

  def establish_connection(name)
    unless ActiveRecord::Base.connected?
      ActiveRecord::Base.logger = Logger.new(ROOT('log/debug.log'))
      ActiveRecord::Base.configurations = YAML::load(File.read(ROOT('config/database.yml')))
      ActiveRecord::Base.establish_connection(name)

      #mysqldump -h localhost -u campusli_campus -plingua123 campusli_campus > campusli_campus_0205.sql
      #ActiveRecord::Base.establish_connection(
      #  :adapter  => "mysql2",
      #  :host     => "50.116.81.50",
      #  :username => "campusli_campus",
      #  :password => "lingua123",
      #  :database => "campusli_campus"
      #)
    end

    #config = ActiveRecord::Base.configurations[RAILS_ENV].symbolize_keys
    #conn = Mysql2::Client.new(config)
    #conn.query("select * from users").each do |user|
    #  # user should be a hash
    #end
  end

  def conn
    ActiveRecord::Base.connection
  end

  def config
    ActiveRecord::Base.connection_config
  end

  def tables
    conn.execute("show tables").map { |r| r[0] }
  end

  def columns(table_name)
    conn.columns(table_name).map { |r| r.name }
  end

  def drop_tables_by_name(rx_name)
    puts "drop_tables_by_name(#{rx_name})"
    tables.each do |name|
      if name =~ rx_name
        puts "\t#{name}"
        conn.execute("DROP TABLE #{name}")
      end
    end
  end

end
