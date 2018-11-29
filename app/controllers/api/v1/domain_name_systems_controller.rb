module Api
  module V1
    class DomainNameSystemsController < ApplicationController
      rescue_from ActionController::ParameterMissing do
        render :nothing => true, :status => :bad_request
      end

      def index
        result = DnsQuery.(included: hostnames, excluded: excluded_hostnames, page: page)

        domains = result.domains
        hosts   = result.hosts

        render json: {
          domains: ActiveModel::Serializer::CollectionSerializer.new(domains, each_serializer: DomainNameSystemSerializer),
          hosts: ActiveModel::Serializer::CollectionSerializer.new(hosts, each_serializer: HostSerializer),
          meta: { total: domains.count, page: page }
        }
      end

      def create
        result = Dns::Create.(create_params)

        render json: {
          success: result.success?,
          errors: result.errors,
          id: result.record.id
        }
      end

      private

      def hostnames
        filter_params.fetch(:hostnames, [])
      end

      def excluded_hostnames
        filter_params.fetch(:excluded_hostnames, [])
      end

      def filter_params
        params.slice(:hostnames, :excluded_hostnames)
      end

      def create_params
        params
          .require(:domain_name_system)
          .permit(:address)
          .merge(hosts: host_params)
      end

      def host_params
        params.fetch(:hosts, []).map { |host_params| host_params.permit(:name) }
      end

      def page
        params.require(:page)
      end
    end
  end
end
