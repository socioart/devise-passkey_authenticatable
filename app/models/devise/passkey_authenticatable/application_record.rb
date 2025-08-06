module Devise
  module PasskeyAuthenticatable
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
