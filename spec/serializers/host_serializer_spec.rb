require "rails_helper"

describe HostSerializer do
  before do
    @host = create(:host)
    @serializer    = HostSerializer.new(@host)
    @adapter       = ActiveModelSerializers::Adapter.create(@serializer)
  end

  describe "data" do
    subject(:data) { @adapter.as_json[:data] }

    it "has type 'hosts'" do
      expect(data[:type]).to eq("hosts")
    end

    it "has id" do
      expect(data[:id]).to eq(@host.id.to_s)
    end

    it "has address attribute" do
      expect(data.dig(:attributes, :name)).to eq(@host.name)
    end
  end
end
