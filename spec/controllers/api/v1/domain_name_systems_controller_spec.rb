require "rails_helper"

describe Api::V1::DomainNameSystemsController, type: :controller do
  describe "#index" do
    it "succeeds" do
      dns      = create(:dns)
      host     = create(:host, dns: dns)
      metadata = { total: 1 }

      get :index, params: { page: 1 }

      expect(response.status).to eq(200)
    end

    context "when page param is missing" do
      it "fails" do
        get :index

        expect(response.status).to eq(400)
      end
    end
  end

  describe "#create" do
    context "when params are valid" do
      it "creates a dns with hostnames" do
        mocked_result = double(success?: true, errors: {}, record: double(id: 1))
        allow(Dns::Create).to receive(:call).and_return(mocked_result)
        params = {
          domain_name_system: attributes_for(:dns).merge(hosts: [ attributes_for(:host) ])
        }
        post :create, params: params

        expect(Dns::Create).to have_received(:call)
        expect(
          JSON(response.body)
        ).to eq("success" => true, "errors" => {}, "id" => 1)
      end
    end

    context "when params are invalid" do
      it "does not create a dns" do
        mocked_result = double(success?: false, errors: { foo: [ "bar" ] },
          record: double(id: nil))
        allow(Dns::Create).to receive(:call).and_return(mocked_result)
        params = {
          domain_name_system: attributes_for(:dns).merge(hosts: [ attributes_for(:host) ])
        }
        post :create, params: params

        expect(Dns::Create).to have_received(:call)
        expect(
          JSON(response.body)
        ).to eq("success" => false, "errors" => { "foo" => [ "bar" ] }, "id" => nil)
      end
    end
  end
end
