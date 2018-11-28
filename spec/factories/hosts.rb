FactoryBot.define do
  factory :host do
    association :dns
    sequence(:name) { |n| "domain#{n}.com" }
  end
end
