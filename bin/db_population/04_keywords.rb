#!/usr/bin/env ruby
# encoding: UTF-8
#
# Here should go some comment
#
# Initial Author: Vasyl Zuzyak, 01/15/12
# Latest Modification: Vasyl Zuzyak, ...
#
require 'envsetup'
require 'script'

# TODO symbols
KEYWORDS = ['not work', 'not known', 'unstable', 'stable']

def get_data(params)
    return KEYWORDS
end

def process(params)
    Database.add_data4insert(params['value'])
end

script = Script.new({
    'data_source' => method(:get_data),
    'thread_code' => method(:process),
    'sql_query' => 'INSERT INTO keywords (keyword) VALUES (?);'
})

