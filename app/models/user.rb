class User < ApplicationRecord
  rolify :before_add => :before_add_method
  after_create :assign_default_role
  delegate :can?, :cannot?, to: :ability

  def ability
    @ability ||= Ability.new(self)
  end

  def assign_default_role
    self.add_role(:newuser) if self.roles.blank?
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :memberships
  has_many :groups, through: :memberships
  has_and_belongs_to_many :groups
  has_many :posts
  has_many :comments, dependent: :destroy
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, authentication_keys: [:email]
  # validate :validate_username
  #
  # def validate_username
  #   if User.where(email: username).exists?
  #     errors.add(:username, :invalid)
  #   end
  # end
  #
  # attr_writer :login
  #
  # def login
  #   @login || self.user_name || self.email
  # end
  #
  # def self.find_for_database_authentication(warden_conditions)
  #   conditions = warden_conditions.dup
  #   if (login = conditions.delete(:login))
  #     where(conditions.to_h).where(["lower(username) = :value OR lower(email)= :value", { :value => login.downcase }]).first
  #   elsif conditions.has_key?(:username) || conditions.has_key?(:email)
  #     where(conditions.to_h).first
  #   end
  # end

  # use this instead of email_changed? for Rails = 5.1.x
  def before_add_method(role)
    # do something before it gets added
  end

end


