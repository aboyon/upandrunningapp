module Rspec
  module Helpers
    module ControllerMethods
      def json_response
        JSON.parse(response.body).with_indifferent_access
      end
    end
  end
end

RSpec.configure do |config|
  config.include Rspec::Helpers::ControllerMethods
end
