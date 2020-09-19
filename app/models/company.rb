class Company < ApplicationRecord
  default_scope { unscoped }
  has_many :users
  has_many :projects
  has_many :teams

  def self.current_id=(id)
    Thread.current[:company_id] = id
  end

  def self.current_id
    Thread.current[:company_id]
  end
end
