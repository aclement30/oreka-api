require 'sphynx/services/google_auth_service'

class AuthController < ApiController
  skip_before_action :authenticate_user!

  # GET /access_token
  def access_token
    token_params = params.permit(:google_token)
    user = Sphynx::GoogleAuthService.authenticate!(:user, token_params[:google_token], request)
    render json: { token: request.env['warden-jwt_auth.token'] }
  end
end