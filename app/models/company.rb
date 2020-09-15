class Company < ApplicationRecord
  has_many :users
  has_many :projects
  has_many :teams

  validates :domain, format: { with: /\A[a-zA-Z0-9]+\z/,
    message: "only allows letters and numbers" }
end
