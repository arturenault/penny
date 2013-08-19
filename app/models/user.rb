class User < ActiveRecord::Base
  VALID_USERNAME_REGEX = /\A[a-zA-Z0-9_]+\z/i
  validates :username, presence: true, length: { maximum: 50 }, format: {with: VALID_USERNAME_REGEX}, uniqueness: {case_sensitive: false }
end