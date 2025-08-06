# let(:session) { {foo: 1} } で session をモックできるようにする
module SessionHelper
  class << self
    def included(base)
      base.instance_eval do
        let(:session) { {} }

        before do
          session_double = instance_double(ActionDispatch::Request::Session, id: SecureRandom.hex, enabled?: true, loaded?: false)

          allow(session_double).to receive(:[]) do |key|
            session[key]
          end
          allow(session_double).to receive(:[]=) do |key, value|
            session[key] = value
          end

          allow(session_double).to receive(:delete) do |key|
            session.delete(key)
          end

          allow(session_double).to receive(:clear) do |_key|
            session.clear
          end

          allow(session_double).to receive(:fetch) do |key|
            session.fetch(key)
          end

          allow(session_double).to receive(:key?) do |key|
            session.key?(key)
          end

          allow(session_double).to receive(:empty?) do
            session.empty?
          end

          allow(session_double).to receive(:keys) do
            session.keys
          end

          allow(session_double).to receive(:to_hash) do
            session.to_hash
          end

          allow_any_instance_of(ActionDispatch::Request)
            .to receive(:session).and_return(session_double)

          allow_any_instance_of(Devise::Strategies::PasskeyAuthenticatable)
            .to receive(:session).and_return(session_double)
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include SessionHelper, type: :request
end
