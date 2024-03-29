require File.expand_path('../../lib/config.rb', __FILE__)
require 'rspec'

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec
end

def fixture(file)
  ROOT("spec/fixtures/#{file}")
end
