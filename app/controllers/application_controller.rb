# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from ActionController::UnknownFormat, with: :raise_unsupported_format
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def raise_unsupported_format
    raise ActionController::RoutingError, 'Not supported format'
  end

  def record_not_found
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end
end
