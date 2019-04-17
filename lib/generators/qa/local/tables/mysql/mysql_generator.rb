require 'rails/generators/active_record/migration'
module Qa::Local
  module Tables
    class MysqlGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      include ActiveRecord::Generators::Migration

      def migrations # rubocop:disable Metrics/MethodLength
        unless defined?(ActiveRecord::ConnectionAdapters::Mysql2Adapter) && ActiveRecord::Base.connection.instance_of?(ActiveRecord::ConnectionAdapters::Mysql2Adapter)
          message = "Use the table based generator if you are not using mysql 'rails generate qa:local:tables'"
          say_status("error", message, :red)
          return 0
        end

        generate "model qa/local_authority name:string:uniq"
        generate "model qa/local_authority_entry local_authority:references label:string uri:string:uniq lower_label:string"
        generate "qa:local:tables:templates:add_index_to_local_authorities"
        migration_file = Dir.entries(File.join(destination_root, 'db/migrate/'))
                            .reject { |name| !name.include?('create_qa_local_authority_entries') }.first
        migration_file = File.join('db/migrate', migration_file)
        gsub_file migration_file,
                  /t\.references :local_authority.*/,
                  't.references :local_authority, foreign_key: { to_table: :qa_local_authorities }, index: true'
        insert_into_file migration_file, after: "add_index :qa_local_authority_entries, :uri, unique: true" do
          "\n    add_foreign_key :qa_local_authority_entries, :qa_local_authorities, column: :local_authority_id\n" \
          "    if ActiveRecord::Base.connection.instance_of? ActiveRecord::ConnectionAdapters::Mysql2Adapter\n"  \
          "       remove_column :qa_local_authority_entries, :lower_label, :string\n" \
          "       execute(\"alter table qa_local_authority_entries add lower_label varchar(256) GENERATED ALWAYS AS (lower(label)) VIRTUAL\")\n" \
          "    end\n" \
          "    add_index :qa_local_authority_entries, [:lower_label, :local_authority_id], name: 'index_qa_local_authority_entries_on_lower_label_and_authority'"
        end
      end
    end
  end
end
