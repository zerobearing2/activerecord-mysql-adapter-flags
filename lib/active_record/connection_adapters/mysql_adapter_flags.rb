module ActiveRecord
  module ConnectionAdapters

    class MysqlAdapter  

      def initialize(connection, logger, connection_options, config)
        super(connection, logger)
        @connection_options, @config = connection_options, config
        @quoted_column_names, @quoted_table_names = {}, {}

        # allow mysql flags to be set in the database.yml
        # development:
        #   adapter: mysql
        #   username: "dbuser"
        #   password: "secert"
        #   host: localhost
        #   database: test
        #   flags: "CLIENT_COMPRESS"
        unless config[:flags].blank?

          # append nil's until we get 7 options
          # real_connect(host,user,password,db,port,socket,flags)
          while(@connection_options.length<7) do; @connection_options << nil; end

          previous_flags = @connection_options[-1].to_i
          flag_strings = config[:flags].split(",").map{|f| f.to_s.strip.upcase}
          flag_vals = flag_strings.collect{|f| Mysql.const_defined?(f) ? Mysql.const_get(f) : nil}.compact
          flags = flag_vals.inject(previous_flags){|val,i| val|i}
          
          @connection_options[-1] = flags
          # puts "MySQL Options: #{@connection_options.inspect}"
        end

        connect
      end

      #------------------
      def session_status
        settings = {}
        execute("show status").each{|x| settings[x[0].to_s.downcase.to_sym] = x[1]}
        settings
      end

    end
  end
end
