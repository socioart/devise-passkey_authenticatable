module Devise
  module PasskeyAuthenticatable
    module Generators
      class ViewsGenerator < Rails::Generators::Base
        source_root File.expand_path("../../../../../app/views", __dir__)
        # argument :scope, required: true, desc: "The scope to create controllers in, e.g. users, admins"

        def copy_views
          directory "devise/passkeys", "app/views/devise/passkeys"
        end
      end
    end
  end
end
