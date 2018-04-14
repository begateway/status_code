# frozen_string_literal: true
require 'i18n'

module StatusCode
  APPROVE_CODE = '000'
  DECLINE_CODE = '999'
  LOCALES_PATH = "#{__dir__}/status_code/locales/*.yml".freeze
  I18n.enforce_available_locales = false
  I18n.load_path += Dir[LOCALES_PATH]
  I18n.backend.load_translations

  def self.decode(code, opts = {})
    opts[:receiver] ||= :customer
    opts[:locale] ||= :en

    return_message(code, opts)
  end

  def self.message(path, locale)
    I18n.t(path, locale: locale) if I18n.exists?(path, locale)
  end

  def self.find_message(code, opts)
    message("#{opts[:receiver]}.#{opts[:gateway]}.#{code}", opts[:locale]) ||
      message("#{opts[:receiver]}.#{code}", opts[:locale])
  end

  def self.code_blank(code, opts, role)
    opts[:receiver] == role and (code.to_s.empty? || find_message(code, opts).nil?)
  end

  def self.return_message(code, opts)
    return if code_blank(code, opts, :merchant)
    default_code = opts[:status] ? APPROVE_CODE : DECLINE_CODE
    if code_blank(code, opts, :customer)
      find_message(default_code, opts)
    else
      find_message(code, opts)
    end
  end

  private_class_method :message, :find_message, :code_blank, :return_message
end
