class User < ApplicationRecord
  before_save { email.downcase! } #email属性を小文字に変換してメールアドレスの一意性を保証する。before_save {self.email = email.downcase }と同じ。
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, 
              format: { with: VALID_EMAIL_REGEX },
              uniqueness: { case_sensitive: false }
end 
