require 'rails_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'

RspecApiDocumentation.configure do |config|
  config.format = :json
  config.curl_host = 'http://ec2-52-39-91-201.us-west-2.compute.amazonaws.com' # Will be used in curl request
  config.api_name = "ChatRooomz API" # Your API name
  config.request_headers_to_include = ["Host", "Content-Type", "access_token"]
  config.response_headers_to_include = ["Host", "Content-Type", "access_token"]
  config.curl_headers_to_filter = ["Authorization"] # Remove this if you want to show Auth headers in request
  config.keep_source_order = true
end