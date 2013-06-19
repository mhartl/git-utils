require 'git-utils'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Disallow the old-style 'object.should' syntax.
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
