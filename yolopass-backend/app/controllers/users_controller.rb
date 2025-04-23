class UsersController < ApplicationController
  # POST /signup
  def create
    # Create a new user using the provided parameters
    @user = User.new(user_params)

    # Check if the user saves successfully, and return an appropriate response
    if @user.save
      render json: { message: 'User created successfully' }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Strong parameters for user creation
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end
end
