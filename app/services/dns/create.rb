module Dns
  class Create
    class Result
      attr_reader :errors
      attr_accessor :record

      def initialize
        @errors = {}
      end

      def success?
        errors.empty?
      end

      def failure?
        !success?
      end
    end

    def self.call(*args)
      new(*args).call
    end

    def initialize(params)
      @params = params
      @hosts  = []
      @result = Result.new
    end

    def call
      ActiveRecord::Base.transaction do
        create_dns
        create_hosts
      end
      result
    rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
      result.errors.merge!(dns.errors.messages)
      result.errors.merge!(hosts: hosts.map { |host| host.errors.messages })
      result
    end

    private

    attr_reader :params, :dns, :hosts, :result

    def create_dns
      @dns          = DomainNameSystem.new(dns_params)
      result.record = dns
      dns.save!
    end

    def create_hosts
      @hosts = hosts_params.map do |host_params|
        host = Host.new(host_params)
      end

      hosts.map(&:save!)
    end

    def dns_params
      params.slice(:address)
    end

    def hosts_params
      params.fetch(:hosts, []).map { |host_params| host_params.merge(dns: dns) }
    end
  end
end
