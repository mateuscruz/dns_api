require "rails_helper"

describe Host, type: :model do
  context "associations" do
    it "belongs to dns" do
      association_reflection = Host.reflect_on_association(:dns)

      expect(association_reflection.macro).to eq(:belongs_to)
      expect(association_reflection.klass).to eq(DomainNameSystem)
    end
  end

  context "when validations" do
    describe "#dns" do
      context "when empty" do
        it "is invalid" do
          host = build(:host, dns: nil)

          expect(host).not_to be_valid
          expect(host.errors.messages).to include(dns: [ "must exist" ])
        end
      end

      context "when present" do
        it "is valid" do
          host = build(:host, dns: build(:dns))

          expect(host).to be_valid
        end
      end
    end

    describe "#name" do
      context "when empty" do
        it "is invalid" do
          host = build(:host, name: nil)

          expect(host).not_to be_valid
          expect(host.errors.messages).to include(name: [ "is invalid" ])
        end
      end

      context "when present" do
        context "when not a valid domain" do
          it "is invalid" do
            host = build(:host, name: "example.")

            expect(host).not_to be_valid
            expect(host.errors.messages).to include(name: [ "is invalid" ])
          end
        end

        context "when a valid domain" do
          context "when there's another host with same name for given dns" do
            it "is invalid" do
              other_host = create(:host)
              dns        = other_host.dns
              host       = build(:host, dns: dns, name: other_host.name)

              expect(host).not_to be_valid
              expect(host.errors.messages).to eq(name: [ "has already been taken" ])
            end
          end

          context "when there's not other host with same name for given dns" do
            it "is valid" do
              host = build(:host, name: "example.com")

              expect(host).to be_valid
            end
          end
        end
      end
    end
  end
end
