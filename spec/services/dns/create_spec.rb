require "rails_helper"

describe Dns::Create do
  subject(:service) { described_class }

  describe ".call" do
    context "when dns params are invalid" do
      it "fails" do
        params = {
          address: nil,
          hosts: [],
        }

        result = service.(params)

        expect(result).to be_failure
        expect(result.errors).to have_key(:address)
      end
    end

    context "when dns params are valid" do
      context "when hosts params are invalid" do
        it "fails" do
          params = {
            address: "192.168.0.1",
            hosts: [ { name: "invalid_name" }],
          }

          result = service.(params)

          expect(result).to be_failure
          expect(result.errors[:hosts]).to match_array([ have_key(:name) ])
        end
      end

      context "when hosts params are valid" do
        it "succeeds" do
          params = {
            address: "192.168.0.1",
            hosts: [ { name: "example.com" } ],
          }

          result = service.(params)

          expect(result).to be_success
          expect(result.record).not_to be_nil
        end

        it "creates a DNS record" do
          params = {
            address: "192.168.0.1",
            hosts: [ { name: "example.com" } ],
          }

          expect { service.(params) }.to change(DomainNameSystem, :count).by(1)
        end

        it "creates a host record for each host param" do
          params = {
            address: "192.168.0.1",
            hosts: [ { name: "example.com" } ],
          }

          expect { service.(params) }.to change(Host, :count).by(1)
        end
      end
    end
  end
end
