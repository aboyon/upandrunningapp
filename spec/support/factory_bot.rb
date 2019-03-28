require 'factory_bot'

module FactoryBot
  module Syntax
    module Methods
      def fetch(model, attributes)
        klass = build(model).class
        klass.find_by(attributes) || build(model, attributes)
      end
    end
  end
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
