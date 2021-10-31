class User < ApplicationRecord
  before_validation { email.downcase! }
  validates :name,  presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  has_secure_password
  validates :password, length: { minimum: 6 }
  # active_relationshipsは、自分のidがrelationshipsテーブルのfollower_idと一致するレコード
  # つまりは自分が「フォロワーである」という関係性を取り出すアソシエーション
  has_many :active_relationships, foreign_key: 'follower_id', class_name: 'Relationship', dependent: :destroy
  # assive_relationshipsは、自分のidがrelationshipsテーブルのfollowed_idと一致するレコード
  # つまりは自分が「フォローされている側である」という関係性を取り出すアソシエーション
  has_many :passive_relationships, foreign_key: 'followed_id', class_name: 'Relationship', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  # 指定のユーザーをフォローする
  def follow!(other_user)
    active_relationships.create!(followed_id: other_user.id)
  end
  # フォローしているかどうかを確認する
  def following?(other_user)
    active_relationships.find_by(followed_id: other_user.id)
  end
  # 指定のユーザーのフォローを解除する
  def unfollow!(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
end
