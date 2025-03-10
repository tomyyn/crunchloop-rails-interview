# frozen_string_literal: true

module Api
  class BaseController < ActionController::API
    before_action :ensure_json_request

    private

    def ensure_json_request
      # Adding additional check for global accept as it's not correctly taking into account for ActionController::API
      return if request.format.json? || request.accept&.include?('*/*')

      raise ActionController::RoutingError,
            'JSON format required'
    end
  end
end
