class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User" # リレーションシップ/フォロワーに対してbelongs_to の関連づけを追加する
  belongs_to :followed, class_name: "User" 
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
