class Users::RegistrationsController < Devise::RegistrationsController
  layout "auth"

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :last_name, :first_name)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :last_name, :first_name)
  end
end
