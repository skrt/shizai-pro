class Users::SessionsController < Devise::SessionsController
  layout "auth"

  def create
    email = sign_in_params[:email].to_s.strip
    password = sign_in_params[:password].to_s.strip

    @email_error = "入力してください" if email.blank?
    @password_error = "入力してください" if password.blank?

    if @email_error || @password_error
      self.resource = resource_class.new(email: email)
      return render :new, status: :unprocessable_entity
    end

    super
  end

  protected

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  def set_flash_message(key, kind, options = {})
    return if kind == :signed_out
    super
  end
end
