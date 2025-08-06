class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :passkey_authenticatable
  has_many :passkeys, class_name: "User::Passkey", dependent: :destroy
end
