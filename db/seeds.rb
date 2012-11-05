#Predefined roles
['superadmin','admin','user'].each do |role|
  Role.find_or_create_by_name({:name => role, :description => role})
end

superadmin_role = Role.find_by_name('superadmin')

superadmin  = User.find_or_create_by_email({:name => 'Administrator', :email => 'admin@example.com',
                              :password => 'Q!~234#Z$',
                              :password_confirmation => 'Q!~234#Z$'})

superadmin.role_id = superadmin_role.id
superadmin.save
