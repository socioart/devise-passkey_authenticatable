module Devise
  module Models
    module PasskeyAuthenticatable
      extend ActiveSupport::Concern

      included do
        attr_readonly :passkey_user_id
        before_validation do
          self.passkey_user_id ||= WebAuthn.generate_user_id
        end
      end

      module ClassMethods
        def authenticate_by_passkey(request_response, passkey_challenge, request, now)
          webauthn_credential = WebAuthn::Credential.from_get(request_response)
          stored_credential = const_get(:Passkey).find_by(credential_id: webauthn_credential.id)
          return nil unless stored_credential

          begin
            webauthn_credential.verify(
              passkey_challenge,
              public_key: stored_credential.public_key,
              sign_count: stored_credential.sign_count,
            )

            stored_credential.update!(
              sign_count: webauthn_credential.sign_count,
              last_used_at: now,
              last_used_ip: request.remote_ip,
              last_used_user_agent: request.user_agent,
            )
            stored_credential.send(name.underscore)
          rescue WebAuthn::Error => e
            Devise::PasskeyAuthenticatable.log_webauthn_error(e, request_response, passkey_challenge)
            nil
          end
        end
      end

      def passkey_options_for_create
        WebAuthn::Credential.options_for_create(
          # challenge 生成される
          # rp は initializers/webauthn.rb で設定
          user: {
            id: passkey_user_id,
            name: email,
            display_name: email,
          },
          # pubKeyCredParams 生成される
          exclude_credentials: passkeys.map {|passkey| {id: passkey.credential_id, type: "public-key"} },
          authenticator_selection: {
            require_resident_key: true,
          },
          # timeout デフォルトで 120,000
        )
      end

      def create_passkey_by_creation_response(creation_response, passkey_challenge, request, now)
        # PublicKeyCredentialWithAttestation
        webauthn_credential = WebAuthn::Credential.from_create(creation_response)

        begin
          # チャレンジ、オリジン、RP ID の検証が行われる
          # 署名はないので検証されない
          # ユーザー存在テスト、ローカルユーザー検証結果の検証は行わない
          webauthn_credential.verify(passkey_challenge)
          passkeys.create!(
            credential_id: webauthn_credential.id,
            public_key: webauthn_credential.public_key,
            sign_count: webauthn_credential.sign_count,
            creation_response: creation_response,
            last_used_at: now,
            last_used_ip: request.remote_ip,
            last_used_user_agent: request.user_agent,
          )
        rescue WebAuthn::Error => e
          Devise::PasskeyAuthenticatable.log_webauthn_error(e, creation_response, passkey_challenge)
          nil
        end
      end
    end
  end
end
