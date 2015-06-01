require 'yaml'
require 'erb'
require 'active_record'

# database
configurations = YAML.load(ERB.new(open("#{__dir__}/database.yml").read).result)

db = ENV['DATABASE_ADAPTER'] || 'sqlite3'
raise "No configuration for '#{db}'" unless configurations.has_key?(db)

ActiveRecord::Base.configurations = { 'test' => configurations[db] }
ActiveRecord::Base.establish_connection(:test)

# models
class User < ActiveRecord::Base; end

class CreateUserTable < ActiveRecord::Migration
  def self.up
    create_table(:users) {|t| t.string :first_name }
  end

  def self.down
    drop_table :users
  end
end
ActiveRecord::Migration.verbose = false

# config
app = Class.new(Rails::Application)
app.config.secret_token = '3b7cd727ee24e8444053437c36cc66c4'
app.config.session_store :cookie_store, :key => '_myapp_session'
app.config.active_support.deprecation = :log
app.config.eager_load = false

# Rais.root
app.config.root = File.dirname(__FILE__)
Rails.backtrace_cleaner.remove_silencers!
app.initialize!

# helpers
Object.const_set(:ApplicationHelper, Module.new)
