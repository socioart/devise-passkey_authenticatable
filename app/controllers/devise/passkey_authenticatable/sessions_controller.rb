module Devise
  module PasskeyAuthenticatable
    class SessionsController < Devise::SessionsController
      include Helper

      before_action :prepare_passkey_authentication, only: [:new]
      # Custom behavior for passkey authentication can be added here
    end
  end
end
