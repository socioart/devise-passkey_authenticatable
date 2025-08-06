require "rails_helper"

RSpec.describe "Devise Sessions", type: :request do
  describe "POST /users/sign_in" do
    let(:user) { create(:user) }
    let!(:passkey) {
      create(
        :user_passkey,
        user: user,
        credential_id: "CG5nqXSF_aSpcw2k8v710XLg_0a5i0_KXQrdfHwKuuwBHmr-",
        public_key: "pQECAyYgASFYIKXHCv4KxJmLVC5anLC5_gFKf-CmnS6hoxfjszgXcFh3Ilgg0511hT2TZgV-zWlXVG1E9lhlPG0vlk24NELzuIhOgsE",
        creation_response: {
          "type" => "public-key",
          "id" => "CG5nqXSF_aSpcw2k8v710XLg_0a5i0_KXQrdfHwKuuwBHmr-",
          "rawId" => "CG5nqXSF_aSpcw2k8v710XLg_0a5i0_KXQrdfHwKuuwBHmr-",
          "authenticatorAttachment" => "platform",
          "response" => {
            "clientDataJSON" => "eyJ0eXBlIjoid2ViYXV0aG4uY3JlYXRlIiwiY2hhbGxlbmdlIjoicTRzZnhRX3hDNkxLYlA2cDZNelVGNjFVSGhFVHA0cUVxZzVGcHA4SFFfNCIsIm9yaWdpbiI6Imh0dHA6Ly9sb2NhbGhvc3Q6MzAwMCIsImNyb3NzT3JpZ2luIjpmYWxzZX0",
            "attestationObject" => "o2NmbXRkbm9uZWdhdHRTdG10oGhhdXRoRGF0YVioSZYN5YgOjGh0NBcPZHZgW4_krrmihjLHmVzzuoMdl2NdAAAAALraVWanqkAfvZZFYZpVEg0AJAhuZ6l0hf2kqXMNpPL-9dFy4P9GuYtPyl0K3Xx8CrrsAR5q_qUBAgMmIAEhWCClxwr-CsSZi1QuWpywuf4BSn_gpp0uoaMX47M4F3BYdyJYINOddYU9k2YFfs1pV1RtRPZYZTxtL5ZNuDRC87iIToLB",
            "transports" => %w(internal hybrid),
          },
          "clientExtensionResults" => {"credProps" => nil},
          "controller" => "devise/passkeys",
          "action" => "create",
          "passkey" => {
            "type" => "public-key",
            "id" => "CG5nqXSF_aSpcw2k8v710XLg_0a5i0_KXQrdfHwKuuwBHmr-",
            "rawId" => "CG5nqXSF_aSpcw2k8v710XLg_0a5i0_KXQrdfHwKuuwBHmr-",
            "authenticatorAttachment" => "platform",
            "response" => {
              "clientDataJSON" => "eyJ0eXBlIjoid2ViYXV0aG4uY3JlYXRlIiwiY2hhbGxlbmdlIjoicTRzZnhRX3hDNkxLYlA2cDZNelVGNjFVSGhFVHA0cUVxZzVGcHA4SFFfNCIsIm9yaWdpbiI6Imh0dHA6Ly9sb2NhbGhvc3Q6MzAwMCIsImNyb3NzT3JpZ2luIjpmYWxzZX0",
              "attestationObject" => "o2NmbXRkbm9uZWdhdHRTdG10oGhhdXRoRGF0YVioSZYN5YgOjGh0NBcPZHZgW4_krrmihjLHmVzzuoMdl2NdAAAAALraVWanqkAfvZZFYZpVEg0AJAhuZ6l0hf2kqXMNpPL-9dFy4P9GuYtPyl0K3Xx8CrrsAR5q_qUBAgMmIAEhWCClxwr-CsSZi1QuWpywuf4BSn_gpp0uoaMX47M4F3BYdyJYINOddYU9k2YFfs1pV1RtRPZYZTxtL5ZNuDRC87iIToLB",
              "transports" => %w(internal hybrid),
            },
            "clientExtensionResults" => {"credProps" => nil},
          },
        },
      )
    }
    let(:challenge) { "tzE5kzE2isKvl7eeRapFdugPOSe3I1AxwNKmaQ6-hvY" }
    let(:credential) {
      {
        "type" => "public-key",
        "id" => "CG5nqXSF_aSpcw2k8v710XLg_0a5i0_KXQrdfHwKuuwBHmr-",
        "rawId" => "CG5nqXSF_aSpcw2k8v710XLg_0a5i0_KXQrdfHwKuuwBHmr-",
        "authenticatorAttachment" => "platform",
        "response" => {
          "clientDataJSON" => "eyJ0eXBlIjoid2ViYXV0aG4uZ2V0IiwiY2hhbGxlbmdlIjoidHpFNWt6RTJpc0t2bDdlZVJhcEZkdWdQT1NlM0kxQXh3TkttYVE2LWh2WSIsIm9yaWdpbiI6Imh0dHA6Ly9sb2NhbGhvc3Q6MzAwMCIsImNyb3NzT3JpZ2luIjpmYWxzZX0",
          "authenticatorData" => "SZYN5YgOjGh0NBcPZHZgW4_krrmihjLHmVzzuoMdl2MdAAAAAA",
          "signature" => "MEUCIEvOo01ymB7RbrOgOy_Kk2sm0r0bdNns-rAla7g2jES0AiEAyIUuNSRBkDS-nkvKjU1vtcgEd0gtNBfvPC2wmHT3m30",
          "userHandle" => "J97BhB3wguDf9Q4SLhdWFGMZUfx0ty2FeoSD0PIDQa4ZGrY4jgRDizX1twJxeKSAonowzlJ4FnaaegByO2Cbig",
        },
        "clientExtensionResults" => {"credProps" => nil},
        "controller" => "devise/passkeys",
        "action" => "authenticate",
        "passkey" => {
          "type" => "public-key",
          "id" => "CG5nqXSF_aSpcw2k8v710XLg_0a5i0_KXQrdfHwKuuwBHmr-",
          "rawId" => "CG5nqXSF_aSpcw2k8v710XLg_0a5i0_KXQrdfHwKuuwBHmr-",
          "authenticatorAttachment" => "platform",
          "response" => {
            "clientDataJSON" => "eyJ0eXBlIjoid2ViYXV0aG4uZ2V0IiwiY2hhbGxlbmdlIjoidHpFNWt6RTJpc0t2bDdlZVJhcEZkdWdQT1NlM0kxQXh3TkttYVE2LWh2WSIsIm9yaWdpbiI6Imh0dHA6Ly9sb2NhbGhvc3Q6MzAwMCIsImNyb3NzT3JpZ2luIjpmYWxzZX0",
            "authenticatorData" => "SZYN5YgOjGh0NBcPZHZgW4_krrmihjLHmVzzuoMdl2MdAAAAAA",
            "signature" => "MEUCIEvOo01ymB7RbrOgOy_Kk2sm0r0bdNns-rAla7g2jES0AiEAyIUuNSRBkDS-nkvKjU1vtcgEd0gtNBfvPC2wmHT3m30",
            "userHandle" => "J97BhB3wguDf9Q4SLhdWFGMZUfx0ty2FeoSD0PIDQa4ZGrY4jgRDizX1twJxeKSAonowzlJ4FnaaegByO2Cbig",
          },
          "clientExtensionResults" => {"credProps" => nil},
        },
      }
    }
    let(:params) { {credential_json: credential.to_json} }
    let(:session) { {passkey_challenge: challenge} }

    it "サインイン成功" do
      expect_any_instance_of(Devise::SessionsController).to receive(:sign_in).with(:user, user).and_call_original
      post user_session_path, params: params

      expect(response).to redirect_to root_path
    end

    context "clientDataJSON の内容が変わっていたら" do
      let(:credential) {
        credential = super()
        client_data = JSON.parse(Base64.urlsafe_decode64(credential["response"]["clientDataJSON"]))
        client_data["foo"] = "bar"
        credential["response"]["clientDataJSON"] = Base64.urlsafe_encode64(client_data.to_json)
        credential
      }
      it "署名検証エラー" do
        expect_any_instance_of(Devise::SessionsController).not_to receive(:sign_in)
        expect(Devise::PasskeyAuthenticatable).to receive(:log_webauthn_error).with(an_instance_of(WebAuthn::SignatureVerificationError), any_args).and_call_original

        post user_session_path, params: params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template("devise/sessions/new")
      end
    end

    # challenge の検証
    # CSRF 対策
    context "clientDataJSON に含まれる challenge が一致しなければ" do
      let(:challenge) { "Mty0XB19FNxKluGW8SbOiJVD39RKMyPW6yNOABTlxXc" }
      it "challange 検証エラー" do
        expect_any_instance_of(Devise::SessionsController).not_to receive(:sign_in)
        expect(Devise::PasskeyAuthenticatable).to receive(:log_webauthn_error).with(an_instance_of(WebAuthn::ChallengeVerificationError), any_args).and_call_original

        post user_session_path, params: params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template("devise/sessions/new")
      end
    end

    it "clientDataJSON に含まれる origin が allowed_origins に含まれていなかったら失敗" do
      expect_any_instance_of(Devise::SessionsController).not_to receive(:sign_in)
      expect(WebAuthn.configuration.relying_party).to receive(:allowed_origins).and_return(["http://another-origin.com"])
      expect(Devise::PasskeyAuthenticatable).to receive(:log_webauthn_error).with(an_instance_of(WebAuthn::OriginVerificationError), any_args).and_call_original

      post user_session_path, params: params

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template("devise/sessions/new")
    end

    it "clientDataJSON に含まれる rp id が allowed_origins に含まれていなかったら失敗" do
      expect_any_instance_of(Devise::SessionsController).not_to receive(:sign_in)
      expect(WebAuthn.configuration.relying_party).to receive(:id).twice.and_return("another.com")
      expect(Devise::PasskeyAuthenticatable).to receive(:log_webauthn_error).with(an_instance_of(WebAuthn::RpIdVerificationError), any_args).and_call_original

      post user_session_path, params: params

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template("devise/sessions/new")
    end
  end
end
