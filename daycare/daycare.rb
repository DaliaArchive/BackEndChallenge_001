require_relative 'init'
require_relative 'routes/init'

class Daycare < Sinatra::Base

  disable :show_exceptions
  disable :raise_errors
  disable :dump_errors

  before do
    content_type 'application/json'
  end

  error do
    halt json(status: 'error', message: 'internal error')
  end

  not_found do
    halt json(status: 'error', message: 'not found')
  end

end

