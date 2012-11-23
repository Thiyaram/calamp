source 'http://rubygems.org'

gem 'rails', '3.2.8'
gem 'pg'
gem 'jquery-rails'
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'simple_form'
gem 'american_date'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'therubyracer', '~> 0.10.2',  :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
  gem 'twitter-bootstrap-rails', :git => 'https://github.com/seyhunak/twitter-bootstrap-rails.git'
end

group :development do
  gem 'thin'
  gem 'annotate', :git => 'https://github.com/ctran/annotate_models.git'
  gem 'capistrano-deploy', :require => false
  gem "parallel_tests"
  gem 'savon'
  gem 'bullet'
  gem 'brakeman'
	gem 'populator'
end

group :udp do
  gem 'whenever', :require => false
  gem 'eventmachine'
  gem 'daemons-rails'
  gem 'wash_out'
end

group :development, :test do
  gem 'railroady'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'cucumber-rails', :require => false
  gem "rspec-rails", "~> 2.0"
  gem 'ffaker'
  gem 'capybara'
  gem "guid", "~> 0.1.1"
  gem 'rails_best_practices'
end

group :test do
  gem 'mysql2'
  gem 'simplecov', :require => false
  gem "shoulda-matchers"
  gem "em-spec", "~> 0.2.6"
  gem "guid", "~> 0.1.1"   #for sahi
end

group :production do
  gem 'airbrake'
  gem 'unicorn', '>=3.2.1', :require => false
end
