module Api
  module V1
    class DnsQuery < BaseQuery
      class Result
        attr_reader :domains, :hosts

        def initialize(domains: , hosts:)
          @domains = domains
          @hosts   = hosts
        end
      end

      def initialize(included: [], excluded: [], page: 1)
        @included = included
        @excluded = excluded
        @page     = page
        @domains  = DomainNameSystem.left_joins(:hosts)
      end

      def call
        fetch_domains

        Result.new(domains: domains, hosts: hosts)
      end

      private

      attr_reader :included, :excluded, :domains, :hosts, :page

      def fetch_domains
        filter_included_hostnames
        filter_excluded_hostnames
        remove_duplicates
        paginate
        fetch_hosts
      end

      def filter_included_hostnames
        @domains = included.inject(domains) do |items, hostname|
          items.where(id: dns_ids_for(hostname))
        end
      end

      def filter_excluded_hostnames
        @domains = excluded.inject(domains) do |items, hostname|
          items.where.not(id: dns_ids_for(hostname))
        end
      end

      def remove_duplicates
        @domains = domains.distinct(:id)
      end

      def fetch_hosts
        @hosts = HostQuery.(relation: domains, excluded: excluded)
      end

      def paginate
        @domains = domains.page(page)
      end

      def dns_ids_for(hostname)
        Host.where(name: hostname).select(:dns_id)
      end
    end
  end
end
