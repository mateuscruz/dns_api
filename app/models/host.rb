class Host < ApplicationRecord
  belongs_to :dns, class_name: "DomainNameSystem"

  # Adapted from https://github.com/johno/domain-regex/blob/master/index.js
  DOMAIN_FORMAT = /((?=[a-z0-9-]{1,63}\.)(xn--)?[a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,63}/

  validates :name, format: { with: DOMAIN_FORMAT }, uniqueness: { scope: :dns_id }
end
