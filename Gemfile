source 'http://rubygems.org'

gem 'rails', '3.2.2'
gem 'pg'
gem 'jquery-rails'
gem 'wash_out'
gem 'sass-rails',   '~> 3.2.3'
gem 'coffee-rails', '~> 3.2.1'
gem 'uglifier', '>= 1.0.3'
gem 'whenever', :require => false
gem 'eventmachine'
gem 'daemons-rails'

group :development do
  gem 'thin'
  gem 'annotate'  
  gem 'capistrano-deploy', :require => false
  gem "parallel_tests"
  gem 'savon'
end

group :development, :test do
  gem 'railroady'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'cucumber-rails', :require => false
  gem "rspec-rails"
  gem 'faker'
  gem 'capybara'
  gem "guid", "~> 0.1.1"
end

group :test do
  gem 'simplecov', :require => false
  gem "shoulda-matchers"
  gem "em-spec", "~> 0.2.6"
end

group :production do
  gem 'airbrake'
  gem 'therubyracer'
  gem 'unicorn', '>=3.2.1', :require => false
end

