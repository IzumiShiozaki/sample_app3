class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> {order(created_at: :desc)} #default_scopeでマイクロポストを順序づけする
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
end
