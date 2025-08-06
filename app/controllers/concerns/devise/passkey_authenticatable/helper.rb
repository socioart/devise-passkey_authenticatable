module Devise
  module PasskeyAuthenticatable
    module Helper
      def prepare_passkey_authentication
        @public_key_credential_request_options = WebAuthn::Credential.options_for_get
        session[:passkey_challenge] = @public_key_credential_request_options.challenge
      end
    end
  end
end
