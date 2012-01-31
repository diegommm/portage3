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
require 'fileutils'

# hash with options
options = Hash.new.merge!(OPTIONS)
# atom prefix matcher
RESTRICTION = Regexp.new("^[^\\w]+")
SQL_QUERY = "INSERT INTO restriction_types (restriction) VALUES (?)"

OptionParser.new do |opts|
    # help header
    opts.banner = " Usage: purge_s3_data [options]\n"
    opts.separator " A script that purges outdated data from s3 bucket\n"

    opts.on("-f", "--database-file STRING",
            "Path where new database file will be created") do |value|
        # TODO check if path id valid
        options[:db_filename] = value
    end

    #TODO do we need a setting `:root` option here?
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

# get true portage home
portage_home = get_full_tree_path(options)
if options[:db_filename].nil?
    # get last created database
    options[:db_filename] = get_last_created_database(options)
end

def fill_table(params)
    filepath = File.join(params[:portage_home], "profiles")
    FileUtils.cd(filepath)
    restrictions = []

    # walk through all use flags in that file
    Dir['**/package.mask'].each do |file|
        # lets get filename
        filepath = File.join(params[:portage_home], "profiles", file)

        File.open(filepath, "r") do |infile|
            while (line = infile.gets)
                # skip comments
                next if line.index('#') == 0
                # skip empty lines
                next if line.chomp!().empty?

                restriction = RESTRICTION.match(line)
                restrictions << restriction.to_s unless restriction.nil?
            end
        end
    end

    # '-' means unmask this atom
    # '~' means musk all 'subversions' of this atom
    restrictions.map { |restriction|
        restriction.sub!('-', '')
        restriction.sub!('~', '')
    }

    restrictions.uniq.sort.each { |restriction|
        params[:database].execute(
            SQL_QUERY,
            restriction
        ) unless restriction.empty?
    }

    # TODO now '<=' is not present tree
end

fill_table_X(
    options[:db_filename],
    method(:fill_table),
    {:portage_home => portage_home}
)