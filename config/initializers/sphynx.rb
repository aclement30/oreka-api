Sphynx.configure do |config|
  config.dispatch_requests = [['POST', /^\/access_token$/]]
  #config.revocation_requests = [['POST', /^logout$/]]
  config.secret = ENV['OREKA_SPHYNX_SECRET']
  config.scopes = {
      user: { user_class: User, provider_class: AuthProvider }
  }
  config.google_client_id = ENV['OREKA_GOOGLE_CLIENT_ID']
end