class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  private

  def sign_up_params
    params.permit(:email, :password, :password_confirmation, :name)
  end

  def render_error
    render json: {
      status: 'error',
      message: resource.errors.full_messages.first
    }, status: :unprocessable_entity
  end
end
