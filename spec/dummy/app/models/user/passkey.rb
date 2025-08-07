class User
  class Passkey < ApplicationRecord
    include Devise::Models::PasskeyAuthenticatable::Passkey

    belongs_to :user
  end
end
