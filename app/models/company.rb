class Company < ApplicationRecord
  has_many :users
  has_many :projects
  has_many :teams

  validates :subdomain, format: { with: /\A[a-zA-Z0-9]+\z/,
    message: I18n.t('companies.domain_validation') }
end
