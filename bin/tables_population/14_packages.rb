#!/usr/bin/env ruby
# encoding: UTF-8
#
# Here should go some comment
#
# Initial Author: Vasyl Zuzyak, 01/16/12
# Latest Modification: Vasyl Zuzyak, ...
#
lib_path_items = [File.dirname(__FILE__), '..', '..', 'lib']
$:.push File.expand_path(File.join(*(lib_path_items + ['common'])))
$:.push File.expand_path(File.join(*(lib_path_items + ['portage'])))
require 'script'
require 'package'

def process(params)
    PLogger.info("Package: #{params["value"]}")
    package = Package.new(params)

    Database.insert({
        "table" => params["table"],
        "data" => {
            "category_id" => package.category_id(),
            "package_name" => package.package()
        }
    })
end

script = Script.new({
    "script" => __FILE__,
    "table" => "packages",
    "thread_code" => method(:process),
    "data_source" => Package.method(:get_packages)
})

