class Post < ApplicationRecord
  belongs_to :group
  belongs_to :user
  validates :user_id, presence: true
  has_many :comments, dependent: :destroy

end
