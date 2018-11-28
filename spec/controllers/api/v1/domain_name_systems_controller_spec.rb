require "rails_helper"

describe Api::V1::DomainNameSystemsController, type: :controller do
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
