require Rails.root.to_s +  '/lib/sahi'

admin_id = Role.find_or_create_by_name('admin').id
@user    = User.find_or_initialize_by_email({:email => 'james@example.com',
                              :name => 'james', :password => 'james@1234',
                              :password_confirmation => 'james@1234' })
@user.role_id = admin_id
@user.save
@user.update_attribute(:active, true)

browser = Sahi::Browser.new("chrome")
browser.open
home_page = "http://localhost:3000"

at_exit do
  browser.close
end

Given /^I logged in  as 'admin'$/ do
  browser.navigate_to(home_page)
  browser.textbox("email").value   = 'james@example.com'
  browser.password("password").value = 'james@1234'
  browser.submit("Sign In").click
end

When /^I follow devices page$/ do
  browser.navigate_to('/admin/devices')
end

Given /^I am on devices page$/ do
  browser.navigate_to('/admin/devices')
end


Then /^I should see the devices with imei and registered date sorted by  imei$/ do
  browser.tableHeader("IMEI").exists?.should be_true
  browser.tableHeader("Registered Date").exists?.should be_true
  browser.row(1).text.include?("123456789012341").should be_true
  browser.row(3).text.include?("123456789012345").should be_true
end

Given /^following devices exists$/ do |table|
  table.hashes.each do |hash|
    Device.create(hash)
  end
end

Then /^I should see the devices are sorted by imei$/ do
  browser.row(1).text.include?("123456789012341").should be_true
  browser.row(3).text.include?("123456789012345").should be_true
end

Given /^(\d+) devices exists$/ do |total|
  total.to_i.times do |t|
    Device.create(:imei => '1234567890123' + (10 + t).to_s, :registered_date => '11/12/2012')
  end
end

Then /^I should see (\d+) devices in first page$/ do |total|
  info = browser.div("devices-datatable_info").text
  info.include?("Showing 1 to 10").should be_true
end

Then /^I should see pagination with links for (\d+) pages$/ do |total|
  browser.fetch("$('li.next').prev().find('a').html()").should match total
end
