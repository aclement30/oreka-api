Sphynx.configure do |config|
  config.dispatch_requests = [['POST', /^\/access_token$/]]
  #config.revocation_requests = [['POST', /^logout$/]]
  config.secret = 'verysecret'
  config.scopes = {
      user: { user_class: User, provider_class: AuthProvider }
  }
  config.google_client_id = '529258741380-bdvaq5l3bd3o1a60opija08s283dbpp4.apps.googleusercontent.com'
end