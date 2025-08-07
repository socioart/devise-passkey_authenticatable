# Devise::PasskeyAuthenticatable
Add Passkey support to Devise.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "devise-passkey_authenticatable"
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

1. Create `config/initializers/webauthn.rb` (See: https://github.com/cedarcode/webauthn-ruby)
2. Generate passkey model and migration by `bin/rails g devise:passkey_authenticatable:migration user`
3. Add `:passkey_authenticatble` to your user model's `devise` method arguments
4. Add `controllers: {session: "devise/passkey_authenticatable/sessions"}` option to `devise_for` in `config/routes.rb`
5. See JS examples by `bin/rails g devise:passkey_authenticatable:js`, and add to `devise/session/new` (authentication) and `devise/passkeys/index` (creation)

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
