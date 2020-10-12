require 'faker'

FactoryGirl.define do
  factory :company, class: Company do
    name { Faker::Name.unique.name.downcase }
    subdomain { name.delete(' ').delete('.').downcase }
  end

  factory :project, class: Project do
    name { Faker::Name.unique.name }
    project_category 'TEAM'
  end

  factory :team, class: Team do
    name { Faker::Name.unique.name }
  end

  factory :user, class: User do
    name { Faker::Name.unique.name.downcase }
    email { name + '@gmail.com' }
    role 'OWNER'
    password { Faker::Internet.password }
  end
end
