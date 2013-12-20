require 'rubygems' if RUBY_VERSION < '1.9'
require 'rest_client'
values   = "{\n    \"username\": \"inspector_gadget\",\n    \"password\": \"secret\"\n}"
headers  = {:content_type => "application/json"}
response = RestClient.post "http://localhost:9292/inspectors", values, headers
puts response
