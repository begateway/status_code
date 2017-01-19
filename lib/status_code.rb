# frozen_string_literal: true
require 'i18n'
require 'pry'

class StatusCode
  attr_reader :code, :locale

  LOCALES = [:en, :ru].freeze

  def initialize(code, locale = :en)
    @code = code.to_s
    @locale = locale.to_sym if locale
    set_locales_settings
    set_locale
  end

  def decode(receiver)
    I18n.t("#{receiver}.#{code}") if I18n.exists?("#{receiver}.#{code}")
  end

  private

  def set_locales_settings
    I18n.config.available_locales = LOCALES
    I18n.load_path = Dir['./lib/status_code/locales/*.yml']
    I18n.backend.load_translations
  end

  def set_locale
    I18n.locale = locale if LOCALES.include?(locale)
  end
end
