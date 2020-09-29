RSpec.configure do |config|
  # Use facterdb facts for facter 3.x rather than
  # facterdb for detected facter gem version which would be 2.x
  config.default_facter_version = '3.11.9'
end
