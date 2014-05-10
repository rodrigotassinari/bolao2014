RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  # check if ALL factories are valid
  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end
end
