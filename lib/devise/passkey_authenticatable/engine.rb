module Devise
  module PasskeyAuthenticatable
    class Engine < ::Rails::Engine
      isolate_namespace Devise::PasskeyAuthenticatable
    end
  end
end
