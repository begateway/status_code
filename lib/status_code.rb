# frozen_string_literal: true
require 'i18n'

class StatusCode
  APPROVE_CODE = '000'
  DECLINE_CODE = '999'
  LOCALES_PATH = "#{__dir__}/status_code/locales/*.yml".freeze
  I18n.enforce_available_locales = false
  I18n.load_path += Dir[LOCALES_PATH]
  I18n.backend.load_translations

  def self.decode(code, opts = {})
    opts[:receiver] ||= :customer
    opts[:locale]   ||= :en
    new(code, opts).return_message
  end

  def initialize(code, opts)
    @code = code
    @opts = opts
  end

  def return_message
    return if code_blank(:merchant)
    default_code = @opts[:status] ? APPROVE_CODE : DECLINE_CODE
    if code_blank(:customer)
      find_message(default_code)
    else
      find_message(@code)
    end
  end

  private

  def message(path)
    I18n.t(path, locale: @opts[:locale]) if I18n.exists?(path, @opts[:locale])
  end

  def find_message(code)
    message("#{@opts[:receiver]}.#{@opts[:gateway]}.#{code}") ||
      message("#{@opts[:receiver]}.#{code}")
  end

  def code_blank(role)
    @opts[:receiver] == role and (@code.to_s.empty? || find_message(@code).nil?)
  end
end
