FactoryBot.define do
  factory :user do
    sequence(:email) {|sn| "member-#{sn}@example.com" }
    password { "opensesame" }
    password_confirmation { "opensesame" }
  end

  factory :user_passkey, class: "User::Passkey"
end
