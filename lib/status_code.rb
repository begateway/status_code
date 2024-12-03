# frozen_string_literal: true
require 'i18n'

class StatusCode
  APPROVE_CODE = 'S.0000'
  DECLINE_CODE = 'F.0999'
  LOCALES_PATH = "#{__dir__}/status_code/locales/*.yml".freeze
  I18n.enforce_available_locales = false
  I18n.load_path += Dir[LOCALES_PATH]
  I18n.backend.load_translations

  attr_reader :code, :opts

  def self.decode(code, opts = {})
    opts[:receiver] ||= :customer
    opts[:locale]   ||= :en

    return if code.nil? && opts[:status].nil?
    new(code, opts).send("return_message_#{opts[:receiver]}".to_sym)
  end

  def initialize(code, opts)
    @code = code
    @opts = opts
  end

  def return_message_merchant
    find_message(code) unless code_blank(:merchant)
  end

  def return_message_customer
    if code_blank(:customer) && !opts[:status].nil?
      find_friendly_message(opts[:status] ? APPROVE_CODE : DECLINE_CODE)
    else
      find_friendly_message(code)
    end
  end

  private

  def message(code, type)
    I18n.t('bank_codes', locale: opts[:locale], default: {}).dig(:"#{code}", type)
  end

  def find_message(code)
    message(code, :message)
  end

  def find_friendly_message(code)
    message(code, :friendly_message)
  end

  def code_blank(role)
    opts[:receiver] == role and (code.to_s.empty? || find_message(code).nil?)
  end
end
