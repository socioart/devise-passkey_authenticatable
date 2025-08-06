module Devise
  module Models
    module PasskeyAuthenticatable
      module Passkey
        extend ActiveSupport::Concern

        included do
          scope :order_by_last_used_at, -> { order(last_used_at: :desc, id: :desc) }

          validates :credential_id, presence: true, uniqueness: true
          validates :public_key, presence: true

          serialize :creation_response, coder: JSON

          attr_readonly :credential_id, :public_key, :creation_response

          before_validation do
            self.name = name.to_s.strip.presence || entry_for_aaguid&.[]("name") || "Unknown provider"
          end
        end

        def aaguid
          creation_reseponse_parsed.response.attestation_object.aaguid
        end

        def icon_light
          entry_for_aaguid&.[]("icon_light")
        end

        def sync?
          creation_reseponse_parsed.response.attestation_object.authenticator_data.flags[:backup_eligibility] == 1
        end

        def last_used_user_agent_text
          ua = UserAgent.parse(last_used_user_agent)
          "#{ua.browser} (#{ua.platform})"
        end

        private
        def creation_reseponse_parsed
          WebAuthn::Credential.from_create(creation_response)
        end

        def entry_for_aaguid
          JSON.parse(File.read(Rails.root.join("config", "aaguid.json")))[aaguid]
        end
      end
    end
  end
end
