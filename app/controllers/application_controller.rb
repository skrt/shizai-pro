class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # Require authentication for all pages
  before_action :authenticate_user!

  private

  def after_sign_out_path_for(_resource_or_scope)
    magic_link_login_path
  end
end
