# frozen_string_literal: true

RSpec.configure do |c|
  c.mock_with :rspec
end

require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
require 'json'

require_relative 'spec_platforms'

include RspecPuppetFacts

default_facts = {
  puppetversion: Puppet.version,
  facterversion: Facter.version,
}

default_fact_files = [
  File.expand_path(File.join(File.dirname(__FILE__), 'default_facts.yml')),
  File.expand_path(File.join(File.dirname(__FILE__), 'default_module_facts.yml')),
]

default_fact_files.each do |f|
  next unless File.exist?(f) && File.readable?(f) && File.size?(f)
  begin
    default_facts.merge!(YAML.safe_load(File.read(f)))
  rescue => e
    RSpec.configuration.reporter.message "WARNING: Unable to load #{f}: #{e}"
  end
end

default_facts.each do |fact, value|
  add_custom_fact fact, value
end

module RspecPuppetFacts
  class << self
    def on_supported_os(_opts = {})
      matrix = {}
      facts_file = File.expand_path('../fixtures/facts/redhat-10-x86_64.json', __FILE__)

      raw_facts = if File.exist?(facts_file)
                    JSON.parse(File.read(facts_file))
                  else
                    {
                      'os' => {
                        'name' => 'RedHat',
                        'family' => 'RedHat',
                        'release' => { 'major' => '10', 'minor' => '0', 'full' => '10.0' }
                      },
                      'operatingsystem' => 'RedHat',
                      'operatingsystemrelease' => '10.0',
                      'operatingsystemmajrelease' => '10',
                      'osfamily' => 'RedHat',
                      'hardwaremodel' => 'x86_64',
                      'architecture' => 'x86_64'
                    }
                  end

      processed_facts = raw_facts.dup
      processed_facts[:os] = raw_facts['os'] if raw_facts['os']

      matrix['redhat-10-x86_64'] = processed_facts
      matrix
    end
  end

  def on_supported_os(opts = {})
    RspecPuppetFacts.on_supported_os(opts)
  end
end

RSpec.configure do |c|
  c.default_facts = default_facts
  c.hiera_config = 'spec/hiera.yaml'

  c.include RspecPuppetFacts

  c.before :each do
    Puppet.settings[:strict] = :warning
    Puppet.settings[:strict_variables] = true
    allow(self).to receive(:on_supported_os).and_return(RspecPuppetFacts.on_supported_os) if respond_to?(:allow)
  end

  c.filter_run_excluding(bolt: true) unless ENV['GEM_BOLT']
  c.after(:suite) do
    RSpec::Puppet::Coverage.report!(100)
  end

  backtrace_exclusion_patterns = [%r{spec_helper}, %r{gems}]
  if c.respond_to?(:backtrace_exclusion_patterns)
    c.backtrace_exclusion_patterns = backtrace_exclusion_patterns
  elsif c.respond_to?(:backtrace_clean_patterns)
    c.backtrace_clean_patterns = backtrace_exclusion_patterns
  end
end

def ensure_module_defined(module_name)
  module_name.split('::').reduce(Object) do |last_module, next_module|
    last_module.const_set(next_module, Module.new) unless last_module.const_defined?(next_module, false)
    last_module.const_get(next_module, false)
  end
end
