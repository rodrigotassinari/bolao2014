RSpec.configure do |config|
  # pass `timezone: 'Brasilia'` to an example to run it with specific timezone
  config.around(:each) do |example|
    if example.metadata[:time_zone]
      default_timezone = Time.zone.name
      current_timezone = example.metadata[:time_zone]
      raise RuntimeError.new,
        "unavailable timezone: '#{current_timezone}'" unless ActiveSupport::TimeZone.all.map(&:name).include?(current_timezone)
      Time.zone = current_timezone
      example.call
      Time.zone = default_timezone
    else
      example.call
    end
  end
end
