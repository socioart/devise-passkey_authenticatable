module Devise
  class PasskeysController < DeviseController
    include Devise::Controllers::Helpers

    before_action :authenticate_user!

    def index
      prepare_for_index
    end

    def create
      credential = params[:credential] || JSON.parse(params[:credential_json])
      passkey = current_user.create_passkey_by_creation_response(credential, session[:passkey_challenge], request, now)
      session[:passkey_challenge] = nil

      if passkey
        redirect_to user_passkeys_path, notice: I18n.t("devise.passkeys.create.success")
      else
        prepare_for_index
        render :index, alert: I18n.t("devise.passkeys.create.failure")
      end
    end

    def edit
      @passkey = current_user.passkeys.find(params[:id])
    end

    def update
      @passkey = current_user.passkeys.find(params[:id])

      if @passkey.update(update_params)
        redirect_to user_passkeys_path, notice: I18n.t("devise.passkeys.update.success")
      else
        render :edit, alert: I18n.t("devise.passkeys.update.failure")
      end
    end

    def destroy
      passkey = current_user.passkeys.find(params[:id])
      passkey.destroy
      redirect_to user_passkeys_path, notice: I18n.t("devise.passkeys.destroy.success")
    end

    private
    def prepare_for_index
      @passkeys = current_user.passkeys.order_by_last_used_at
      @public_key_credential_creation_options = current_user.passkey_options_for_create
      session[:passkey_challenge] = @public_key_credential_creation_options.challenge
    end

    def update_params
      params.require(:user_passkey).permit(:name)
    end

    def now
      Time.zone.now
    end
  end
end
