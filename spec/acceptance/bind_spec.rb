require 'spec_helper_acceptance'

describe 'bind::server::conf' do

  describe 'running puppet code' do
    it 'should work with no errors' do
      pp = <<-EOS
        include bind
        bind::server::conf { '/etc/named.conf':
          listen_on_addr    => [ 'any' ],
          listen_on_v6_addr => [ 'any' ],
          forwarders        => [ '8.8.8.8', '8.8.4.4' ],
          allow_query       => [ 'localnets' ],
        }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file '/etc/bind.conf' do
      it { is_expected.to be_file }
      its(:content) { should match /8.8.8.8/ }
    end
  end
end
