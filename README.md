# Rack::CookieLogger

```ruby
# Gemfile
gem 'rack-cookie_logger'
# my_rails_app/config/application.rb
MyRailsApp::Application.config.middleware.insert_before(
  ::ActionDispatch::Cookies,
  ::Rack::CookieLogger::Middleware
)
```

## Contributing

Not accepting contributions at this time.
