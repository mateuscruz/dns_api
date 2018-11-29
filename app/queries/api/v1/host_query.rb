module Api
  module V1
    class HostQuery < BaseQuery
      def initialize(relation:, excluded: [])
        @relation = relation
        @excluded = excluded
      end

      def call
        result = Host.where(dns_id: relation.select(:id))
        result = result.where.not(name: excluded) if excluded.present?
        result.group(:name).select("hosts.*", "COUNT(DISTINCT dns_id) AS dns_count")
      end

      private

      attr_reader :relation, :excluded
    end
  end
end
