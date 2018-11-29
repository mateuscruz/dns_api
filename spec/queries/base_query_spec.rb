require "rails_helper"

describe BaseQuery do
  describe ".call" do
    it "calls instance.call" do
      expect_any_instance_of(BaseQuery).to receive(:call)

      BaseQuery.()
    end
  end

  describe "#call" do
    it "raises NotImplementedError" do
      instance = BaseQuery.new

      expect { instance.call }.to raise_error(NotImplementedError)
    end
  end
end
