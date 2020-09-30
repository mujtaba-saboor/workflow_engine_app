class Company < ApplicationRecord
  not_multitenant

  has_many :users, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :issues, dependent: :destroy
  has_many :invites, dependent: :destroy

  PAGE_SIZE = 5

  validates :subdomain, format: { with: /\A[a-zA-Z0-9]+\z/,
    message: I18n.t('companies.domain_validation') }

  def self.current_id=(id)
    Thread.current[:company_id] = id
  end

  def self.current_id
    Thread.current[:company_id]
  end
end
