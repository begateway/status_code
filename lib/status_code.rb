# frozen_string_literal: true
require 'i18n'
require 'pry'

class StatusCode
  attr_reader :code, :locale, :gateway

  DEFAULT_LOCALE = :en
  LOCALES = [:en, :ru].freeze

  def initialize(code, options = {})
    @code = code.to_s
    @locale = options[:locale].to_sym.downcase if options.key?(:locale)
    @gateway = options[:gateway].to_s.downcase if options[:gateway]
    set_locales_settings
    set_locale
  end

  def decode(receiver)
    if gateway && I18n.exists?("#{receiver}.#{gateway}.#{code}")
      I18n.t("#{receiver}.#{gateway}.#{code}")
    elsif I18n.exists?("#{receiver}.#{code}")
      I18n.t("#{receiver}.#{code}")
    end
  end

  private

  def set_locales_settings
    I18n.config.available_locales = LOCALES
    I18n.load_path = Dir['./lib/status_code/locales/*.yml']
    I18n.backend.load_translations
  end

  def set_locale
    if locale && LOCALES.include?(locale)
      I18n.locale = locale
    else
      I18n.locale = DEFAULT_LOCALE
    end
  end
end
