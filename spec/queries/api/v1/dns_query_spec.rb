require "rails_helper"

describe Api::V1::DnsQuery do
  subject(:query) { described_class }

  describe ".call" do
    before do
      # Hostnames for dns1
      @dns1      = create(:dns)
      @hostname1 = create(:host, dns: @dns1, name: "lorem.com")
      @hostname2 = create(:host, dns: @dns1, name: "ipsum.com")
      @hostname3 = create(:host, dns: @dns1, name: "dolor.com")
      @hostname4 = create(:host, dns: @dns1, name: "amet.com")

      # Hostnames for dns2
      @dns2      = create(:dns)
      @hostname5 = create(:host, dns: @dns2, name: "ipsum.com")

      # Hostnames for dns3
      @dns3      = create(:dns)
      @hostname6 = create(:host, dns: @dns3, name: "ipsum.com")
      @hostname7 = create(:host, dns: @dns3, name: "dolor.com")
      @hostname8 = create(:host, dns: @dns3, name: "amet.com")

      # Hostnames for dns4
      @dns4       = create(:dns)
      @hostname9  = create(:host, dns: @dns4, name: "ipsum.com")
      @hostname10 = create(:host, dns: @dns4, name: "dolor.com")
      @hostname11 = create(:host, dns: @dns4, name: "sit.com")
      @hostname12 = create(:host, dns: @dns4, name: "amet.com")

      # Hostnames for dns5
      @dns5       = create(:dns)
      @hostname13 = create(:host, dns: @dns5, name: "dolor.com")
      @hostname14 = create(:host, dns: @dns5, name: "sit.com")
    end

    context "when included hostnames are not given" do
      context "when excluded hostnames are not given" do
        it "returns all records" do
          expected_domains = [ @dns1, @dns2, @dns3, @dns4, @dns5 ]

          result = query.()

          expect(result.domains).to match_array(expected_domains)
        end
      end
    end

    context "when included hostnames are given" do
      context " when excluded hostnames are not given" do
        it "returns records that have hostnames that match given ones" do
          expected_domains = [ @dns1, @dns3, @dns4 ]
          expected_hosts = {
            "lorem.com" => 1,
            "ipsum.com" => 3,
            "dolor.com" => 3,
            "amet.com" => 3,
            "sit.com" => 1,
          }

          result = query.(included: [ "ipsum.com", "dolor.com" ])

          hosts = result.hosts.inject({}) do |acc, host|
            acc.merge({ host.name => host.dns_count })
          end
          expect(result.domains).to match_array(expected_domains)
          expect(hosts).to eq(expected_hosts)
        end
      end

      context " when excluded hostnames are given" do
        it "returns records that have hostnames that match given included ones but don't match given excluded ones" do
          expected_domains = [ @dns1, @dns3 ]
          expected_hosts = {
            "lorem.com" => 1,
            "ipsum.com" => 2,
            "dolor.com" => 2,
            "amet.com" => 2,
          }

          result = query.(included: [ "ipsum.com", "dolor.com" ],
            excluded: [ "sit.com" ] )

          hosts = result.hosts.inject({}) do |acc, host|
            acc.merge({ host.name => host.dns_count })
          end
          expect(result.domains).to match_array(expected_domains)
          expect(hosts).to eq(expected_hosts)
        end
      end
    end

    context "when excluded hostnames are given" do
      context "when included hostnames are not given" do
        it "returns records that don't have hostnames that match given ones" do
          expected_domains = [ @dns1, @dns2, @dns3 ]
          expected_hosts = {
            "lorem.com" => 1,
            "ipsum.com" => 3,
            "dolor.com" => 2,
            "amet.com" => 2,
          }

          result = query.(excluded: [ "sit.com" ])

          hosts = result.hosts.inject({}) do |acc, host|
            acc.merge({ host.name => host.dns_count })
          end
          expect(result.domains).to match_array(expected_domains)
          expect(hosts).to eq(expected_hosts)
        end
      end
    end
  end
end
