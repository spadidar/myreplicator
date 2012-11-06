module Myreplicator
  module SqlCommands
    
    def self.mysqldump *args
      options = args.extract_options!
      options.reverse_merge! :flags => []
      db = options[:db]

      flags = ""

      self.dump_flags.each_pair do |flag, value|
        if options[:flags].include? flag
          flags += " --#{flag} "
        elsif value
          flags += " --#{flag} "
        end
      end
      cmd = Myreplicator::Configuration.mysqldump
      cmd += "#{flags} -u#{db_configs(db)["username"]} -p#{db_configs(db)["password"]} " 
      cmd += "-h#{db_configs(db)["host"]} -P#{db_configs(db)["port"]} "
      cmd += "result-file=#{options[:filepath]} "

      puts cmd
      return cmd
    end

    def self.db_configs db
      ActiveRecord::Base.configurations[Rails.env][db]
    end
    
    def self.dump_flags
      {"add-locks" => true,
        "compact" => false,
        "lock-tables" => false,
        "no-create-db" => true,
        "no-data" => false,
        "quick" => true,
        "skip-add-drop-table" => true,
        "create-options" => false,
        "single-transaction" => false
      }
    end

    def self.mysql_export *args
      options = args.extract_options!
      options.reverse_merge! :flags => []
      db = options[:db]

      flags = ""

      self.mysql_flags.each_pair do |flag, value|
        if options[:flags].include? flag
          flags += " --#{flag} "
        elsif value
          flags += " --#{flag} "
        end
      end

      cmd = Myreplicator::Configuration.mysql
      cmd += "#{flags} -u#{db_configs(db)["username"]} -p#{db_configs(db)["password"]} " 
      cmd += "-h#{db_configs(db)["host"]} -P#{db_configs(db)["port"]} "
      cmd += "--execute=\"#{options[:sql]}\" "
      cmd += "--tee=#{options[:filepath]} "
      
      puts cmd
      return cmd
    end

    def self.mysql_flags
      {"column-names" => false,
        "quick" => true,
        "reconnect" => true
      }    
    end

    def self.mysql_export_outfile

    end

  end
end
