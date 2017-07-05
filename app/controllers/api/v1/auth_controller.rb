module Api
  module V1
    class AuthController < Api::ApiController
      def create
        user = User.find_by_credentials(user_params[:email], user_params[:password])
        if user
          render json: { auth_token: user.generate_auth_token }
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end

      def user_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
