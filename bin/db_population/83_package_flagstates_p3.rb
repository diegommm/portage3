#!/usr/bin/env ruby
# encoding: UTF-8
#
# Here should go some comment
#
# Initial Author: Vasyl Zuzyak, 01/22/12
# Latest Modification: Vasyl Zuzyak, ...
#
require_relative 'envsetup'
require 'useflag'

def get_data(params)
    sql_query = <<-SQL
        SELECT ip.id, c.name, p.name, e.version
        FROM installed_packages ip
        JOIN ebuilds e ON e.id = ip.ebuild_id
        JOIN packages p ON e.package_id = p.id
        JOIN categories c ON p.category_id = c.id;
    SQL

    Database.select(sql_query)
end

class Script
    def pre_insert_task
        sql_query = 'select state, id from flag_states;'
        @shared_data['state@id'] = Hash[Database.select(sql_query)]
    end

    def process(param)
        path = '/var/db/pkg'
        dir = File.join(path, param[1], param[2] + '-' + param[3])
        iebuild_id = param[0]

        unless File.exist?(use_file = File.join(dir, 'USE'))
            PLogger.info("USE file does not exist for '#{dir}'")
            next
        end

        IO.read(use_file).split.each do |flag|
            flag_name = UseFlag.get_flag(flag)
            flag_state = UseFlag.get_flag_state(flag)
            flag_state_id = @shared_data['state@id'][flag_state]
            Database.add_data4insert(iebuild_id, flag_name, flag_state_id)
        end
    end
end

script = Script.new({
    'data_source' => method(:get_data),
    'sql_query' => <<-SQL
        INSERT INTO package_flagstates
        (iebuild_id, flag_id, state_id)
        VALUES (
            ?,
            (
                SELECT id
                FROM flags
                WHERE name=?
                ORDER BY type_id ASC
                LIMIT 1
            ),
            ?
        );
    SQL
})

