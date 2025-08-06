module Devise
  module PasskeyAuthenticatable
    module Generators
      class ControllerGenerator < Rails::Generators::Base
        source_root File.expand_path("templates", __dir__)
        argument :scope, required: true, desc: "The scope to create controllers in, e.g. users, admins"

        def create_controller
          @scope_prefix = scope.blank? ? "" : "#{scope.camelize}::"
          template "passkeys_controller.rb.erb", "app/controllers/#{scope}/passkeys_controller.rb"
        end
      end
    end
  end
end
