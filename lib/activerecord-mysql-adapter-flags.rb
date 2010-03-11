$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
dir = Pathname(__FILE__).dirname.expand_path

# include the original (MySQL Adapter) first
require 'active_record/connection_adapters/mysql_adapter'

# Require our internal libraries
require dir.join('active_record/connection_adapters/mysql_adapter_flags')
