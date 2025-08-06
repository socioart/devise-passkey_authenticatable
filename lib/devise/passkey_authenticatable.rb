require "devise/passkey_authenticatable/version"
require "devise/passkey_authenticatable/engine"

require "webauthn"
require "useragent"

module Devise
  module PasskeyAuthenticatable
    module_function
    def log_webauthn_error(error, params, challenge)
      Rails.logger.info({type: "webauthn_error", message: error.message, params:, challenge:, time: Time.now.to_f}.to_json)
    end

    def update_aaguid_list
      json = OpenURI.open_uri("https://github.com/passkeydeveloper/passkey-authenticator-aaguids/raw/refs/heads/main/aaguid.json", &:read)
      File.write(Rails.root.join("config", "aaguid.json"), json)
    end
  end
end

require "devise/strategies/passkey_authenticatable"

ActionDispatch::Routing::Mapper.include(Module.new {
  def devise_passkeys(mapping, controllers)
    resources :passkeys, path: mapping.path_names[:passkeys], controller: controllers[:passkeys], only: %i(index create edit update destroy)
  end
})

Warden::Strategies.add(:passkey_authenticatable, Devise::Strategies::PasskeyAuthenticatable) # ストラテジーの登録
Devise.add_module(:passkey_authenticatable, strategy: true, model: true, route: {passkeys: [:index, :create, :edit, :update, :destroy]}) # モジュールの登録

require "devise/models/passkey_authenticatable/passkey"
