namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'ffaker'
    [User].each(&:delete_all)
    
    User.populate 130 do |person|
      person.name    = Faker::Name.name
      person.email   = Faker::Internet.email
			person.password_digest = "password"
			person.role_id = 3
			person.active  = false
    end
  end
end
