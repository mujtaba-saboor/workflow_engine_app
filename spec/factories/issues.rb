# frozen_string_literal: true

FactoryBot.define do
  factory :issue do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
    status { 'open' }
    priority { 'high' }
    issue_type { 'bug' }
    company
    project
    assignee { association :user }
    creator { association :user }
  end
end
