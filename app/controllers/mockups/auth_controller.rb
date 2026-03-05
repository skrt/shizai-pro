module Mockups
  class AuthController < ApplicationController
    layout "auth"

    # GET /mockups/auth/signup
    def signup
    end

    # POST /mockups/auth/signup
    def create_signup
      @email = params[:email].to_s.strip
      @password = params[:password].to_s
      @last_name = params[:last_name].to_s.strip
      @first_name = params[:first_name].to_s.strip

      @errors = {}
      @errors[:email] = "有効なメールアドレスを入力しましょう" if @email.blank? || !@email.match?(/\A[^@\s]+@[^@\s]+\.[^@\s]+\z/)
      @errors[:password] = "8文字以上で入力しましょう" if @password.blank? || @password.length < 8
      @errors[:last_name] = "入力しましょう" if @last_name.blank?
      @errors[:first_name] = "入力しましょう" if @first_name.blank?

      if @errors.any?
        render :signup, status: :unprocessable_entity
      else
        redirect_to mockups_auth_password_login_path, notice: "アカウントを作成しました"
      end
    end

    # GET /mockups/auth/password_login
    def password_login
    end

    # POST /mockups/auth/password_login
    def create_password_login
      @email = params[:email].to_s.strip
      @password = params[:password].to_s

      @errors = {}
      @errors[:email] = "入力しましょう" if @email.blank?
      @errors[:password] = "入力しましょう" if @password.blank?

      if @errors.any?
        @alert = "メールアドレスかパスワードに誤りがあります"
        render :password_login, status: :unprocessable_entity
      else
        redirect_to root_path, notice: "ログインしました"
      end
    end

    # GET /mockups/auth/login
    def login
    end

    # POST /mockups/auth/login
    def create_login
      @email = params[:email].to_s.strip

      if @email.blank? || !@email.match?(/\A[^@\s]+@[^@\s]+\.[^@\s]+\z/)
        @error = "有効なメールアドレスを入力しましょう"
        render :login, status: :unprocessable_entity
      else
        redirect_to mockups_auth_sent_path(email: @email)
      end
    end

    # GET /mockups/auth/sent
    def sent
      @email = params[:email] || "yamada@example.com"
    end

    # POST /mockups/auth/resend
    def resend
      @email = params[:email] || "yamada@example.com"
      redirect_to mockups_auth_sent_path(email: @email), notice: "メールを再送しました"
    end

    # GET /mockups/auth/expired
    def expired
    end

    # GET /mockups/auth/url_expired
    def url_expired
    end
  end
end
