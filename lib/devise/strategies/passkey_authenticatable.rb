require "devise/strategies/authenticatable"

module Devise
  module Strategies
    class PasskeyAuthenticatable < Authenticatable
      def valid?
        params[:credential].present? || params[:credential_json].present?
      end

      def authenticate!(now = Time.now)
        credential = params[:credential] || JSON.parse(params[:credential_json])
        res = mapping.to.authenticate_by_passkey(credential, session[:passkey_challenge], request, now)
        if res
          success!(res) # 認証成功。
        else
          fail!(:invalid) # 認証失敗。
        end
      ensure
        session[:passkey_challenge] = nil
      end
    end
  end
end
