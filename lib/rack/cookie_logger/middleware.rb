# frozen_string_literal: true

module Rack
  module CookieLogger
    # Logs:
    #
    # - request cookies (the `Cookie:` header)
    # - response cookies (the `Set-Cookie:` header)
    class Middleware
      LOG_PREFIX = 'CookieLogger: '

      # TODO: Make these configurable
      SENSITIVE_COOKIE_SUFFIXES = [
        'session',
        'credentials',
        'password',
        'token'
      ].freeze

      def initialize(app)
        @app = app
      end

      def call(env)
        @logger = env[::Rack::RACK_ERRORS]
        log_request_cookies(::Rack::Request.new(env))
        status, headers, body = @app.call(env)
        log_response_cookies(::Rack::Response.new([], status, headers))
        [status, headers, body]
      end

      private

      def log(message)
        @logger << (LOG_PREFIX + message + "\n")
      end

      def log_request_cookies(req)
        cookies = req.cookies
        if cookies.empty?
          log 'No request cookies'
        else
          cookies.each do |name, value|
            v = log_value(name, value)
            log('Request cookie: ' + [name, v].join('='))
          end
        end
      rescue StandardError => e
        warn 'Error logging request cookies: ' + e.full_message
      end

      def log_response_cookies(rsp)
        sc_header = rsp.headers[::Rack::SET_COOKIE]
        if sc_header.nil?
          log 'No response cookies'
        else
          sc_header.split("\n").each do |cookie|
            left, *attrs = cookie.split(';')
            name, value = left.split('=')
            v = log_value(name, value)
            log 'Response cookie: ' + [name, v].join('=') + ';' + attrs.join(';')
          end
        end
      rescue StandardError => e
        warn 'Error logging response cookies: ' + e.full_message
      end

      def log_value(name, value)
        if sensitive?(name)
          redact(value)
        else
          value
        end
      end

      # `value` can be `nil` when clearing a cookie. Some applications set the
      # cookie value to the empty string instead of, or in addition to, setting
      # an expiration date in the past.
      def redact(value)
        # return if value.nil?
        value[0, 3] + '.. (redacted)'
      end

      def sensitive?(name)
        SENSITIVE_COOKIE_SUFFIXES.any? { |suffix| name.end_with?(suffix) }
      end
    end
  end
end
