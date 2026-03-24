source "https://rubygems.org"

gem "rails", "~> 8.1.1"
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "jbuilder"

# Authentication
gem "devise"

# Authorization
gem "pundit"

# Pagination
gem "kaminari"
gem "pagy", "~> 9.0"

# Friendly URLs / slugs
gem "friendly_id", "~> 5.5.0"

# Image processing for Active Storage
gem "image_processing", "~> 1.2"

# SEO meta tags
gem "meta-tags"

# Password hashing
gem "bcrypt", "~> 3.1.22"

# Windows timezone support
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Boot time optimization
gem "bootsnap", require: false

# Deployment
gem "kamal", require: false
gem "thruster", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "bundler-audit", require: false
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "faker"
end

group :development do
  gem "web-console"
  gem "better_errors"
  gem "binding_of_caller"
  gem "annotaterb"
end
