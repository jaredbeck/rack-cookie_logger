# frozen_string_literal: true

module Rack
  module CookieLogger
    RSpec.describe Middleware do
      describe '#call' do
        context 'no cookies' do
          it 'logs the absence of cookies' do
            app = double(call: [
              200,
              ::Rack::Utils::HeaderHash.new,
              instance_double(::Rack::BodyProxy)
            ])
            middleware = described_class.new(app)
            logger = ::StringIO.new
            env = ::Rack::MockRequest::DEFAULT_ENV.merge(RACK_ERRORS => logger)
            middleware.call(env)
            expect(logger.string).to eq(
              <<~EOS
                CookieLogger: No request cookies
                CookieLogger: No response cookies
              EOS
            )
          end
        end

        context 'request cookies' do
          it 'logs the cookies' do
            app = double(call: [
              200,
              ::Rack::Utils::HeaderHash.new,
              instance_double(::Rack::BodyProxy)
            ])
            middleware = described_class.new(app)
            logger = ::StringIO.new
            env = ::Rack::MockRequest::DEFAULT_ENV.merge(
              HTTP_COOKIE => 'batter=flour; chip=chocolate',
              RACK_ERRORS => logger
            )
            middleware.call(env)
            expect(logger.string).to eq(
              <<~EOS
                CookieLogger: Request cookie: batter=flour
                CookieLogger: Request cookie: chip=chocolate
                CookieLogger: No response cookies
              EOS
            )
          end
        end

        context 'response cookies' do
          it 'logs the cookies' do
            cookies = [
              'timestamp=2021-01-14T20%3A19%3A37Z; domain=example.com; ' +
                'path=/; expires=Tue, 14 Jan 2121 20:19:37 GMT; HttpOnly; SameSite=Strict',
              'my_session=deadbeef; path=/; HttpOnly; SameSite=Strict'
            ]
            app = double(call: [
              200,
              ::Rack::Utils::HeaderHash.new(
                ::Rack::SET_COOKIE => cookies.join("\n")
              ),
              instance_double(::Rack::BodyProxy)
            ])
            middleware = described_class.new(app)
            logger = ::StringIO.new
            env = ::Rack::MockRequest::DEFAULT_ENV.merge(RACK_ERRORS => logger)
            middleware.call(env)
            redacted = 'my_session=dea.. (redacted); path=/; HttpOnly; SameSite=Strict'
            expect(logger.string).to eq(
              <<~EOS
                CookieLogger: No request cookies
                CookieLogger: Response cookie: #{cookies[0]}
                CookieLogger: Response cookie: #{redacted}
              EOS
            )
          end
        end
      end
    end
  end
end
