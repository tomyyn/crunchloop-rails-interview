# frozen_string_literal: true

module Api
  class BaseController < ActionController::API
    before_action :ensure_json_request

    private

    def ensure_json_request
      raise ActionController::RoutingError, 'JSON format required' unless request.format == :json
    end
  end
end
