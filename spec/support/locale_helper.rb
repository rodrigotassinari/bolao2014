RSpec.configure do |config|
  # pass `i18n: 'pt'` to an example to run it with specific I18n translation
  config.around(:each) do |example|
    if example.metadata[:i18n]
      default_locale = I18n.default_locale
      current_locale = example.metadata[:i18n].to_sym
      raise RuntimeError.new,
        "unavailable locale: '#{current_locale}'" unless I18n.available_locales.include?(current_locale)
      I18n.locale = current_locale
      example.call
      I18n.locale = default_locale
    else
      example.call
    end
  end
end
