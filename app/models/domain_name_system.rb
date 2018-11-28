class DomainNameSystem < ApplicationRecord
  HOST_FORMAT = "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)"

  validates :address, uniqueness: true, format: {
    with: /#{HOST_FORMAT}(\.#{HOST_FORMAT}){3}/
  }
end


