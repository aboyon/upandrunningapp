require 'database_cleaner'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation, {:only => %w[resources]}
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.clean
  end
end
