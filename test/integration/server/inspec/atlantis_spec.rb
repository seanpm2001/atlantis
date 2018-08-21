# frozen_string_literal: true

atlantis_bin = '/usr/local/bin/atlantis/atlantis'

describe file(atlantis_bin) do
  it { should exist }
  its('type') { should eq :file }
  it { should_not be_directory }
  it { should be_executable }
  # to get the latest sha you should download the zip archive and extract it
  # if needed you may have to install `coreutils` (package name for deb derivitives)
  # root@dokken:/# sha256sum /usr/local/bin/atlantis/atlantis
  # c094def53949d658bb3ead360b86a432e3cc48609252621da7855f7fc7f0d136  /usr/local/bin/atlantis/atlantis
  its('sha256sum') { should eq 'c094def53949d658bb3ead360b86a432e3cc48609252621da7855f7fc7f0d136' }
end

describe command("#{atlantis_bin} version") do
  its('stdout') { should match(/(atlantis)\s([0-9]+\.){2}[0-9+]/) }
  its('exit_status') { should eq 0 }
end


describe file('/etc/atlantis.yml'), :sensitive do
  it { should exist }
  its('group') { should eq 'atlantis' }
  its('mode') { should cmp '0600' }
end

describe yaml('/etc/atlantis.yml'), :sensitive do
  its('atlantis-url') { should eq 'https://localhost:4141' }
  its('allow-repo-config') { should eq false }
  its('github-user') { should eq 'my-atlantis-bot'}
  its('github-token') { should eq 'A_GITHUB_TOKEN' }
  its('github-webhook-secret') { should eq 'A_GITHUB_WEBHOOK_SECRET' }
  its('log-level') { should eq 'INFO' }
  its('port') { should eq 4141 }
  its('require-approval') { should eq true }
end
