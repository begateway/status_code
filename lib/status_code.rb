# frozen_string_literal: true
require 'i18n'

module StatusCode
  LOCALES_PATH = "#{__dir__}/status_code/locales/*.yml".freeze
  I18n.enforce_available_locales = false
  I18n.load_path += Dir[LOCALES_PATH]
  I18n.backend.load_translations

  def self.decode(code, options = {})
    if code
      receiver = options[:receiver] || :customer
      gw       = options[:gateway]
      locale   = options[:locale] || :en

      message("#{receiver}.#{gw}.#{code}", locale) ||
        message("#{receiver}.#{code}", locale)
    end
  end

  private_class_method

  def self.message(path, locale)
    I18n.t(path, locale: locale) if I18n.exists?(path, locale)
  end
end
