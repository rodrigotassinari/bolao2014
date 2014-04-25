RSpec.configure do |config|
  # pass `timecop: true` to an example to run it frozen to now
  config.around(:each, timecop: true) do |example|
    Timecop.freeze(Time.zone.now) do
      example.call
    end
  end
end
