class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :last_name, presence: true
  validates :first_name, presence: true

  MAGIC_LINK_EXPIRY = 30.minutes

  def full_name
    "#{last_name} #{first_name}"
  end

  def generate_magic_link_token!
    raw_token = SecureRandom.urlsafe_base64(32)
    hashed = Devise.token_generator.digest(self.class, :magic_link_token, raw_token)
    update!(magic_link_token: hashed, magic_link_sent_at: Time.current)
    raw_token
  end

  def self.find_by_magic_link_token(raw_token)
    hashed = Devise.token_generator.digest(self, :magic_link_token, raw_token)
    find_by(magic_link_token: hashed)
  end

  def magic_link_valid?
    magic_link_sent_at.present? && magic_link_sent_at > MAGIC_LINK_EXPIRY.ago
  end

  def clear_magic_link_token!
    update!(magic_link_token: nil, magic_link_sent_at: nil)
  end
end
