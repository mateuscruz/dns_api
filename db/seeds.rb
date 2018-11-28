# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

domains = {
  "1.1.1.1" => [ "lorem.com", "ipsum.com", "dolor.com", "amet.com" ],
  "2.2.2.2" => [ "ipsum.com" ],
  "3.3.3.3" => [ "ipsum.com", "dolor.com", "amet.com" ],
  "4.4.4.4" => [ "ipsum.com", "dolor.com", "sit.com", "amet.com" ],
  "5.5.5.5" => [ "dolor.com", "sit.com" ],
}

domains.each do |address, hostnames|
  dns = DomainNameSystem.create!(address: address)
  hostnames.each { |name| dns.hosts.create(name: name) }
end
