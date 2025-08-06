require "rails/generators"
require "rails/generators/active_record"

module Devise
  module PasskeyAuthenticatable
    module Generators
      class MigrationGenerator < Rails::Generators::NamedBase
        include Rails::Generators::Migration
        # include Rails::Generators::ResourceHelpers

        source_root File.expand_path("templates", __dir__)
        # hook_for :orm, required: true

        def create_migration_file
          migration_template "migration.rb.erb", "db/migrate/create_#{table_name.singularize}_passkeys.rb"
        end

        def create_model_file
          template "passkey_model.rb.erb", "app/models/#{name}/passkey.rb"
        end

        def self.next_migration_number(_dirname)
          ActiveRecord::Generators::Base.next_migration_number("#{Rails.root}/db/migrate")
        end
      end
    end
  end
end
