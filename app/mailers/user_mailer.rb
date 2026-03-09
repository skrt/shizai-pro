class UserMailer < ApplicationMailer
  def magic_link(user, raw_token)
    @user = user
    @magic_link_url = verify_magic_link_url(token: raw_token)
    mail(to: user.email, subject: "shizai ログインリンク")
  end
end
