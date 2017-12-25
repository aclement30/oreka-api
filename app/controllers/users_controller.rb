class UsersController < ApiController
  # GET /users/profile
  def profile
    render json: current_user
  end

  # POST /users
  def create
    user = User.new(user_params)

    User.transaction do
      user_balance = Balance.create!()

      user.balance = user_balance
      user.save!
    end

    render json: user
  end

  # PUT /users/:id
  def update
    current_user.update(user_params)
    render json: current_user
  end

  private

  def user_params
    # whitelist params
    params.permit(:first_name, :last_name, :email)
  end
end