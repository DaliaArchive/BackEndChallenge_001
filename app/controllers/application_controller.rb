class ApplicationController < ActionController::API

  before_filter :set_format

  def set_format
    request.format = 'json'
  end
end
