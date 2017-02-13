# frozen_string_literal: true
require 'i18n'

class StatusCode
  LOCALES_PATH = "#{__dir__}/status_code/locales/*.yml".freeze

  def initialize
    specify_locales_settings
  end

  def decode(options)
    if options[:code] && options[:receiver]
      message = find_message(options)
      message == '' ? nil : message
    end
  end

  private

  def set_locales
    locales_array = []
    Dir.glob(LOCALES_PATH) do |file|
      locales_array << File.basename(file, '.yml').to_sym
    end
    locales_array
  end

  def specify_locales_settings
    I18n.enforce_available_locales = false
    I18n.load_path = Dir[LOCALES_PATH]
    I18n.backend.load_translations
  end

  def find_message(options)
    receiver = options[:receiver].to_s.downcase
    code     = options[:code].to_s
    gateway  = options[:gateway].to_s.downcase
    locale   = options[:locale].to_s.downcase.to_sym if options[:locale]
    if I18n.exists?("#{receiver}.#{gateway}.#{code}")
      I18n.t("#{receiver}.#{gateway}.#{code}", locale: locale, default: '')
    elsif I18n.exists?("#{receiver}.#{code}")
      I18n.t("#{receiver}.#{code}", locale: locale, default: '')
    end
  end
end
