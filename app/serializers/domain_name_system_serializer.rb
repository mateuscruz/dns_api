class DomainNameSystemSerializer < ActiveModel::Serializer
  attributes :id, :address

  has_many :hosts
end
