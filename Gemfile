source 'https://rubygems.org'

ruby '2.1.1'

gem 'rails', '4.1.1'
gem 'pg', '0.17.1'
# Use SCSS for stylesheets
gem 'sass-rails', '4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '2.5.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', '0.12.1', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '3.1.0'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '2.2.2'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '2.0.7'

# Use ActiveModel has_secure_password
gem 'bcrypt', '3.1.7'

# Use unicorn as the app server
gem 'unicorn', '4.8.3'

# fix security issue https://www.ruby-lang.org/en/news/2014/03/29/heap-overflow-in-yaml-uri-escape-parsing-cve-2014-2525/
# gem 'psych', '2.0.5'

gem 'http_accept_language', '2.0.1'

group :production do
  gem 'dotenv-deployment', '0.0.2'
end

group :development, :production do
  gem 'rails_stdout_logging', '0.0.3'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '~> 0.4.0'
end

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 1.1'
  gem 'spring-commands-rspec', '~> 1.0'

  gem 'foreman', '~> 0.64'
  gem 'better_errors', '~> 1.1'
  gem 'binding_of_caller', '~> 0.7'

  # Use Capistrano for deployment
  gem 'capistrano-rails', '~> 1.1'
end

group :test do
  gem 'timecop', '~> 0.7'
  gem 'webmock', '~> 1.17'
  gem 'vcr', '~> 2.9'
  # require: false because of https://github.com/rspec/rspec-rails/pull/772#issuecomment-35805617
  gem 'shoulda-matchers', '~> 2.6', require: false
  gem 'codeclimate-test-reporter', '~> 0.3', require: nil
end

group :development, :test do
  gem 'awesome_print', '~> 1.2'
  gem 'rspec-rails', '~> 2.14'
  gem 'factory_girl_rails', '~> 4.4'
  gem 'fuubar', '~> 1.3'
  gem 'pry-debugger', '~> 0.2.2'
  gem 'pry-remote', '~> 0.1'
end
