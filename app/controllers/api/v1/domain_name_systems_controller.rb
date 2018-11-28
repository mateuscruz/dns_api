class Api::V1::DomainNameSystemsController < ApplicationController
  def index
    @domains = DomainNameSystem.eager_load(:hosts).joins(:hosts)

    render json: @domains
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

  def create_params
    params
      .require(:domain_name_system)
      .permit(:address)
      .merge(hosts: host_params)
  end

  def host_params
    params.fetch(:hosts, []).map { |host_params| host_params.permit(:name) }
  end
end
