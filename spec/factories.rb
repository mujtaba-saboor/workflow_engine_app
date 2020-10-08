require 'faker'

FactoryGirl.define do

  factory :company, class: Project do
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
end
