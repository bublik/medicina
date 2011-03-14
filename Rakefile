# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'
namespace :fixtures do
    desc 'Create YAML test fixtures for references. Defaults to development database.
    Set RAILS_ENV to override.'
    task :dump_references => :environment do
      sql = "SELECT * FROM %s"
      dump_tables = ['post_translations']
      ActiveRecord::Base.establish_connection(:development)
      dump_tables.each do |table_name|
        i = "000"
        file_name = "#{RAILS_ROOT}/test/fixtures/#{table_name}.yml"
        p "Fixture save for table #{table_name} to #{file_name}"
        File.open(file_name, 'w') do |file|
          data = ActiveRecord::Base.connection.select_all(sql % table_name)
          file.write data.inject({}) { |hash, record|
            hash["#{table_name}_#{i.succ!}"] = record
            hash
          }.ya2yaml
        end
      end
    end
  end