require "rails_helper"

describe DomainNameSystemSerializer do
  before do
    @dns  = create(:dns)
    @host = create(:host, dns: @dns)
    @serializer = DomainNameSystemSerializer.new(@dns.reload)
    @adapter    = ActiveModelSerializers::Adapter.create(@serializer)
  end

  describe "data" do
    let(:data) { @adapter.as_json[:data] }

    it "has type 'domain-name-systems'" do
      expect(data[:type]).to eq('domain-name-systems')
    end

    it "has id" do
      expect(data[:id]).to eq(@dns.id.to_s)
    end

    it "has address attribute" do
      expect(data.dig(:attributes, :address)).to eq(@dns.address)
    end

    describe "relationships data" do
      let(:relationships) { data[:relationships] }

      it "has hosts attributes" do
        hosts = relationships.dig(:hosts, :data)

        expect(hosts).to match_array([ { id: @host.id.to_s, type: "hosts" } ])
      end
    end
  end
end
