class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :company

  has_many :project_users
  has_many :projects, through: :project_users
  has_many :team_users
  has_many :teams, through: :team_users
  has_many :comments, dependent: :destroy
  has_many :watchers, dependent: :destroy
  has_many :created_issues, class_name: 'Issue', foreign_key: 'creator_id', inverse_of: 'creator', dependent: :destroy
  has_many :assigned_issues, class_name: 'Issue', foreign_key: 'assignee_id', inverse_of: 'assignee', dependent: :nullify
end
