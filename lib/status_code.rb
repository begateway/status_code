# frozen_string_literal: true
require 'i18n'

module StatusCode
  DEFAULT_ERROR_CODE   = '999'
  DEFAULT_SUCCESS_CODE = '000'
  LOCALES_PATH = "#{__dir__}/status_code/locales/*.yml".freeze
  I18n.enforce_available_locales = false
  I18n.load_path += Dir[LOCALES_PATH]
  I18n.backend.load_translations

  def self.decode(code, options = {})
    receiver = options[:receiver] || :customer
    gw       = options[:gateway]
    locale   = options[:locale] || :en
    code     = status(options[:successful], code) || code

    message("#{receiver}.#{gw}.#{code}", locale) ||
      message("#{receiver}.#{code}", locale)
  end

  def self.message(path, locale)
    I18n.t(path, locale: locale) if I18n.exists?(path, locale)
  end

  def self.status(successful_transaction, bank_code)
    if successful_transaction
      DEFAULT_SUCCESS_CODE
    elsif bank_code.to_s.empty?
      DEFAULT_ERROR_CODE
    end
  end

  private_class_method :message, :status
end
