class Invite < ApplicationRecord
  before_create :generate_token

  belongs_to :company
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  def generate_token
     self.token = Digest::SHA1.hexdigest([self.company_id, Time.now, rand].join)
  end
end
