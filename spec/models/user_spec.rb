require 'rails_helper'

RSpec.describe User, type: :model do
  context 'user validation tests' do
    it 'ensure email presence' do
      Company.new(name: '7vals', subdomain: '7vals').save
      user = User.new(name: 'Hammad', password: '123456', role: 'OWNER', company: Company.first).save
      expect(user).to eq(false)
    end

    it 'ensure password presence' do
      Company.new(name: '7vals', subdomain: '7vals').save
      user = User.new(name: 'Hammad', email: 'hammad@gmail.com', role: 'OWNER', company: Company.first).save
      expect(user).to eq(false)
    end

    it 'ensure default role presence' do
      Company.new(name: '7vals', subdomain: '7vals').save
      user = User.new(name: 'Hammad', email: 'hammad@gmail.com', password: '123456', company: Company.first)
      expect(user.role).to eq('STAFF')
    end

    it 'ensure company presence' do
      expect{User.new(name: 'Hammad', email: 'hammad@gmail.com', password: '123456', role: 'OWNER').save}.to raise_exception
    end
  end

  context 'user scope tests' do
    it 'ensure same company users' do
      Company.new(name: '7vals', subdomain: '7vals').save
      User.new(name: 'Hammad', email: 'hammad@gmail.com', password: '123456', role: 'OWNER', company: Company.first).save
      User.new(name: 'Usman', email: 'usman@gmail.com', password: '123456', role: 'STAFF', company: Company.first).save
      User.new(name: 'Haidar', email: 'haidar@gmail.com', password: '123456', role: 'STAFF', company: Company.first).save
      User.new(name: 'Mujeeb', email: 'mujeeb@gmail.com', password: '123456', role: 'ADMIN', company: Company.first).save
      expect(Company.first.users.size).to eq(4)
    end
  end
end
