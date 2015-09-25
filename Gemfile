source "https://rubygems.org"

group :development, :test do
  # pin ruby dependencies to specific gem versions
  # newer versions not supported by version 1.8.7
  gem 'mime-types', '1.25.1' if RUBY_VERSION == '1.8.7'
  gem 'rest-client', '1.6.9' if RUBY_VERSION == '1.8.7'
  gem 'r10k', '1.5.1' if RUBY_VERSION == '1.8.7'
  gem 'puppet-blacksmith', '3.1.0' if RUBY_VERSION == '1.8.7'

  gem 'bodeco_module_helper', :git => 'https://github.com/bodeco/bodeco_module_helper.git'
  gem 'yard'
  gem 'faraday'
  gem 'faraday_middleware'
  gem 'rspec-puppet-utils'
end
