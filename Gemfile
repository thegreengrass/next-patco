# Force the `github:` syntax to use HTTPS instead of the Git protocol.
# The Git protocol isn't encrypted, and so is subject to MITM attacks.
# This can be removed once Heroku switches to Bundler 2.0.
# https://github.com/bundler/bundler/pull/2569
# You can view the current Heroku Bundler version at
# https://devcenter.heroku.com/articles/ruby-support#libraries.
git_source :github do |repo|
  repo = "#{repo}/#{repo}" unless repo.include? '/'
  "https://github.com/#{repo}.git"
end

source 'https://rubygems.org'

ruby "2.4.0"
gem 'rails', '~>4.0'
gem 'foreman'
gem 'sprockets-rails', :require => 'sprockets/railtie'
gem 'protected_attributes', github: 'rails/protected_attributes'
gem 'jquery-rails', github: 'rails/jquery-rails'
gem "bootstrap", ">= 4.3.1"
gem 'sass-rails'
gem 'uglifier'
gem "sqlite3", "~> 1.3.6"

# Use Capistrano for deployment
group :development do
  gem 'capistrano', '~> 3.6'
  gem 'capistrano-rails', '~> 1.2'
  gem 'capistrano-rvm'
  gem 'capistrano-passenger'
end
