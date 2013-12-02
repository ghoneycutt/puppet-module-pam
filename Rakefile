require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp"]

desc "Run puppet in noop mode and check for syntax errors."
task :validate do
  Dir['manifests/**/*.pp'].each do |path|
    sh "puppet parser validate --noop #{path}"
  end
  Dir['spec/**/*.rb','lib/**/*.rb'].each do |spec_path|
    sh "ruby -c #{spec_path}" unless spec_path =~ /spec\/fixtures/
  end
  Dir['templates/**/*.erb'].each do |template|
    sh "erb -P -x -T '-' #{template} | ruby -c"
  end
end
