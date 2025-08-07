# Devise::PasskeyAuthenticatable
Add Passkey support to Devise.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "devise-passkey_authenticatable", git: "https://github.com/socioart/devise-passkey_authenticatable.git"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install devise-passkey_authenticatable
```

## Usage

1. Create `config/initializers/webauthn.rb` (See: https://github.com/cedarcode/webauthn-ruby).
2. Generate passkey model and migration by `bin/rails g devise:passkey_authenticatable:model user`. And run `bin/rails db:migrate`
3. Add `:passkey_authenticatble` to your user model's `devise` method arguments. Add `has_meny :passkeys` to your user model.

```
class User < ApplicationRecord
  devise :database_authenticatable, ..., :passkey_authenticatble
  has_many :passkeys, class: "User::Passkey"
end
```

4. Add `controllers: {session: "devise/passkey_authenticatable/sessions"}` option to `devise_for` in `config/routes.rb`.

```
Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "devise/passkey_authenticatable/sessions",
  }
end
```

5. See JS examples by `bin/rails g devise:passkey_authenticatable:js`, and add to `devise/session/new` (authentication), `devise/passkeys/index` (creation), and `users/show` (signals).
6. Run `bin/rails devise:passkey_authenticatable:update_aaguid_list`

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
