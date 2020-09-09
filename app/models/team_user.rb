class TeamUser < ApplicationRecord
  belongs_to :team
  belongs_to :user
  belongs_to :company
end
