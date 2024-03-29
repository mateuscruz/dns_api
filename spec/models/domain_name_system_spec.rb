require "rails_helper"

describe DomainNameSystem, type: :model do
  context "associations" do
    it "has many hosts" do
      association_reflection = DomainNameSystem.reflect_on_association(:hosts)

      expect(association_reflection.macro).to eq(:has_many)
      expect(association_reflection.foreign_key).to eq('dns_id')
    end
  end

  context "validations" do
    describe "#address" do
      context "when empty" do
        it "is invalid" do
          dns = build(:dns, address: nil)

          expect(dns).not_to be_valid
          expect(dns.errors.messages.to_h).to include(address: [ "is invalid" ])
        end
      end

      context "when present" do
        context "when an invalid ip address" do
          it "is invalid" do
            dns = build(:dns, address: "12345678")

            expect(dns).not_to be_valid
            expect(dns.errors.messages.to_h).to include(address: [ "is invalid" ])
          end
        end

        context "when an valid ip address" do
          context "when there's another dns with the same address" do
            it "is invalid" do
              other_dns = create(:dns)
              dns       = build(:dns, address: other_dns.address)

              expect(dns).not_to be_valid
              expect(
                dns.errors.messages.to_h
              ).to include(address: [ "has already been taken" ])
            end
          end

          context "when there's no other dns with the same address" do
            it "is valid" do
              dns = build(:dns, address: "192.168.0.1")

              expect(dns).to be_valid
            end
          end
        end
      end
    end
  end
end
