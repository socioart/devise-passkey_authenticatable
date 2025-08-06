module Devise
  module PasskeyAuthenticatable
    class Engine < ::Rails::Engine
      # isolate_namespace Devise::PasskeyAuthenticatable

      initializer "devise.passkey_authenticatable" do |_app|
        ActiveSupport.on_load(:after_initialize) do
          Devise::SessionsController.include Devise::PasskeyAuthenticatable::Helper
          Devise::SessionsController.before_action :prepare_passkey_authentication, only: [:new]
        end
      end
    end
  end
end
