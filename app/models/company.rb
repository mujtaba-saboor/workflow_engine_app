class Company < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :issues, dependent: :destroy
end
