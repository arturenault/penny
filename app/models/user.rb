class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  before_create :create_remember_token
  VALID_USERNAME_REGEX = /\A[a-zA-Z0-9_]+\z/i
  validates :username, presence: true,
                       length: { maximum: 50 },
                       format: {with: VALID_USERNAME_REGEX},
                       uniqueness: {case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Post.where("user_id = ?", id)
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end