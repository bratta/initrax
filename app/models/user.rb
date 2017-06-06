class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable,
         :two_factor_authenticatable, :two_factor_backupable,
         otp_secret_encryption_key: ENV['TWO_FACTOR_AUTH_SECRET'], otp_number_of_backup_codes: 12
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :homepage, format: { with: /\A#{URI.regexp.to_s}\z/ }, if: 'homepage.present?'

  has_many :characters, -> { active }
  has_many :combats, -> { active }
  has_many :combatants, -> { active }

  def to_json_ui
    {
      id: self.id,
      username: self.username,
      email: self.email,
      homepage: self.homepage,
      facebook: self.facebook,
      twitter: self.twitter,
      mastodon: self.mastodon,
      avatar_url: self.avatar_url
    }.to_json
  end

  def avatar_url
    "https://www.gravatar.com/avatar/#{Digest::MD5.new().hexdigest(self.email)}?s=48"
  end

  def update_without_password(params, *options)
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end
end
