class Company < ApplicationRecord
  not_multitenant
  PAGE_SIZE = 5

  has_many :users
  has_many :projects
  has_many :teams

  validates :subdomain, format: { with: /\A[a-zA-Z0-9]+\z/,
    message: I18n.t('companies.domain_validation') }

  def self.current_id=(id)
    Thread.current[:company_id] = id
  end

  def self.current_id
    Thread.current[:company_id]
  end
end
