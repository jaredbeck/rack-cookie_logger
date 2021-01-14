require_relative 'lib/rack/cookie_logger/version'

Gem::Specification.new do |spec|
  spec.name = "rack-cookie_logger"
  spec.version = Rack::CookieLogger::VERSION
  spec.authors = ["Jared Beck"]
  spec.email = ["jared@jaredbeck.com"]
  spec.license = 'AGPL-3.0-or-later'
  spec.summary = 'Logs cookies in rack (eg. rails) applications'
  spec.homepage = 'https://github.com/jaredbeck'
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  spec.files = [
    'LICENSE.txt',
    'lib/rack/cookie_logger.rb',
    'lib/rack/cookie_logger/middleware.rb',
    'lib/rack/cookie_logger/version.rb'
  ]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'rack', '~> 2.2'
end
