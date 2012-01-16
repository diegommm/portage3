#!/usr/bin/env ruby
# encoding: UTF-8
#
# Here should go some comment
#
# Initial Author: Vasyl Zuzyak, 01/11/12
# Latest Modification: Vasyl Zuzyak, 01/11/12
#
$:.push File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
require 'optparse'
require 'rubygems'
require 'sqlite3'
require 'tools'

# hash with options
options = {
    :db_filename => nil,
    :storage => {},
    :quiet => true
}

# lets merge stuff from tools lib
options[:storage].merge!(STORAGE)
# get last created database
options[:db_filename] = get_last_created_database(
    options[:storage][:root],
    options[:storage][:home_folder]
)

OptionParser.new do |opts|
    # help header
    opts.banner = " Usage: purge_s3_data [options]\n"
    opts.separator " A script that purges outdated data from s3 bucket\n"

    opts.on("-f", "--database-file STRING",
            "Path where new database file will be created") do |value|
        # TODO check if path id valid
        options[:db_filename] = value
    end

    # parsing 'quite' option if present
    opts.on("-q", "--quiet", "Quiet mode") do |value|
        options[:quiet] = true
    end

    # parsing 'help' option if present
    opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
    end
end.parse!

portage_home = File.join(
    options[:storage][:root],
    options[:storage][:home_folder],
    options[:storage][:portage_home]
)

begin
    start = Time.now

    db = SQLite3::Database.new(options[:db_filename])
    # array of all inserts
    queries_array = []
    # array of all responsibilities
    [
        'gentoo maintainer',
        'upstream maintainer',
        'proxying maintainer'
    ].each { |resp|
        # create query for responsibility and add it into array
        sql_query = "INSERT INTO roles (role) VALUES ('#{resp}');"
        queries_array << sql_query
    }

    # TODO try/catch
    database.execute_batch(queries_array.join("\n"))

    finish = Time.now

    puts 'Everything is OK!'
    puts start
    puts finish
rescue Exception => msg
    File.delete(options[:db_filename])
    puts msg
ensure
    db.close() if db.closed? == false
end
