# frozen_string_literal: true
require 'i18n'

class StatusCode
  attr_reader :gateway, :locales
  LOCALES_PATH = "#{__dir__}/status_code/locales/*.yml".freeze

  def initialize(options = {})
    @gateway = options[:gateway].to_s.downcase
    @locales = set_locales
    specify_locales_settings(options[:locale].to_s.downcase.to_sym)
  end

  def decode(code, receiver)
    code ? find_message(code.to_s, receiver.to_s.downcase) : nil
  end

  private

  def set_locales
    locales_array = []
    Dir.glob(LOCALES_PATH) do |file|
      locales_array << File.basename(file, '.yml').to_sym
    end
    locales_array
  end

  def specify_locales_settings(locale)
    I18n.config.available_locales = locales
    I18n.load_path = Dir[LOCALES_PATH]
    I18n.backend.load_translations
    define_locale(locale)
  end

  def define_locale(locale)
    I18n.locale = locales.include?(locale) ? locale : :en
  end

  def find_message(code, receiver)
    if I18n.exists?("#{receiver}.#{gateway}.#{code}")
      I18n.t("#{receiver}.#{gateway}.#{code}")
    elsif I18n.exists?("#{receiver}.#{code}")
      I18n.t("#{receiver}.#{code}")
    end
  end
end
