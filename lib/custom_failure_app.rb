class CustomFailureApp < Devise::FailureApp
  def redirect_url
    if request.post?
      # Failed password login → back to password login page with error
      super
    else
      # Unauthenticated page access → magic link login
      magic_link_login_url
    end
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
