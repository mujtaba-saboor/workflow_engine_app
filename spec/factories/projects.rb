# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    name { Faker::Lorem.sentence }
    project_category { 'TEAM' }
    company
  end
end
