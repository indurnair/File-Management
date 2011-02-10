class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,:confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name,:last_name,:active,:login,:email, :password, :password_confirmation,:state_id,:country_id,:address,:zip,:roles_mask,:roles
  has_many :user_files
  belongs_to :state
  belongs_to :country

  before_create :add_normal_role

   named_scope :with_role, lambda { |role| {:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0 "} }

   ROLES = %w[admin user]

   def roles=(roles)
     self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
   end

  def roles
     ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
   end

   def role?(role)
     roles.include? role.to_s
   end

   private

  def add_normal_role
    self.roles=([ROLES[1]])
  end




end

