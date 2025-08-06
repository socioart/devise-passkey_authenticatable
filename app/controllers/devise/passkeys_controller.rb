module Devise
  class PasskeysController < DeviseController
    include Devise::Controllers::Helpers

    before_action do
      send "authenticate_#{resource_name}!"
    end

    def index
      prepare_for_index
    end

    def create
      credential = params[:credential] || JSON.parse(params[:credential_json])
      passkey = send("current_#{resource_name}").create_passkey_by_creation_response(credential, session[:passkey_challenge], request, now)
      session[:passkey_challenge] = nil

      if passkey
        redirect_to send("#{resource_name}_passkeys_path"), notice: I18n.t("devise.passkeys.create.success")
      else
        prepare_for_index
        render :index, alert: I18n.t("devise.passkeys.create.failure")
      end
    end

    def edit
      @passkey = send("current_#{resource_name}").passkeys.find(params[:id])
    end

    def update
      @passkey = send("current_#{resource_name}").passkeys.find(params[:id])

      if @passkey.update(update_params)
        redirect_to send("#{resource_name}_passkeys_path"), notice: I18n.t("devise.passkeys.update.success")
      else
        render :edit, alert: I18n.t("devise.passkeys.update.failure")
      end
    end

    def destroy
      passkey = send("current_#{resource_name}").passkeys.find(params[:id])
      passkey.destroy
      redirect_to send("#{resource_name}_passkeys_path"), notice: I18n.t("devise.passkeys.destroy.success")
    end

    private
    def prepare_for_index
      @passkeys = send("current_#{resource_name}").passkeys.order_by_last_used_at
      @public_key_credential_creation_options = send("current_#{resource_name}").passkey_options_for_create
      session[:passkey_challenge] = @public_key_credential_creation_options.challenge
    end

    def update_params
      params.require("#{resource_name}_passkey").permit(:name)
    end

    def now
      Time.zone.now
    end
  end
end
