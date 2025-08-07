require "test_helper"

module Devise
  class PasskeyAuthenticatableTest < ActiveSupport::TestCase
    test "it has a version number" do
      assert Devise::PasskeyAuthenticatable::VERSION
    end
  end
end
