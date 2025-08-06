require "rails_helper"

RSpec.describe "Devise Passkeys", type: :request do
  describe "GET /user/passkeys" do
    before do
      login_as create(:user), scope: :user
    end

    it "returns a successful response" do
      get user_passkeys_path
      expect(response).to have_http_status(:ok)
    end

    it "renders the passkeys index template" do
      get user_passkeys_path
      expect(response).to render_template(:index)
    end

    it "assigns public key credential creation options" do
      get user_passkeys_path
      expect(assigns(:public_key_credential_creation_options)).to be_present
    end
  end

  describe "POST /user/passkeys" do
    before do
      login_as user, scope: :user
    end

    let(:user) { create(:user) }
    let(:challenge) { "3_Olo2Ziw8g2qnwxpLCgU_2XqKWUNoyJwt_ixY5As84" }
    let(:public_key) {
      ao = WebAuthn::AttestationObject.deserialize(
        Base64.urlsafe_decode64("o2NmbXRkbm9uZWdhdHRTdG10oGhhdXRoRGF0YViYSZYN5YgOjGh0NBcPZHZgW4_krrmihjLHmVzzuoMdl2NZAAAAAPv8MAcVTk7MjAtuAgVX170AFDOt80z4h3PV_0WbV4s51JFjW8x0pQECAyYgASFYIAICIq3N_wfxxsN8-pHiC2q1fL2XT_fV7S5LxTmk6PYAIlgggz7SFwatSg7FnWJ73sA7wgoj_VOLcM2E2F6bgTvZB2w"),
        WebAuthn.configuration.relying_party,
      )
      pk = Base64.urlsafe_encode64(ao.credential.public_key, padding: false)
      expect(pk).to eq "pQECAyYgASFYIAICIq3N_wfxxsN8-pHiC2q1fL2XT_fV7S5LxTmk6PYAIlgggz7SFwatSg7FnWJ73sA7wgoj_VOLcM2E2F6bgTvZB2w"
      pk
    }
    let(:valid_params) do
      {
        "credential" => {
          "authenticatorAttachment" => "platform",
          "clientExtensionResults" => {},
          "id" => "M63zTPiHc9X_RZtXiznUkWNbzHQ",
          "rawId" => "M63zTPiHc9X_RZtXiznUkWNbzHQ",
          "response" => {
            "attestationObject" => "o2NmbXRkbm9uZWdhdHRTdG10oGhhdXRoRGF0YViYSZYN5YgOjGh0NBcPZHZgW4_krrmihjLHmVzzuoMdl2NZAAAAAPv8MAcVTk7MjAtuAgVX170AFDOt80z4h3PV_0WbV4s51JFjW8x0pQECAyYgASFYIAICIq3N_wfxxsN8-pHiC2q1fL2XT_fV7S5LxTmk6PYAIlgggz7SFwatSg7FnWJ73sA7wgoj_VOLcM2E2F6bgTvZB2w",
            "authenticatorData" => "SZYN5YgOjGh0NBcPZHZgW4_krrmihjLHmVzzuoMdl2NZAAAAAPv8MAcVTk7MjAtuAgVX170AFDOt80z4h3PV_0WbV4s51JFjW8x0pQECAyYgASFYIAICIq3N_wfxxsN8-pHiC2q1fL2XT_fV7S5LxTmk6PYAIlgggz7SFwatSg7FnWJ73sA7wgoj_VOLcM2E2F6bgTvZB2w",
            "clientDataJSON" => "eyJ0eXBlIjoid2ViYXV0aG4uY3JlYXRlIiwiY2hhbGxlbmdlIjoiM19PbG8yWml3OGcycW53eHBMQ2dVXzJYcUtXVU5veUp3dF9peFk1QXM4NCIsIm9yaWdpbiI6Imh0dHA6Ly9sb2NhbGhvc3Q6MzAwMCIsImNyb3NzT3JpZ2luIjpmYWxzZX0",
            "publicKey" => "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEAgIirc3_B_HGw3z6keILarV8vZdP99XtLkvFOaTo9gCDPtIXBq1KDsWdYnvewDvCCiP9U4twzYTYXpuBO9kHbA",
            "publicKeyAlgorithm" => -7,
            "transports" => %w(internal hybrid),
          },
          "type" => "public-key",
          "controller" => "devise/passkeys",
          "action" => "create",
          "passkey" => {
            "authenticatorAttachment" => "platform",
            "clientExtensionResults" => {},
            "id" => "M63zTPiHc9X_RZtXiznUkWNbzHQ",
            "rawId" => "M63zTPiHc9X_RZtXiznUkWNbzHQ",
            "response" => {
              "attestationObject" => "o2NmbXRkbm9uZWdhdHRTdG10oGhhdXRoRGF0YViYSZYN5YgOjGh0NBcPZHZgW4_krrmihjLHmVzzuoMdl2NZAAAAAPv8MAcVTk7MjAtuAgVX170AFDOt80z4h3PV_0WbV4s51JFjW8x0pQECAyYgASFYIAICIq3N_wfxxsN8-pHiC2q1fL2XT_fV7S5LxTmk6PYAIlgggz7SFwatSg7FnWJ73sA7wgoj_VOLcM2E2F6bgTvZB2w",
              "authenticatorData" => "SZYN5YgOjGh0NBcPZHZgW4_krrmihjLHmVzzuoMdl2NZAAAAAPv8MAcVTk7MjAtuAgVX170AFDOt80z4h3PV_0WbV4s51JFjW8x0pQECAyYgASFYIAICIq3N_wfxxsN8-pHiC2q1fL2XT_fV7S5LxTmk6PYAIlgggz7SFwatSg7FnWJ73sA7wgoj_VOLcM2E2F6bgTvZB2w",
              "clientDataJSON" => "eyJ0eXBlIjoid2ViYXV0aG4uY3JlYXRlIiwiY2hhbGxlbmdlIjoiM19PbG8yWml3OGcycW53eHBMQ2dVXzJYcUtXVU5veUp3dF9peFk1QXM4NCIsIm9yaWdpbiI6Imh0dHA6Ly9sb2NhbGhvc3Q6MzAwMCIsImNyb3NzT3JpZ2luIjpmYWxzZX0",
              "publicKey" => "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEAgIirc3_B_HGw3z6keILarV8vZdP99XtLkvFOaTo9gCDPtIXBq1KDsWdYnvewDvCCiP9U4twzYTYXpuBO9kHbA",
              "publicKeyAlgorithm" => -7,
              "transports" => %w(internal hybrid),
            },
            "type" => "public-key",
          },
        },
      }
    end
    let(:session) { {passkey_challenge: challenge} }

    it "creates a new passkey and returns success" do
      expect {
        post user_passkeys_path, params: valid_params
      }.to change { user.reload.passkeys.count }.by(1)
      expect(response).to redirect_to user_passkeys_path

      passkey = user.passkeys.last
      expect(passkey.public_key).to eq public_key
    end

    # 検証の処理は WebAuthn::AuthenticatorResponse#verify で行われる

    # パスキーでは登録時の AttestationStatement が空のため署名が含まれない
    # そのため署名の検証は行われず、clientDataJSON が変わっても成功する
    it "clientDataJSON の内容が変わっても成功" do
      modified_params = valid_params.deep_dup
      client_data = JSON.parse(Base64.urlsafe_decode64(modified_params["credential"]["passkey"]["response"]["clientDataJSON"]))
      client_data["foo"] = "bar"
      modified_params["credential"]["passkey"]["response"]["clientDataJSON"] = Base64.urlsafe_encode64(client_data.to_json)

      expect {
        post user_passkeys_path, params: modified_params
      }.to change { user.reload.passkeys.count }.by(1)
      expect(response).to redirect_to user_passkeys_path
    end

    # challenge の検証
    # CSRF 対策
    context "clientDataJSON に含まれる challenge が一致しなければ" do
      let(:challenge) { "Mty0XB19FNxKluGW8SbOiJVD39RKMyPW6yNOABTlxXc" }
      it "challenge 検証失敗" do
        expect(Devise::PasskeyAuthenticatable).to receive(:log_webauthn_error).with(an_instance_of(WebAuthn::ChallengeVerificationError), any_args).and_call_original

        expect {
          post user_passkeys_path, params: valid_params
        }.not_to change { user.reload.passkeys.count }

        expect(response).to render_template :index
      end
    end

    # 作成レスポンスの clientDataJSON の偽装は可能なので、実装ミス対策程度？
    # 今後、認証に使えない無関係な passkey の登録を拒否するくらい
    it "clientDataJSON に含まれる origin が allowed_origins に含まれていなかったら失敗" do
      expect(WebAuthn.configuration.relying_party).to receive(:allowed_origins).and_return(["http://another-origin.com"])
      expect(Devise::PasskeyAuthenticatable).to receive(:log_webauthn_error).with(an_instance_of(WebAuthn::OriginVerificationError), any_args).and_call_original

      expect {
        post user_passkeys_path, params: valid_params
      }.not_to change { user.reload.passkeys.count }

      expect(response).to render_template :index
    end

    # 作成レスポンスの clientDataJSON の偽装は可能なので、実装ミス対策程度？
    # 今後、認証に使えない無関係な passkey の登録を拒否するくらい
    it "clientDataJSON に含まれる rp id が allowed_origins に含まれていなかったら失敗" do
      expect(WebAuthn.configuration.relying_party).to receive(:id).twice.and_return("another.com")
      expect(Devise::PasskeyAuthenticatable).to receive(:log_webauthn_error).with(an_instance_of(WebAuthn::RpIdVerificationError), any_args).and_call_original

      expect {
        post user_passkeys_path, params: valid_params
      }.not_to change { user.reload.passkeys.count }

      expect(response).to render_template :index
    end
  end

  describe "DELETE /user/passkeys/:id" do
    # Add tests for the destroy action if needed.
  end
end
