class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable
  belongs_to :company
  accepts_nested_attributes_for :company

  has_many :project_users
  has_many :projects, through: :project_users
  has_many :team_users
  has_many :teams, through: :team_users
  has_many :comments
  has_many :watchers

  def get_project_count
    if(self.role.eql? 'STAFF')
      self.projects.count
    else
      Project.all.count
    end
  end

  def get_team_count
    if(self.role.eql? 'STAFF')
      self.teams.count
    else
      Team.all.count
    end
  end
end
