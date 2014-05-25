RSpec.configure do |config|
  config.around(:each, disable_questions: true) do |example|
    ENV['DISABLE_QUESTIONS'] = "true"
    example.call
    ENV['DISABLE_QUESTIONS'] = nil
  end
end
