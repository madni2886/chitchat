class Group < ApplicationRecord
  has_many :posts
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships, dependent: :destroy
  has_and_belongs_to_many :users
  has_one_attached :image
  has_many_attached :pictures
  validates :title, :group_type, :image, presence: true
  has_rich_text :body
  public
  def get_group_admin
    User.find(1)
  end

  def check_request_status(currU)
    memberships.find_by_user_id(currU.id) == nil ? false : memberships.find_by_user_id(currU.id).req
  end

  def check_group_admin(currU)
    users.first.id == currU.id
  end

  def generate_url(currU)
    url = "[::1]:3000//user/#{currU.id}/groups/#{self.id}/join"
  end

  def pending_req_count
    request_count = memberships.where(req: false).count
  end
end
