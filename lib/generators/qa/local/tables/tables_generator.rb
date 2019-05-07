require 'rails/generators/active_record/migration'
module Qa::Local
  class TablesGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    include ActiveRecord::Generators::Migration

    def migrations # rubocop:disable Metrics/MethodLength
      if defined?(ActiveRecord::ConnectionAdapters::Mysql2Adapter) && ActiveRecord::Base.connection.instance_of?(ActiveRecord::ConnectionAdapters::Mysql2Adapter)
        message = "Use the mysql table based generator if you are using mysql 'rails generate qa:local:tables:mysql'"
        say_status("error", message, :red)
        return 0
      end

      generate "model qa/local_authority name:string:uniq"
      generate "model qa/local_authority_entry local_authority:references label:string uri:string:uniq"

      generate "migration add_index_to_local_authority_entries"
      insert_into_file qa_migration_path('add_index_to_local_authority_entries'), after: 'def change' do
        "\n    add_index :qa_local_authority_entries,\n" \
        "                ['local_authority_id', 'lower(label)'],\n" \
        "                name: 'index_local_authority_entries_on_lower_label',\n" \
        "                unique: true"
      end

      gsub_file qa_migration_path('create_qa_local_authority_entries'),
                /t\.references :local_authority.*/,
                't.references :local_authority, foreign_key: { to_table: :qa_local_authorities }'
    end

    private

      # @param [String] file_name
      # @return [String] path to migration
      def qa_migration_path(file_name)
        migrations_dir = File.join(destination_root, 'db', 'migrate')
        migration_file = Dir.entries(migrations_dir).select do |name|
          name.include?(file_name)
        end.first

        File.join('db/migrate', migration_file)
      end
  end
end
