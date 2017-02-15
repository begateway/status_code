# frozen_string_literal: true
require 'i18n'

module StatusCode
  LOCALES_PATH = "#{__dir__}/status_code/locales/*.yml".freeze
  I18n.enforce_available_locales = false
  I18n.load_path = Dir[LOCALES_PATH]
  I18n.backend.load_translations

  def self.decode(options)
    if options[:code] && options[:receiver]
      receiver = options[:receiver].to_s.downcase
      code     = options[:code].to_s
      gw       = options[:gateway].to_s.downcase
      locale   = options[:locale] ? options[:locale].to_s.downcase.to_sym : :en
      find_message("#{receiver}.#{gw}.#{code}", "#{receiver}.#{code}", locale)
    end
  end

  private_class_method

  def self.find_message(gw_message_path, general_message_path, locale)
    message(gw_message_path, locale) || message(general_message_path, locale) ||
      message(gw_message_path, :en) || message(general_message_path, :en)
  end

  def self.message(path, locale)
    I18n.t(path, locale: locale) if I18n.exists?(path, locale)
  end
end
