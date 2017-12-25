class CouplesController < ApiController
  # GET /couples/members
  def members
    render json: current_user.couple.users
  end

  # POST /couples
  def create
    p couple_params[:email]
    partner = User.find_by(email: couple_params[:email])

    unless partner.couple.nil?
      raise Exception.new("Other user is already linked to a couple")
    end

    unless current_user.couple.nil?
      raise Exception.new("Current user is already linked to a couple")
    end

    @couple = Couple.new()
    @couple.users = [current_user, partner]
    @couple.save!

    render json: @couple
  end

  private

  def couple_params
    # whitelist params
    params.permit(:email)
  end
end