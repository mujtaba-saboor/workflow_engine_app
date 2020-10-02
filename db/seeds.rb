require 'faker'

def debug(msg)
puts '+++++++++++++++++++++++++++'
puts msg
puts '+++++++++++++++++++++++++++'
end

description = 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type'

debug('Cleaning')
DatabaseCleaner.clean_with(:truncation)

debug('Company')
# Creating Company
company = Company.create(name: '7vals', subdomain: '7vals')

# set current tenant
Company.current_id = company.id

debug('Owner')
# Creating Owner
owner = User.create( name: 'Admin', role: 'OWNER',
email: 'owner@7vals.com',
password: '123456789',
company_id: 1, confirmed_at: Date.today)

debug('Admin')
# Creating Admin
owner = User.create( name: 'Admin', role: 'ADMIN',
email: 'admin@7vals.com',
password: '123456789',
company_id: 1, confirmed_at: Date.today)

debug('Staff')

# Creating 9 Members
1.upto(9) do |i|
  User.create( name: "Staff#{i}",
  email: "staff#{i}@7vals.com",
  role: 'STAFF',
  password: '123456789',
  company_id: company.id, confirmed_at: Date.today)
end

debug('Teams')
1.upto(10) do |i|
  team = Team.create(name: "Team#{i}", company_id: company.id)
  5.times do
    user = User.find(1+rand(10))
    team.users << user unless team.users.ids.include?(user.id)
  end
  # team.team_memberships.first.update(is_team_admin: true)
end
# TeamMembership.update_all(is_approved: true)

debug('Projects and Issues')
# Creating 10 Projects each having 9 issues, total 90 issues
1.upto(10) do |i|
  project = Project.create(name: Faker::Company.buzzword.titleize, project_category: 'INDEPENDENT',
  company_id: company.id)
  3.times do
    begin
      project.users << User.find(2 + rand(9))
      rescue Exception
    end
  end
end

1.upto(10) do |i|
  project = Project.create(name: Faker::Company.buzzword.titleize, project_category: 'TEAM',
  company_id: company.id)
  3.times do
    begin
      project.teams << Team.find(2 + rand(9))
      rescue Exception
    end
  end
  1.upto(9) do |j|
    Issue.create(
      title: Faker::Company.buzzword.titleize, description: description,
      company_id: company.id, creator_id: owner.id,
      assignee_id: User.find(1 + rand(9)).id,
      project_id: project.id,
      priority: 'low',
      issue_type: 'bug'
    )
  end
end

debug('Issue Watchers')
50.times do
  issue = Issue.find(1+rand(30))
  user = User.find(1+rand(10))
  unless Watcher.find_by(issue_id: issue.id, user_id: user.id)
    Watcher.create(user_id: user.id, issue_id: issue.id, company_id: company.id)
  end
end
