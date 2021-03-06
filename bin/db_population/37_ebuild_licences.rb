#!/usr/bin/env ruby
# encoding: UTF-8
#
# Here should go some comment
#
# Initial Author: Vasyl Zuzyak, 04/20/12
# Latest Modification: Vasyl Zuzyak, ...
#
require_relative 'envsetup'
require 'ebuild'

class Script
    def pre_insert_task()
        sql_query = 'select name, id from licences;'
        @shared_data['licences@id'] = Hash[Database.select(sql_query)]
    end

    def process(params)
        PLogger.info("Ebuild: #{params[3, 3].join('-')}")
        ebuild = Ebuild.new(Ebuild.generate_ebuild_params(params))

        ebuild.ebuild_licences.split.each { |licence|
            licence_id = @shared_data['licences@id'][licence]
            Database.add_data4insert(ebuild.ebuild_id, licence_id)
        }
    end
end

script = Script.new({
    'data_source' => Ebuild.method(:get_ebuilds),
    'sql_query' => <<-SQL
        INSERT INTO ebuilds_licences
        (ebuild_id, licence_id)
        VALUES (?, ?);
    SQL
})

