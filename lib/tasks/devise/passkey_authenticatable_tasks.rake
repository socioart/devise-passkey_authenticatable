namespace :devise do
  namespace :passkey_authenticatable do
    desc "Update the AAGUID list used for passkey management"
    task "update_aaguid_list" => :environment do
      Devise::PasskeyAuthenticatable.update_aaguid_list
      puts "AAGUID list updated successfully."
    end
  end
end
