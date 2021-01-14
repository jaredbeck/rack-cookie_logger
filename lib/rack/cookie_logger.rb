require "rack"
require "rack/cookie_logger/middleware"
require "rack/cookie_logger/version"

module Rack
  module CookieLogger
    class Error < StandardError; end
  end
end
