# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Lorem.characters(number: 10, min_numeric: 2) }
    company
  end
end
