class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  default_scope { where(company_id: Company.current_id) }
end
