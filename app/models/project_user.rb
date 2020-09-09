class ProjectUser < ApplicationRecord
  belongs_to :project
  belongs_to :user
  belongs_to :company
end
