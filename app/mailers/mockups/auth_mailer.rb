module Mockups
  class AuthMailer < ApplicationMailer
    default from: "noreply@shizai.co <noreply@shizai.co>"

    def magic_link(email:, token:)
      @email = email
      @token = token
      @magic_link_url = mockups_auth_login_url(token: @token)

      mail(
        to: email,
        subject: "shizai ログインリンク"
      )
    end
  end
end
