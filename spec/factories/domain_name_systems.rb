FactoryBot.define do
  factory :domain_name_system, aliases: [ :dns ] do
    sequence(:address) do |n|
      n.to_s(2).rjust(32, "0").scan(/\d{8}/).map{ |n| n.to_i(2) }.join(".")
    end
  end
end
