class Api::V1::AuthController < ApplicationController
  def create
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password])
      token = jwt_encode(user_id: @user.id)
      render json: { token: token, user: @user.as_json(except: :password_digest) }
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  def register
    @user = User.new(user_params)

    if @user.save
      token = jwt_encode(user_id: @user.id)
      render json: { token: token, user: @user.as_json(except: :password_digest) }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
