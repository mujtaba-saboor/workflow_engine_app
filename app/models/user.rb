class User < ApplicationRecord

	sequenceid :company , :users
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::Models::Validatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable # , :validatable

  # https://github.com/heartcombo/devise/blob/master/lib/devise/models/validatable.rb
  validates_uniqueness_of :email, scope: :company_id
  validates_format_of     :email, with: email_regexp, allow_blank: true, if: :email_changed?
  validates_presence_of     :password, if: :password_required?
  validates_confirmation_of :password, if: :password_required?
  validates_length_of       :password, within: password_length, allow_blank: true
  belongs_to :company

  has_many :project_users
  has_many :projects, through: :project_users
  has_many :team_users
  has_many :teams, through: :team_users
  has_many :comments
  has_many :watchers

  def self.find_for_authentication(warden_conditions)
    where(email: warden_conditions[:email], company_id: Company.current_id).first
  end
end
