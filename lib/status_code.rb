# frozen_string_literal: true
require 'i18n'

class StatusCode
  attr_reader :code, :gateway, :locales_path, :locales

  def initialize(code, options = {})
    if code.is_a?(String) || code.is_a?(Symbol)
      @code = code
      @gateway = options[:gateway].to_s.downcase
      @locales_path = "#{__dir__}/status_code/locales/*.yml"
      @locales = set_locales
      set_locales_settings
      set_locale(options[:locale].to_s.downcase.to_sym)
    else
      raise ArgumentError, 'The code argument should be String or Symbol'
    end
  end

  def decode(receiver_param)
    receiver = receiver_param.to_s.downcase
    if I18n.exists?("#{receiver}.#{gateway}.#{code}")
      I18n.t("#{receiver}.#{gateway}.#{code}")
    elsif I18n.exists?("#{receiver}.#{code}")
      I18n.t("#{receiver}.#{code}")
    end
  end

  private

  def set_locales
    locales_array = []
    Dir.glob(locales_path) do |file|
      locales_array << File.basename(file, '.yml').to_sym
    end
    locales_array
  end

  def set_locales_settings
    I18n.config.available_locales = locales
    I18n.load_path = Dir[locales_path]
    I18n.backend.load_translations
  end

  def set_locale(locale)
    if locales.include?(locale)
      I18n.locale = locale
    else
      I18n.locale = :en
    end
  end
end
