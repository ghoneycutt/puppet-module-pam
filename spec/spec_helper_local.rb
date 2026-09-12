# frozen_string_literal: true

require 'json'

# Absolute path to a file under spec/fixtures. Previously provided by
# puppetlabs_spec_helper, which this module no longer uses.
def fixtures(path)
  File.expand_path(File.join('fixtures', path), __dir__)
end
