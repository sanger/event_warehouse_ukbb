source 'https://rubygems.org'

# TODO: We pretty much just use active record and active mailer, do we need rails?
gem "rails", "~> 4.2"
gem "mysql2"

# TODO: COnsider switching to Bunny if possible
gem "amqp", "~> 1.5"

# Replaces use of lib/uuidable.rb as the latter was provind to
# be a bit brittle. Allows use of binary uuid columns.
gem 'activeuuid'

# We use a special version of hashie to bypass rails protected attributes.
# Consider removing Hashie entirely
gem "hashie-forbidden_attributes"
gem "rest-client"
gem "migration_comments"

group :test, :development do
  gem 'rspec-rails', '~> 3.1'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'pry'
end

group :development do
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rspec'
end

group :deployment do
  gem "psd_logger", :git => "git+ssh://git@github.com/sanger/psd_logger.git"
end
