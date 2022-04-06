source "https://rubygems.org"

# Specify your gem's dependencies in toribaveiculos.gemspec
gem 'f1sales_custom-email', github: 'marciok/f1sales_custom-email', branch: 'master'
gem 'f1sales_custom-hooks', github: 'marciok/f1sales_custom-hooks', branch: 'master'
gem 'f1sales_helpers', github: 'f1sales/f1sales_helpers', branch: 'master'
 
gemspec

gem 'http'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "rspec", "~> 3.0"
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'webmock'
end