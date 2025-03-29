class ApplicationController < ActionController::API
  include JsonWebToken

  private

  def authenticate_user
    header = request.headers["Authorization"]
    header = header.split(" ").last if header

    begin
      @decoded = jwt_decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  def authorize_admin
    render json: { error: "Not authorized" }, status: :forbidden unless current_user.admin?
  end
end
