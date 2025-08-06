class CreateUserPasskeysAndAddPasskeyUserIdToUsers < ActiveRecord::Migration[8.0]
  def up
    add_column :users, :passkey_user_id, :string #, after: :encrypted_password
    execute("SELECT id FROM users WHERE passkey_user_id IS NULL").each do |record|
      id = record[0]
      passkey_user_id = WebAuthn.generate_user_id
      execute("UPDATE users SET passkey_user_id = '#{passkey_user_id}' WHERE id = #{id}")
    end
    change_column :users, :passkey_user_id, :string, null: false
    add_index :users, :passkey_user_id, unique: true

    create_table :user_passkeys do |t|
      t.references :user, null: false, foreign_key: true
      t.string :credential_id, null: false
      t.string :name, null: false
      t.string :public_key, null: false
      t.integer :sign_count, null: false, default: 0
      t.text :creation_response, null: false
      t.datetime :last_used_at, null: false, default: "1900-01-01 00:00:00"
      t.string :last_used_ip, null: true, default: nil
      t.string :last_used_user_agent, null: true, default: nil, limit: 1024
      t.timestamps

      t.index :credential_id, unique: true # 認証時は credential_id のみで検索
      t.index [:user_id, :credential_id], unique: true
    end
  end

  def down
    remove_column :users, :passkey_user_id
    drop_table :user_passkeys
  end
end
