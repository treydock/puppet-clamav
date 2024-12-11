require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

unless ENV['BEAKER_provision'] == 'no'
  expect([hosts]).to all(install_puppet)
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    hosts.each do |host|
      # Install module and dependencies
      copy_module_to(host, source: proj_root, module_name: 'clamav')
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), acceptable_exit_codes: [0, 1]

      if fact('os.family') == 'RedHat'
        on host, puppet('module', 'install', 'puppet-epel'), acceptable_exit_codes: [0, 1]
      end
    end
  end
end
