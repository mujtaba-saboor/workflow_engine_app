class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  belongs_to :company
  accepts_nested_attributes_for :company

  has_many :project_users
  has_many :projects, through: :project_users

  has_many :team_users
  has_many :teams, through: :team_users

end
