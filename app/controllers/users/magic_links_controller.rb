class Users::MagicLinksController < ApplicationController
  layout "auth"
  skip_before_action :authenticate_user!

  def new
    # GET /auth/login — magic link email form (default login)
  end

  def create
    # POST /auth/login — send magic link email
    email = params[:email].to_s.strip.downcase
    @email = email

    if email.blank?
      @error = "入力してください"
      return render :new, status: :unprocessable_entity
    end

    user = User.find_by(email: email)
    if user
      raw_token = user.generate_magic_link_token!
      UserMailer.magic_link(user, raw_token).deliver_now
    end

    # Always redirect to sent page (prevent email enumeration)
    redirect_to magic_link_sent_path(email: email)
  end

  def sent
    # GET /auth/magic_link/sent — email sent confirmation
    @email = params[:email]
  end

  def resend
    # POST /auth/magic_link/resend — resend magic link
    email = params[:email].to_s.strip.downcase

    user = User.find_by(email: email)
    if user
      raw_token = user.generate_magic_link_token!
      UserMailer.magic_link(user, raw_token).deliver_now
    end

    redirect_to magic_link_sent_path(email: email)
  end

  def verify
    # GET /auth/magic_link/verify?token=xxx — verify token and sign in
    raw_token = params[:token]
    user = User.find_by_magic_link_token(raw_token)

    if user&.magic_link_valid?
      user.clear_magic_link_token!
      sign_in(user)
      redirect_to root_path
    else
      redirect_to magic_link_expired_path
    end
  end

  def expired
    # GET /auth/magic_link/expired — link expired page
  end
end
